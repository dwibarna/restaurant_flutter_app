import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_flutter_app/provider/favorite_provider.dart';
import 'package:restaurant_flutter_app/provider/result_state.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorite"),
      ),
      body: SafeArea(
        child: ChangeNotifierProvider<FavoriteProvider>(
          create: (_) {
            return FavoriteProvider();
          },
          child: Consumer<FavoriteProvider>(
            builder: (context, state, _) {
              if (state.state == ResultState.hasData) {

                return ListView.builder(
                  itemCount: state.list.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, idx) {
                    final item = state.list[idx];
                    return Dismissible(
                      key: UniqueKey(),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 16),
                        child: const Icon(Icons.delete),
                      ),
                      onDismissed: (direction) {
                        context.read<FavoriteProvider>().deleteFavorite(item);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("${item.name} Remove from Favorite"),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image(
                                image: NetworkImage(item.pictureId),
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 200,
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Text(
                                  item.name,
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Text(
                                  item.city,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Padding(
                                padding: const EdgeInsets.only(left: 8, bottom: 8),
                                child: RatingStars(
                                  value: item.rating,
                                ),
                              ),
                              const SizedBox(height: 4),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else if(state.state == ResultState.noData) {
                return Center(
                  child: Text(
                    "No Favorite Data",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                );
              } else {
                return const Text('');
              }
            },
          ),
        ),
      ),
    );
  }
}
