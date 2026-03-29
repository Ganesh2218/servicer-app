import 'package:get/get.dart';
import '../../domain/entities/service_request_entity.dart';
import '../../domain/repositories/service_request_repository.dart';
import '../../core/utils/location_service.dart';
import '../../core/utils/app_snackbar.dart';

class MarketplaceController extends GetxController {
  final ServiceRequestRepository _repository;

  MarketplaceController(this._repository);

  final RxList<ServiceRequestEntity> allRequests = <ServiceRequestEntity>[].obs;
  final RxList<ServiceRequestEntity> filteredRequests = <ServiceRequestEntity>[].obs;
  final RxBool isLoading = false.obs;

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
    
    // Listen for changes in search, filter, sort
    debounce(searchQuery, (_) => _applyFilters(), time: const Duration(milliseconds: 500));
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
          fetched = await _repository.getNearbyRequests(pos.latitude, pos.longitude, 50.0);
        } else {
          fetched = await _repository.getAllRequests();
        }
      } else {
        fetched = await _repository.getAllRequests();
      }
      allRequests.assignAll(fetched);
      _applyFilters();
    } catch (e) {
      AppSnackbar.showError('Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  void _applyFilters() {
    var result = allRequests.toList();

    // Search
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      result = result.where((req) => 
        req.title.toLowerCase().contains(query) || 
        req.category.toLowerCase().contains(query)
      ).toList();
    }

    // Category
    if (selectedCategory.value != 'All') {
      result = result.where((req) => req.category == selectedCategory.value).toList();
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
  }

  void updateSearch(String query) => searchQuery.value = query;
  void updateCategory(String category) => selectedCategory.value = category;
  void updateSort(String sort) => sortBy.value = sort;
  void toggleNearby() => showNearbyOnly.value = !showNearbyOnly.value;
}
