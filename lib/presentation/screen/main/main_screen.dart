import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_flutter_app/data/api/api_service.dart';

import '../../../data/model/restaurant.dart';
import '../../../provider/main_provider.dart';
import '../../../provider/result_state.dart';
import '../../custom_widget/error_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MainScreenState();
  }
}

class _MainScreenState extends State<MainScreen> {
  String queryText = '';
  final TextEditingController _textSearchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    MainProvider(
      apiService: ApiService(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: _buildList(),
          ),
        ),
      ),
    );
  }

  Padding _buildMainHeader(BuildContext context) {
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
          Expanded(child: _buildSearch(context)),
        ],
      ),
    );
  }

  ChangeNotifierProvider<MainProvider> _buildList() {
    return ChangeNotifierProvider(
      create: (_) => MainProvider(
        apiService: ApiService(),
      ),
      child: Consumer<MainProvider>(
        builder: (context, state, _) {
          if (state.state == ResultState.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.state == ResultState.hasData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildMainHeader(context),
                const SizedBox(
                  height: 16,
                ),
                _buildListContent(state.restaurantList)
              ],
            );
          } else if (state.state == ResultState.noData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildMainHeader(context),
                _buildEmptyListWidget(context)
              ],
            );
          } else if (state.state == ResultState.error) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildMainHeader(context),
                buildErrorWidget(context, state.message, () {})
              ],
            );
          } else {
            return const Center(child: Text(''));
          }
        },
      ),
    );
  }

  ListView _buildListContent(
    List<Restaurant> filterRestaurants,
  ) {
    return ListView.builder(
        itemCount: filterRestaurants.length,
        primary: false,
        shrinkWrap: true,
        itemBuilder: (context, idx) {
          final item = filterRestaurants[idx];
          return InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/detailScreen', arguments: item.id);
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

  TextField _buildSearch(BuildContext context) {
    return TextField(
      controller: _textSearchController,
      keyboardType: TextInputType.text,
      onChanged: (s) {
        queryText = s;
      },
      onSubmitted: (s) {
        queryText = s;
        context.read<MainProvider>().getSearchRestaurant(queryText);
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

  Widget _buildEmptyListWidget(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.search_off,
            color: Colors.grey,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            'Data is Empty',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Please try again with other query',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
