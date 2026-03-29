abstract class ReviewRepository {
  Future<void> submitReview(String providerId, String customerId, String requestId, double rating, String review);
  Future<double> getAverageRating(String providerId);
}
