import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:restaurant_flutter_app/data/api/api_service.dart';
import 'package:restaurant_flutter_app/data/floor/entity/favorite_entity.dart';
import 'package:restaurant_flutter_app/provider/detail_provider.dart';
import 'package:restaurant_flutter_app/provider/result_state.dart';

import '../../../data/model/customer_reviews.dart';
import '../../../data/model/detail_restaurant.dart';
import '../../custom_widget/error_widget.dart';
import 'package:http/http.dart' as http;

class DetailScreen extends StatelessWidget {
  final String restaurantId;

  const DetailScreen(this.restaurantId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _builderDetailScreen(context),
    );
  }

  void retryCallBack(BuildContext context) {
    context.read<DetailProvider>().getDetailRestaurant(restaurantId);
  }

  ChangeNotifierProvider<DetailProvider> _builderDetailScreen(
      BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        return DetailProvider(
          apiService: ApiService(http.Client()),
          restaurantId: restaurantId,
        );
      },
      child: Consumer<DetailProvider>(
        builder: (context, state, _) {
          if (state.state == ResultState.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.state == ResultState.hasData) {
            return _buildAllSliverWidget(
                context, state.detailRestaurantResponse.restaurant!);
          } else if (state.state == ResultState.error) {
            return Center(
              child: buildErrorWidget(context, state.message.toString(), () {
                retryCallBack(context);
              }),
            );
          } else {
            return const Center(child: Text(''));
          }
        },
      ),
    );
  }

  CustomScrollView _buildAllSliverWidget(
      BuildContext context, DetailRestaurant detailRestaurant) {
    return CustomScrollView(
      slivers: [
        _buildHeaderSticky(detailRestaurant.pictureId),
        SliverPersistentHeader(
          delegate: _TitleDelegate(
              detailRestaurant, context.read<DetailProvider>().stateFavorite),
          pinned: true,
        ),
        _buildContentBox(context, detailRestaurant),
        _buildSliverBoxListMenu(context, "Food:",
            detailRestaurant.menus.foods.map((e) => e.name).toList()),
        _buildSliverBoxListMenu(context, "Drink:",
            detailRestaurant.menus.drinks.map((e) => e.name).toList()),
        _buildSliverBoxAddReview(context),
        _buildSliverBoxLastReview(
            context, "Last Review", detailRestaurant.customerReviews ?? []),
      ],
    );
  }

  SliverAppBar _buildHeaderSticky(String pictureId) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Image(
          image: NetworkImage(pictureId),
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildContentBox(
      BuildContext context, DetailRestaurant detailRestaurant) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 2,
              color: Colors.grey,
            ),
            const SizedBox(height: 4),
            Text(
              "Description :",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            ReadMoreText(
              detailRestaurant.description,
              trimLines: 3,
              style: Theme.of(context).textTheme.bodyMedium,
              colorClickableText: Colors.green[900],
              trimMode: TrimMode.Line,
              trimCollapsedText: '...Read more',
              trimExpandedText: '...Read less',
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildSliverBoxListMenu(
      BuildContext context, String title, List<String> list) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 2,
              color: Colors.grey,
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 140,
              child: ListView.builder(
                itemCount: list.length,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, idx) {
                  return Card(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          "assets/placeholder_menu.png",
                          fit: BoxFit.fitWidth,
                          width: 120,
                          height: 80,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: SizedBox(
                          width: 110,
                          child: Center(
                            child: Text(
                              list[idx],
                              style: Theme.of(context).textTheme.titleSmall,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverBoxLastReview(
      BuildContext context, String title, List<CustomerReview> list) {
    if (list.isNotEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 2,
                color: Colors.grey,
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              _buildListReview(list),
              const SizedBox(height: 8),
            ],
          ),
        ),
      );
    } else {
      return const Text('');
    }
  }

  Widget _buildSliverBoxAddReview(BuildContext context) {
    String name = '';
    String review = '';

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 2,
              color: Colors.grey,
            ),
            const SizedBox(height: 4),
            Text(
              'Add Review',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(
              height: 8,
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    TextFormField(
                      onChanged: (s) {
                        name = s;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Name',
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      onChanged: (s) {
                        review = s;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Review',
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 32, right: 32, top: 16),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.green),
                        ),
                        onPressed: () {
                          if (name.isNotEmpty && review.isNotEmpty) {
                            context
                                .read<DetailProvider>()
                                .postUpdateReview(restaurantId, review, name)
                                .then((value) => null);
                            retryCallBack(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Please fill name and Review')),
                            );
                          }
                        },
                        child: const Center(
                          child: Text('Submit'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SizedBox _buildListReview(List<CustomerReview> list) {
    return SizedBox(
      height: 140,
//      width: ,
      child: ListView.builder(
        itemCount: list.length,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        scrollDirection: Axis.vertical,
        itemBuilder: (context, idx) {
          return Card(
              child: ListTile(
            title: Text(
              list[idx].name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 4,
                ),
                Text(
                  list[idx].review,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  list[idx].date,
                  style: Theme.of(context).textTheme.bodySmall,
                )
              ],
            ),
          ));
        },
      ),
    );
  }
}

class _TitleDelegate extends SliverPersistentHeaderDelegate {
  final DetailRestaurant restaurant;
  bool isFavorite;

  _TitleDelegate(this.restaurant, this.isFavorite);

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 16, bottom: 16, top: 4),
      alignment: Alignment.bottomLeft,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                restaurant.name,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.location_pin,
                    color: Colors.red,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${restaurant.address} ,${restaurant.city}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              RatingStars(
                value: restaurant.rating,
                starSize: 14,
              ),
            ],
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    context.read<DetailProvider>().updateFavoriteRestaurant(
                        isFavorite,
                        RestaurantEntity(
                            restaurant.id,
                            restaurant.name,
                            restaurant.rating,
                            restaurant.pictureId,
                            restaurant.city
                        )
                    );
                    context.read<DetailProvider>()
                        .getDetailRestaurant(restaurant.id);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 111;

  @override
  double get minExtent => 111;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
