import 'dart:convert' as Dart;
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:http/http.dart' as http;
import 'package:brightside_feed/backend_connection/api_key_identifier.dart' as API_Identifier;
import 'package:brightside_feed/backend_connection/database_query.dart';
import 'package:brightside_feed/backend_connection/item_update.dart';
import 'package:brightside_feed/model/item_data.dart';
import 'package:brightside_feed/model/vote_model.dart';
import 'package:brightside_feed/project_config.dart';

class APIConnector {
  static int httpRequestThreshold = 100;
  static int numberOfHttpRequests = 0;

  static Future<dynamic> getInitialData(String allQueriesJson, bool isUserLoggedIn) async {
    numberOfHttpRequests++;
    if (numberOfHttpRequests > httpRequestThreshold) return null;

    try {
      http.Response response;
      if (isUserLoggedIn) {
        response = await httpPostAuthorized(
            Uri.parse(
                '$backendApiUrl/get_init_data_authorized'),
            allQueriesJson);
      } else {
        response = await http.post(
          Uri.parse('$backendApiUrl/get_init_data'),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: allQueriesJson,
        );
      }
      if (response.statusCode != 200) {
        print("Items could not be loaded. Statuscode: ${response.statusCode}");
        print(response.body);
        return null;
      }
      return Dart.jsonDecode(response.body);
    } catch (e) {
      print("Items could not be loaded.");
      print(e);
      return null;
    }
  }

  static Future<List<dynamic>> getItems(DatabaseQuery query, bool isUserLoggedIn) async {
    numberOfHttpRequests++;
    if (numberOfHttpRequests > httpRequestThreshold) return [];
    String queriesAsJson = Dart.jsonEncode(query);

    try {
      http.Response response;
      if (isUserLoggedIn) {
        response = await httpPostAuthorized(
            Uri.parse(
                '$backendApiUrl/get_items_authorized'),
            queriesAsJson);
      } else {
        response = await http.post(
          Uri.parse('$backendApiUrl/get_items'),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: queriesAsJson,
        );
      }

      if (response.statusCode != 200) {
        print("Items could not be loaded. Statuscode: ${response.statusCode}");
        print(response.body);
        return [];
      }

      List<dynamic> resultsForQuery = Dart.jsonDecode(response.body);
      return resultsForQuery;
    } catch (e) {
      print("Items could not be loaded.");
      print(e);
      return [];
    }
  }

  /// posts the given item. returns true if successful.
  static Future<ItemData?> postItem(String itemAsJson) async {
    numberOfHttpRequests++;
    if (numberOfHttpRequests > httpRequestThreshold) return null;

    try {
      http.Response response = await httpPostAuthorized(
          Uri.parse('$backendApiUrl/post_item'),
          itemAsJson);
      if (response.statusCode == 200) {
        Map<String, dynamic> itemJson = Dart.jsonDecode(response.body);
        ItemData itemData = ItemData.fromJson(itemJson);
        return itemData;
      }
      print("Item could not be posted. StatusCode: ${response.statusCode}");
      print(response.body);
    } catch (e) {
      print("Item could not be posted.");
      print(e);
    }
    return null;
  }

  /// retrieves user data (such as user name, admin status)
  /// and checks on which of the given items a user has already voted on.
  /// response is a map of json documents, containing the types of votes per item and a user-data-document
  static Future<Map<String, dynamic>> getUserData(Set<String> itemIds) async {
    numberOfHttpRequests++;
    if (numberOfHttpRequests > httpRequestThreshold) return {};

    String itemIdsJson = Dart.jsonEncode(itemIds.toList());
    try {
      http.Response response = await httpPostAuthorized(
          Uri.parse('$backendApiUrl/get_user_data'),
          itemIdsJson);
      if (response.statusCode != 200) {
        print("Votes could not be retrieved. Statuscode: ${response.statusCode}");
        print(response.body);
        return {};
      }

      Map<String, dynamic> userData = Dart.jsonDecode(response.body);
      return userData;
    } catch (e) {
      print("Votes could not be retrieved.");
      print(e);
      return {};
    }
  }

