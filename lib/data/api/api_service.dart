import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:restaurant_flutter_app/data/model/restaurant.dart';
import 'package:restaurant_flutter_app/data/response/add_review_response.dart';
import 'package:restaurant_flutter_app/data/response/detail_response.dart';
import 'package:restaurant_flutter_app/data/response/restaurant_response.dart';
import 'package:restaurant_flutter_app/data/response/search_list_response.dart';

class ApiService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev';
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  Future<List<Restaurant>> getListRestaurant() async {
    try {
      final response = await http.get(Uri.parse("$_baseUrl/list"));

      if (response.statusCode == 200) {
        return RestaurantResponse.fromJson(json.decode(response.body))
            .restaurants ??
            [];
      } else {
        throw 'Failed to load restaurant data from API';
      }
    } on http.ClientException {
      throw 'Failed to connect to the internet';
    } catch (error) {
      throw 'Unknown error occurred';
    }
  }

  Future<List<Restaurant>> getSearchRestaurant(String query) async {
    try {
      final response = await http.get(Uri.parse("$_baseUrl/search?q=$query"));

      if (response.statusCode == 200) {
        return SearchListResponse.fromJson(json.decode(response.body))
            .restaurants;
      } else {
        throw 'Failed to search restaurants from API';
      }
    } on http.ClientException {
      throw 'Failed to connect to the internet';
    } catch (error) {
      throw 'Unknown error occurred';
    }
  }

  Future<DetailRestaurantResponse> getDetailRestaurant(String id) async {
    try {
      final response = await http.get(Uri.parse("$_baseUrl/detail/$id"));
      if (response.statusCode == 200) {
        return DetailRestaurantResponse.fromJson(json.decode(response.body));
      } else {
        throw 'Failed to load restaurant detail';
      }
    } on http.ClientException {
      throw 'Failed to connect to the internet';
    } catch (error) {
      throw 'Unknown error occurred';
    }
  }

  Future<AddReviewResponse> addReview(
      String id,
      String name,
      String review,
      ) async {
    try {
      const String url = '$_baseUrl/review';

      final Map<String, dynamic> requestBody = {
        'id': id,
        'name': name,
        'review': review,
      };
      final String requestBodyJson = json.encode(requestBody);
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: requestBodyJson,
      );
      if (response.statusCode == 201) {
        return AddReviewResponse.fromJson(json.decode(response.body));
      } else {
        throw 'Failed to post review to API';
      }
    } on http.ClientException {
      throw 'Failed to connect to the internet';
    } catch (error) {
      throw 'Unknown error occurred';
    }
  }
}
