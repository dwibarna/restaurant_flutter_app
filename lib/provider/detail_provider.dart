import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restaurant_flutter_app/data/api/api_service.dart';
import 'package:restaurant_flutter_app/data/floor/entity/favorite_entity.dart';
import 'package:restaurant_flutter_app/data/response/add_review_response.dart';
import 'package:restaurant_flutter_app/data/response/detail_response.dart';
import 'package:restaurant_flutter_app/provider/result_state.dart';

import '../data/floor/restaurant_dao.dart';
import '../data/floor/restaurant_database.dart';

class DetailProvider extends ChangeNotifier {
  final ApiService apiService;
  final String restaurantId;


  DetailProvider({
    required this.apiService,
    required this.restaurantId,
  }) {
    checkStateFavorite();
    getDetailFavorite(restaurantId);
    getDetailRestaurant(restaurantId);
  }

  late RestaurantDao restaurantDao;
  late RestaurantDatabase _restaurantDatabase;
  late DetailRestaurantResponse _detailRestaurantResponse;
  late AddReviewResponse _addReviewResponse;
  late ResultState _state;

  RestaurantEntity? _restaurantEntity;

  String _message = '';

  String get message => _message;

  bool _stateFavorite = false;

  bool get stateFavorite => _stateFavorite;

  RestaurantDatabase get restaurantDatabase => _restaurantDatabase;

  RestaurantEntity? get restaurantEntity => _restaurantEntity;

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

  Future<void> getDetailFavorite(String id) async {
    _restaurantDatabase = await RestaurantDatabase.initDatabase();
    restaurantDao = restaurantDatabase.restaurantDao;
    var data = await restaurantDao.getDetailFavorite(id);
    _restaurantEntity = data;
    notifyListeners();
  }

  Future<void> checkStateFavorite() async {
    _restaurantDatabase = await RestaurantDatabase.initDatabase();
    restaurantDao = restaurantDatabase.restaurantDao;
    var data = await restaurantDao.getDetailFavorite(restaurantId);
    if (data != null) {
      _stateFavorite = true;
    } else {
      _stateFavorite = false;
    }
    notifyListeners();
  }


  Future<void> updateFavoriteRestaurant(bool state,
      RestaurantEntity entity) async {
//    _state = ResultState.loading;
    _restaurantDatabase = await RestaurantDatabase.initDatabase();
    restaurantDao = restaurantDatabase.restaurantDao;
    if (!stateFavorite) {
      await restaurantDao.insertFavoriteRestaurant(entity);
    } else {
      await restaurantDao.deleteFavoriteRestaurant(entity);
    }
    checkStateFavorite();
    notifyListeners();
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
