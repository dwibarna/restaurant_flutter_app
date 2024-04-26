import 'package:restaurant_flutter_app/data/model/restaurant.dart';

class RestaurantResponse {
  final bool error;
  final String message;
  final int count;
  final List<Restaurant>? restaurants;

  RestaurantResponse({
    required this.error,
    required this.message,
    required this.count,
    required this.restaurants,
  });

  factory RestaurantResponse.fromJson(Map<String, dynamic> response) {
    final List<Restaurant> restaurant = (response['restaurants'] as List)
        .map((e) => Restaurant.fromJson(e))
        .toList();
    return RestaurantResponse(
        error: response['error'],
        message: response['message'],
        count: response['count'],
        restaurants: restaurant
    );
  }
}
