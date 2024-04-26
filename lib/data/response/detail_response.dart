import '../model/detail_restaurant.dart';

class DetailRestaurantResponse {
  final bool error;
  final String message;
  final DetailRestaurant? restaurant;

  DetailRestaurantResponse({
    required this.error,
    required this.message,
    required this.restaurant,
  });

  factory DetailRestaurantResponse.fromJson(Map<String, dynamic> response) {
    return DetailRestaurantResponse(
        error: response['error'],
        message: response['message'],
        restaurant: DetailRestaurant.fromJson(response['restaurant'])
    );
  }
}


