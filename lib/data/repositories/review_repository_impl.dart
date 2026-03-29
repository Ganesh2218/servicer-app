import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repositories/review_repository.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> submitReview(String providerId, String customerId, String requestId, double rating, String review) async {
    await _firestore.collection('reviews').add({
      'providerId': providerId,
      'customerId': customerId,
      'requestId': requestId,
      'rating': rating,
      'review': review,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Optionally update user's overall rating
    final newAvg = await getAverageRating(providerId);
    await _firestore.collection('users').doc(providerId).update({
      'rating': newAvg,
    });
  }

  @override
  Future<double> getAverageRating(String providerId) async {
    final snapshot = await _firestore
        .collection('reviews')
        .where('providerId', isEqualTo: providerId)
        .get();

    if (snapshot.docs.isEmpty) return 0.0;

    double total = 0;
    for (var doc in snapshot.docs) {
      total += (doc.data()['rating'] as num).toDouble();
    }
    return total / snapshot.docs.length;
  }
}
