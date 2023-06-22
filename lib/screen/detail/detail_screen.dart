import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';

import '../../model/restaurant.dart';

class DetailScreen extends StatelessWidget {
  final Restaurant restaurant;

  const DetailScreen(this.restaurant, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildHeaderSticky(),
          SliverPersistentHeader(
            delegate: _TitleDelegate(restaurant),
            pinned: true,
          ),
          _buildContentBox(context),
          _buildSliverBoxListMenu(context, "Food:",
              restaurant.menu.foods.map((e) => e.name).toList()),
          _buildSliverBoxListMenu(context, "Drink:",
              restaurant.menu.drinks.map((e) => e.name).toList()),
        ],
      ),
    );
  }

  SliverAppBar _buildHeaderSticky() {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Image(
          image: NetworkImage(restaurant.pictureId),
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildContentBox(BuildContext context) {
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
            Text(
              restaurant.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
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
}

class _TitleDelegate extends SliverPersistentHeaderDelegate {
  final Restaurant restaurant;

  _TitleDelegate(this.restaurant);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 16, bottom: 16, top: 4),
      alignment: Alignment.bottomLeft,
      child: Column(
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
                restaurant.city,
                style: Theme.of(context).textTheme.bodyLarge,
              )
            ],
          ),
          const SizedBox(height: 8),
          RatingStars(
            value: restaurant.rating,
            starSize: 14,
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
