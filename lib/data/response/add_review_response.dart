import '../model/customer_reviews.dart';

class AddReviewResponse {
  final bool error;
  final String message;
  final List<CustomerReview> customerReviews;

  AddReviewResponse({
    required this.error,
    required this.message,
    required this.customerReviews,
  });

  factory AddReviewResponse.fromJson(Map<String, dynamic> response) {
    return AddReviewResponse(
        error: response['error'],
        message: response['message'],
        customerReviews: (response['customerReviews'] as List)
            .map((e) => CustomerReview.fromJson(e))
            .toList()
    );
  }

}