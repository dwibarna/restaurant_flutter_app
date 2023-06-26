import 'package:flutter/material.dart';
import 'package:restaurant_flutter_app/data/api/api_service.dart';
import 'package:restaurant_flutter_app/data/response/add_review_response.dart';
import 'package:restaurant_flutter_app/data/response/detail_response.dart';
import 'package:restaurant_flutter_app/provider/result_state.dart';

class DetailProvider extends ChangeNotifier {
  final ApiService apiService;
  final String restaurantId;

  DetailProvider({required this.apiService, required this.restaurantId}) {
    getDetailRestaurant(restaurantId);
  }

  late DetailRestaurantResponse _detailRestaurantResponse;
  late AddReviewResponse _addReviewResponse;
  late ResultState _state;
  String _message = '';

  String get message => _message;

  DetailRestaurantResponse get detailRestaurantResponse =>
      _detailRestaurantResponse;

  AddReviewResponse get addReviewResponse => _addReviewResponse;

  ResultState get state => _state;

  Future<void> getDetailRestaurant(String id) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      _detailRestaurantResponse = await apiService.getDetailRestaurant(id);

      _state = ResultState.hasData;
    } catch (e) {
      _state = ResultState.error;
      _message = 'Error: $e';
    } finally {
      notifyListeners();
    }
  }

  Future<void> postUpdateReview(String id, String review, String name) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      _addReviewResponse = await apiService.addReview(id, name, review);

      if (_addReviewResponse.error != true) {
        _message = 'Success Add Review';
        _state = ResultState.posted;
      } else {
        _message = "Failed to add Review";
        _state = ResultState.error;
      }
    } catch (e) {
      _state = ResultState.error;
      _message = 'Error: $e';
    } finally {
      notifyListeners();
    }
  }
}
