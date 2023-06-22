import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:restaurant_flutter_app/model/restaurant.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MainScreenState();
  }
}

class _MainScreenState extends State<MainScreen> {
  String queryText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildMainHeader(),
                const SizedBox(
                  height: 16,
                ),
                _buildList(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding _buildMainHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Image(
            image: AssetImage("assets/restaurant_logo.png"),
            width: 64,
            height: 64,
          ),
          const SizedBox(
            width: 4,
          ),
          Expanded(child: _buildSearch()),
        ],
      ),
    );
  }

  FutureBuilder<String> _buildList(BuildContext context) {
    return FutureBuilder<String>(
        future: DefaultAssetBundle.of(context)
            .loadString('assets/local_restaurant.json'),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Center(
                child: Text("${snapshot.hasError}"),
              ),
            );
          } else if (snapshot.hasData) {
            final List<Restaurant> restaurants = parseRestaurant(snapshot.data);
            final filterRestaurants = restaurants.where((element) {
              if (queryText.isEmpty) {
                return true;
              } else {
                return element.name
                    .toLowerCase()
                    .contains(queryText.toLowerCase());
              }
            }).toList();
            return _buildListContent(filterRestaurants);
          } else {
            return const Center(
              child: Text('No Data'),
            );
          }
        });
  }

  ListView _buildListContent(List<Restaurant> filterRestaurants,) {
    return ListView.builder(
        itemCount: filterRestaurants.length,
        primary: false,
        shrinkWrap: true,
        itemBuilder: (context, idx) {
          final item = filterRestaurants[idx];
          return InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/detailScreen', arguments: item);
            },
            child: _buildListItem(item, context),
          );
        });
  }

  Card _buildListItem(Restaurant item, BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image(
              image: NetworkImage(item.pictureId),
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
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
          const SizedBox(
            height: 4,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: RatingStars(
              value: item.rating,
            ),
          ),
          const SizedBox(
            height: 4,
          )
        ],
      ),
    );
  }

  TextField _buildSearch() {
    return TextField(
      keyboardType: TextInputType.text,
      onChanged: (s) {
        queryText = s;
      },
      onSubmitted: (s) {
        setState(() {
          queryText = s;
        });
      },
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide.none),
          hintText: "Search Restaurant",
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: const Icon(Icons.search),
          ),
          filled: true,
          fillColor: Colors.green.shade100),
    );
  }
}
