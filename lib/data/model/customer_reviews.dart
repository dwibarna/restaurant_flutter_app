class CustomerReview {
  final String name;
  final String review;
  final String date;

  CustomerReview({
    required this.name,
    required this.review,
    required this.date,
  });

  factory CustomerReview.fromJson(Map<String, dynamic> response) {
    return CustomerReview(
        name: response['name'],
        review: response['review'],
        date: response['date']);
  }
}