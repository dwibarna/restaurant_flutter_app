import 'dart:async';

import 'package:floor/floor.dart';
import 'package:restaurant_flutter_app/data/floor/entity/favorite_entity.dart';
import 'package:restaurant_flutter_app/data/floor/restaurant_dao.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
part 'restaurant_database.g.dart';

@Database(version: 1, entities: [RestaurantEntity])
abstract class RestaurantDatabase extends FloorDatabase {
  RestaurantDao get restaurantDao;

  static Future<RestaurantDatabase> initDatabase() async {
    final database = await $FloorRestaurantDatabase
        .databaseBuilder('restaurant.db')
        .build();
    return database;
  }
}

