import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../../domain/entities/service_request_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/service_request_repository.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../core/utils/location_service.dart';
import '../../core/utils/app_snackbar.dart';

class MarketplaceController extends GetxController {
  final ServiceRequestRepository _repository;
  final AuthRepository _authRepository;

  MarketplaceController(this._repository, this._authRepository);

  final RxList<ServiceRequestEntity> allRequests = <ServiceRequestEntity>[].obs;
  final RxList<ServiceRequestEntity> filteredRequests =
      <ServiceRequestEntity>[].obs;
  final RxBool isLoading = false.obs;

  /// Cache of fetched user profiles keyed by user ID.
  final RxMap<String, UserEntity> userCache = <String, UserEntity>{}.obs;

  // Search, Filter, Sort State
  final RxString searchQuery = ''.obs;
  final RxString selectedCategory = 'All'.obs;
  final RxString sortBy = 'Latest'.obs; // Latest, Oldest, Budget
  final RxBool showNearbyOnly = false.obs;

  final List<String> categories = [
    'All',
    'Plumbing',
    'Electrical',
    'Cleaning',
    'Beauty',
    'Painting',
    'Moving',
  ];

  final List<String> sortOptions = ['Latest', 'Oldest', 'Budget'];

  @override
  void onInit() {
    super.onInit();
    fetchRequests();
    initSpeech();

    // Listen for changes in search, filter, sort
    debounce(
      searchQuery,
      (_) => _applyFilters(),
      time: const Duration(milliseconds: 500),
    );
    ever(selectedCategory, (_) => _applyFilters());
    ever(sortBy, (_) => _applyFilters());
    ever(showNearbyOnly, (_) => fetchRequests());
  }

