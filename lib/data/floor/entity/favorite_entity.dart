import 'package:floor/floor.dart';

@Entity(tableName: 'restaurant')
class RestaurantEntity {
  @PrimaryKey()
  final String id;
  final String name;
  final double rating;
  final String pictureId;
  final String city;

  RestaurantEntity(this.id, this.name, this.rating, this.pictureId, this.city);
}
