import 'package:restaurant_flutter_app/data/model/restaurant.dart';

class SearchListResponse {
  final bool error;
  final int founded;
  final List<Restaurant> restaurants;

  SearchListResponse({
    required this.error,
    required this.founded,
    required this.restaurants,
  });

  factory SearchListResponse.fromJson(Map<String, dynamic> response) {
    final List<Restaurant> restaurant = (response['restaurants'] as List)
        .map((e) => Restaurant.fromJson(e))
        .toList();
    return SearchListResponse(
        error: response['error'],
        founded: response['founded'],
        restaurants: restaurant);
  }
}
