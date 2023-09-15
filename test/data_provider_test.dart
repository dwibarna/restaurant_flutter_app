import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:restaurant_flutter_app/data/api/api_service.dart';
import 'package:restaurant_flutter_app/data/model/restaurant.dart';

import 'data_provider_test.mocks.dart';


@GenerateMocks([http.Client])
void main() {

  group('testing get data list restaurant', () {
    test('get data list from api', () async {
      final client = MockClient();

      var dummyResponse =
          '{"error": false, "message": "success", "count": 20, "restaurants": []}';

      when(client.get(Uri.parse("${ApiService.baseUrl}/list")))
      .thenAnswer((_) async => http.Response(dummyResponse, 200));

      expect(await ApiService(client).getListRestaurant(), isA<List<Restaurant>>());
    });

    test('throws an exception if the http call completes with an error', () {
      final client = MockClient();

      when(client.get(Uri.parse("${ApiService.baseUrl}/list")))
      .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(ApiService(client).getListRestaurant(), throwsException);
    });

  });
}
