import 'package:flutter/material.dart';
import 'package:restaurant_flutter_app/data/api/api_service.dart';
import 'package:restaurant_flutter_app/provider/result_state.dart';

import '../data/model/restaurant.dart';

class MainProvider extends ChangeNotifier {
  final ApiService apiService;

  MainProvider({required this.apiService}) {
    getListRestaurant();
  }

  List<Restaurant> _restaurantList = [];
  ResultState _state = ResultState.loading;
  String _message = '';

  String get message => _message;

  List<Restaurant> get restaurantList => _restaurantList;

  ResultState get state => _state;

  Future<void> getListRestaurant() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      _restaurantList = await apiService.getListRestaurant();

      if (_restaurantList.isEmpty) {
        _state = ResultState.noData;
        _message = 'Empty Data';
      } else {
        _state = ResultState.hasData;
      }
    } catch (e) {
      _state = ResultState.error;
      _message = 'Error: $e';
    } finally {
      notifyListeners();
    }
  }

  Future<void> getSearchRestaurant(String query) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      _restaurantList = await apiService.getSearchRestaurant(query);

      if (_restaurantList.isEmpty) {
        _state = ResultState.noData;
        _message = 'Empty Data';
      } else {
        _state = ResultState.hasData;
      }
    } catch (e) {
      _state = ResultState.error;
      _message = 'Error: $e';
    } finally {
      notifyListeners();
    }
  }
}