  Future<void> fetchRequests() async {
    isLoading.value = true;
    try {
      List<ServiceRequestEntity> fetched;
      if (showNearbyOnly.value) {
        final pos = await LocationService.getCurrentLocation();
        if (pos != null) {
          fetched = await _repository.getNearbyRequests(
            pos.latitude,
            pos.longitude,
            50.0,
          );
        } else {
          fetched = await _repository.getAllRequests();
        }
      } else {
        fetched = await _repository.getAllRequests();
      }
      allRequests.assignAll(fetched);
      _applyFilters();

      // Batch-fetch user info for all unique creator IDs (skip already cached)
      final uncachedIds = fetched
          .map((r) => r.createdBy)
          .toSet()
          .where((id) => id.isNotEmpty && !userCache.containsKey(id))
          .toList();

      if (uncachedIds.isNotEmpty) {
        final results = await Future.wait(
          uncachedIds.map((id) => _authRepository.getUserById(id)),
        );
        for (var i = 0; i < uncachedIds.length; i++) {
          final user = results[i];
          if (user != null) {
            userCache[uncachedIds[i]] = user;
          }
        }
      }
    } catch (e) {
      AppSnackbar.showError('Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  /// Returns the cached [UserEntity] for a given user ID, or null if not yet loaded.
  UserEntity? getUserForRequest(String userId) => userCache[userId];

  String normalize(String input) {
    return input.toLowerCase().trim();
  }

  String detectCategory(String query) {
    final q = normalize(query);

    if (q.contains('pipe') ||
        q.contains('water') ||
        q.contains('leak') ||
        q.contains('bathroom') ||
        q.contains('tap')) {
      return 'Plumbing';
    }

    if (q.contains('electric') ||
        q.contains('light') ||
        q.contains('fan') ||
        q.contains('wiring')) {
      return 'Electrical';
    }

    if (q.contains('clean') ||
        q.contains('maid') ||
        q.contains('housekeeping')) {
      return 'Cleaning';
    }

    if (q.contains('paint')) return 'Painting';

    if (q.contains('shift') || q.contains('move') || q.contains('transport')) {
      return 'Moving';
    }

    if (q.contains('beauty') || q.contains('salon') || q.contains('hair')) {
      return 'Beauty';
    }

    return 'All';
  }

  void _applyFilters() {
    var result = allRequests.toList();

    final query = normalize(searchQuery.value);

    if (query.isNotEmpty) {
      final detectedCategory = detectCategory(query);

      result = result.where((req) {
        final title = normalize(req.title);
        final category = normalize(req.category);

        // Direct match
        final directMatch = title.contains(query) || category.contains(query);

        // AI intent match
        final intentMatch =
            detectedCategory != 'All' && req.category == detectedCategory;

        return directMatch || intentMatch;
      }).toList();

      result.sort((a, b) {
        final scoreA = getScore(a, query, detectedCategory);
        final scoreB = getScore(b, query, detectedCategory);
        return scoreB.compareTo(scoreA);
      });
    }

    // Category filter (manual selection)
    if (selectedCategory.value != 'All') {
      result = result
          .where((req) => req.category == selectedCategory.value)
          .toList();
    }

    // Sorting
    switch (sortBy.value) {
      case 'Latest':
        result.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        break;
      case 'Oldest':
        result.sort((a, b) => a.timestamp.compareTo(b.timestamp));
        break;
      case 'Budget':
        result.sort((a, b) => (b.budget ?? 0).compareTo(a.budget ?? 0));
        break;
    }

    filteredRequests.assignAll(result);
  }
  /* void _applyFilters() {
    var result = allRequests.toList();

    // Search
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      result = result
          .where(
            (req) =>
                req.title.toLowerCase().contains(query) ||
                req.category.toLowerCase().contains(query),
          )
          .toList();
    }

    // Category
    if (selectedCategory.value != 'All') {
      result = result
          .where((req) => req.category == selectedCategory.value)
          .toList();
    }

    // Sort
    switch (sortBy.value) {
      case 'Latest':
        result.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        break;
      case 'Oldest':
        result.sort((a, b) => a.timestamp.compareTo(b.timestamp));
        break;
      case 'Budget':
        result.sort((a, b) => (b.budget ?? 0).compareTo(a.budget ?? 0));
        break;
    }

    filteredRequests.assignAll(result);
  } */

  void updateSearch(String query) => searchQuery.value = query;
  void updateCategory(String category) => selectedCategory.value = category;
  void updateSort(String sort) => sortBy.value = sort;
  void toggleNearby() => showNearbyOnly.value = !showNearbyOnly.value;

  SpeechToText speech = SpeechToText();
  var isListening = false.obs;

  void initSpeech() async {
    await speech.initialize();
  }

  /* void startListening() async {
    final hasPermission = await requestMicPermission();

    if (!hasPermission) return;

    isListening.value = true;

    await speech.listen(
      onResult: (result) {
        print("result==> ${result}");
        final text = result.recognizedWords;
        print("text==> ${text}");
        updateSearch(text);

        if (result.finalResult) {
          stopListening();
        }
      },
    );
  } */
  void startListening() async {
    FocusManager.instance.primaryFocus?.unfocus(); // 🔥 CLOSE KEYBOARD

    final hasPermission = await requestMicPermission();
    if (!hasPermission) return;

    isListening.value = true;

    await speech.listen(
      onResult: (result) {
        final text = result.recognizedWords;

        searchQuery.value = TextEditingValue(
          text: text,
          selection: TextSelection.collapsed(offset: text.length),
        ).toString();

        searchQuery.value = text;

        if (result.finalResult) {
          stopListening();
        }
      },
    );
  }

  void stopListening() async {
    await speech.stop();
    isListening.value = false;
  }

  int getScore(
    ServiceRequestEntity req,
    String query,
    String detectedCategory,
  ) {
    int score = 0;

    final title = normalize(req.title);

    if (title.contains(query)) score += 3;
    if (req.category == detectedCategory) score += 5;
    if (title.startsWith(query)) score += 2;

    return score;
  }

  Future<bool> requestMicPermission() async {
    final status = await Permission.microphone.request();

    if (status.isGranted) {
      return true;
    } else {
      AppSnackbar.showError("Microphone permission is required");
      return false;
    }
  }
}
