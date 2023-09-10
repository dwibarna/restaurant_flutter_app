import 'package:flutter/material.dart';
import 'package:restaurant_flutter_app/data/floor/restaurant_database.dart';
import 'package:restaurant_flutter_app/provider/result_state.dart';

import '../data/floor/entity/favorite_entity.dart';

class FavoriteProvider extends ChangeNotifier {
  FavoriteProvider() {
    getListFavorite();
  }

  late RestaurantDatabase _restaurantDatabase;
  RestaurantDatabase get restaurantDatabase => _restaurantDatabase;

  late List<RestaurantEntity> _list;
  List<RestaurantEntity> get list => _list;

  ResultState _state = ResultState.loading;
  ResultState get state => _state;

  Future<void> getListFavorite() async {
    _restaurantDatabase = await RestaurantDatabase.initDatabase();
    _list = await restaurantDatabase.restaurantDao.getAllFavoriteRestaurant();
    if(list.isEmpty) {
      _state = ResultState.noData;
    } else {
      _state = ResultState.hasData;
    }
    notifyListeners();
  }

  Future<void> deleteFavorite(RestaurantEntity entity) async {
    _restaurantDatabase = await RestaurantDatabase.initDatabase();
    _restaurantDatabase.restaurantDao.deleteFavoriteRestaurant(entity);
    getListFavorite();
  }
}
