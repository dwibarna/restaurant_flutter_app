import 'drink.dart';
import 'food.dart';

class Menu {
  final List<Food> foods;
  final List<Drink> drinks;

  Menu({
    required this.foods,
    required this.drinks,
  });
  factory Menu.fromJson(Map<String, dynamic> menus) {

    final List<Food> food = (menus['foods'] as List).map((food) => Food.fromJson(food)).toList();
    final List<Drink> drink = (menus['drinks'] as List).map((drink) => Drink.fromJson(drink)).toList();
    return Menu(
        foods: food,
        drinks: drink
    );
  }
}