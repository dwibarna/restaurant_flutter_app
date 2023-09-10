import 'package:floor/floor.dart';

import 'entity/favorite_entity.dart';

@dao
abstract class RestaurantDao {
  @Query(
      'SELECT * FROM restaurant order by id asc')
  Future<List<RestaurantEntity>> getAllFavoriteRestaurant();

  @Query('SELECT * FROM restaurant where id = :id')
  Future<RestaurantEntity?> getDetailFavorite(String id);

  @insert
  Future<void> insertFavoriteRestaurant(RestaurantEntity restaurantEntity);

  @delete
  Future<void> deleteFavoriteRestaurant(RestaurantEntity restaurantEntity);
}
