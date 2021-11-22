import 'dart:convert' as Dart;
import 'package:http/http.dart' as http;
import 'package:nexth/backend_connection/database_query.dart';
import 'package:nexth/model/item_data.dart';

class APIConnector {
  static int httpRequestThreshold = 100;
  static int numberOfHttpRequests = 0;


  static Future<http.Response> getInitialData(String allQueriesJson) async {
    numberOfHttpRequests++;
    if (numberOfHttpRequests > httpRequestThreshold) return http.Response("To many http requests", 400);

    http.Response response = await http.post(
      Uri.parse('https://6gkjxm84k5.execute-api.eu-central-1.amazonaws.com/get_init_data'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: allQueriesJson,
    );
    return response;
  }

  static Future<List<ItemData>> getInitialDataSingleQuery(DatabaseQuery query) async {
    numberOfHttpRequests++;
    if (numberOfHttpRequests > httpRequestThreshold) return [];

    List<DatabaseQuery> queries = [];
    queries.add(query);
    String queriesAsJson = Dart.jsonEncode(queries);

    http.Response response = await http.post(
      Uri.parse('https://6gkjxm84k5.execute-api.eu-central-1.amazonaws.com/get_init_data'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: queriesAsJson,
    );


    if (response.statusCode != 200) {
      print("Items could not be loaded. Statuscode: ${response.statusCode}");
      print(response.body);
      return [];
    }

    // parse results and init models
    List<ItemData> returnedItems = [];
    List<dynamic> resultsArray = Dart.jsonDecode(response.body);
    List<dynamic> resultsForQuery = resultsArray.first;
    for (dynamic itemJson in resultsForQuery) {
      returnedItems.add(ItemData.fromJson(itemJson));
    }
    return returnedItems;
  }

  /// posts the given item. returns true if successful.
  static Future<bool> postItem(String itemAsJson) async {
    numberOfHttpRequests++;
    if (numberOfHttpRequests > httpRequestThreshold) return false;

    try {
      http.Response response = await http.post(
        Uri.parse('https://6gkjxm84k5.execute-api.eu-central-1.amazonaws.com/post_item'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: itemAsJson,
      );
      if (response.statusCode == 200) {
        return true;
      }
      print("Item could not be posted. StatusCode: ${response.statusCode}");
      print(response.body);
    } catch (e) {
      print("Item could not be posted.");
      print(e);
    }
    return false;
  }

  /// posts the given rating. returns true if successful.
  static Future<bool> postRating(String id, String ratingType) async {
    Map<String, String?> payloadMap = {};
    payloadMap['itemId'] = id;
    payloadMap[ratingType] = '1';
    String payloadJson = Dart.jsonEncode(payloadMap);

    numberOfHttpRequests++;
    if (numberOfHttpRequests > httpRequestThreshold) return false;

    try {
      http.Response response = await http.post(
        Uri.parse('https://6gkjxm84k5.execute-api.eu-central-1.amazonaws.com/post_rating'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: payloadJson,
      );
      if (response.statusCode == 200) {
        return true;
      }
      print("Rating could not be posted. StatusCode: ${response.statusCode}");
      print(response.body);
    } catch (e) {
      print("Rating could not be posted.");
      print(e);
    }
    return false;
  }
}