  /// posts the given vote. returns true if successful.
  static Future<bool> postVote(VoteModel model, {required bool isIncrease}) async {
    // await Future.delayed(Duration(seconds: 10));
    numberOfHttpRequests++;
    if (numberOfHttpRequests > httpRequestThreshold) return false;

    Map<String, dynamic> payloadMap = {};
    payloadMap[API_Identifier.postVote_ItemId_Key] = model.itemId;
    payloadMap[API_Identifier.postVote_VoteCategory_Key] = model.voteIdentifier;
    payloadMap[API_Identifier.postVote_IncreaseAmount_Key] = isIncrease;
    String payloadJson = Dart.jsonEncode(payloadMap);

    try {
      http.Response response = await httpPostAuthorized(
          Uri.parse('$backendApiUrl/post_votes'),
          payloadJson);
      if (response.statusCode == 200) {
        return true;
      }
      print("Vote could not be processed. StatusCode: ${response.statusCode}");
      print(response.body);
    } catch (e) {
      print("Vote could not be processed.");
      print(e);
    }
    return false;
  }

  /// executes the given admin action. returns true if successful.
  static Future<bool> postAdminAction(String actionType, String itemId) async {
    numberOfHttpRequests++;
    if (numberOfHttpRequests > httpRequestThreshold) return false;

    Map<String, dynamic> payloadMap = {};
    payloadMap[API_Identifier.adminAction_ItemId_Key] = itemId;
    payloadMap[API_Identifier.adminAction_ActionType_Key] = actionType;
    String payloadJson = Dart.jsonEncode(payloadMap);

    try {
      http.Response response = await httpPostAuthorized(
          Uri.parse('$backendApiUrl/post_admin_action'),
          payloadJson);
      if (response.statusCode == 200) {
        return true;
      }
      print("Admin action could not be processed. StatusCode: ${response.statusCode}");
      print(response.body);
    } catch (e) {
      print("Admin action could not be processed.");
      print(e);
    }
    return false;
  }

  /// executes the given update.  returns true if successful.
  static Future<bool> updateItem(ItemUpdate itemUpdate) async {
    numberOfHttpRequests++;
    if (numberOfHttpRequests > httpRequestThreshold) return false;
    String payloadJson = Dart.jsonEncode(itemUpdate);

    try {
      http.Response response = await httpPostAuthorized(
          Uri.parse('$backendApiUrl/update_item'),
          payloadJson);
      if (response.statusCode == 200) {
        return true;
      }
      print("Item update not be processed. StatusCode: ${response.statusCode}");
      print(response.body);
    } catch (e) {
      print("Item update could not be processed.");
      print(e);
    }
    return false;
  }

  /// executes the given update. returns true if successful.
  static Future<bool> updateScrapedItem(ItemUpdate itemUpdate) async {
    numberOfHttpRequests++;
    if (numberOfHttpRequests > httpRequestThreshold) return false;
    String payloadJson = Dart.jsonEncode(itemUpdate);

    try {
      http.Response response = await httpPostAuthorized(
          Uri.parse('$backendApiUrl/update_scraped_item'),
          payloadJson);
      if (response.statusCode == 200) {
        return true;
      }
      print("Scraped item update not be processed. StatusCode: ${response.statusCode}");
      print(response.body);
    } catch (e) {
      print("Scraped item update could not be processed.");
      print(e);
    }
    return false;
  }

  static Future<http.Response> httpPostAuthorized(Uri uri, String bodyString) async {
    AuthSession res = await Amplify.Auth.fetchAuthSession(
      options: CognitoSessionOptions(getAWSCredentials: true),
    );
    AWSCognitoUserPoolTokens userPoolTokens = (res as CognitoAuthSession).userPoolTokens!;

    http.Response response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': userPoolTokens.idToken,
      },
      body: bodyString,
    );
    return response;
  }
}