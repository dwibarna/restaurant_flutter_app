
import 'category.dart';
import 'customer_reviews.dart';
import 'menu.dart';

class DetailRestaurant {
  final String id;
  final String name;
  final String description;
  final String city;
  final String address;
  final String pictureId;
  final List<Category> categories;
  final Menu menus;
  final double rating;
  final List<CustomerReview>? customerReviews;

  DetailRestaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.address,
    required this.pictureId,
    required this.categories,
    required this.menus,
    required this.rating,
    required this.customerReviews,
  });

  factory DetailRestaurant.fromJson(Map<String, dynamic> response) {
    return DetailRestaurant(
        id: response['id'],
        name: response['name'],
        description: response['description'],
        city: response['city'],
        address: response['address'],
        pictureId:
        "https://restaurant-api.dicoding.dev/images/medium/${response['pictureId']}",
        categories: (response['categories'] as List)
            .map((e) => Category.fromJson(e))
            .toList(),
        menus: Menu.fromJson(response['menus']),
        rating: response['rating'].toDouble(),
        customerReviews: (response['customerReviews'] as List)
            .map((e) => CustomerReview.fromJson(e))
            .toList());
  }
}