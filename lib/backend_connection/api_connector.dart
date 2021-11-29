import 'dart:convert' as Dart;
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:http/http.dart' as http;
import 'package:nexth/backend_connection/api_key_identifier.dart' as API_Identifiers;
import 'package:nexth/backend_connection/database_query.dart';
import 'package:nexth/model/vote_model.dart';

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

  static Future<List<dynamic>> getItems(DatabaseQuery query) async {
    numberOfHttpRequests++;
    if (numberOfHttpRequests > httpRequestThreshold) return [];
    String queriesAsJson = Dart.jsonEncode(query);

    http.Response response = await http.post(
      Uri.parse('https://6gkjxm84k5.execute-api.eu-central-1.amazonaws.com/get_items'),
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

    List<dynamic> resultsForQuery = Dart.jsonDecode(response.body);
    return resultsForQuery;
  }

  /// posts the given item. returns true if successful.
  static Future<bool> postItem(String itemAsJson) async {
    numberOfHttpRequests++;
    if (numberOfHttpRequests > httpRequestThreshold) return false;

    try {
      AuthSession res = await Amplify.Auth.fetchAuthSession(
        options: CognitoSessionOptions(getAWSCredentials: true),
      );
      AWSCognitoUserPoolTokens userPoolTokens = (res as CognitoAuthSession).userPoolTokens!;

      http.Response response = await http.post(
        Uri.parse('https://6gkjxm84k5.execute-api.eu-central-1.amazonaws.com/post_item'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': userPoolTokens.idToken,
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

  /// checks on which of the given items a user has voted on.
  /// response is a map of json documents, containing the types of votes
  static Future<Map<String, dynamic>> getUserVotes(Set<String> itemIds) async {
    numberOfHttpRequests++;
    if (numberOfHttpRequests > httpRequestThreshold) return {};

    String itemIdsJson = Dart.jsonEncode(itemIds.toList());
    try {
      AuthSession res = await Amplify.Auth.fetchAuthSession(
        options: CognitoSessionOptions(getAWSCredentials: true),
      );
      AWSCognitoUserPoolTokens userPoolTokens = (res as CognitoAuthSession).userPoolTokens!;

      http.Response response = await http.post(
        Uri.parse('https://6gkjxm84k5.execute-api.eu-central-1.amazonaws.com/get_votes'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': userPoolTokens.idToken,
        },
        body: itemIdsJson,
      );
      if (response.statusCode != 200) {
        print("Votes could not be retrieved. Statuscode: ${response.statusCode}");
        print(response.body);
        return {};
      }

      Map<String, dynamic> userVotes = Dart.jsonDecode(response.body);
      return userVotes;
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
    payloadMap[API_Identifiers.postVoteItemId] = model.itemId;
    payloadMap[API_Identifiers.postVoteCategory] = model.voteCategory;
    payloadMap[API_Identifiers.postVoteIncreaseAmount] = isIncrease;
    String payloadJson = Dart.jsonEncode(payloadMap);

    try {
      AuthSession res = await Amplify.Auth.fetchAuthSession(
        options: CognitoSessionOptions(getAWSCredentials: true),
      );
      AWSCognitoUserPoolTokens userPoolTokens = (res as CognitoAuthSession).userPoolTokens!;

      http.Response response = await http.post(
        Uri.parse('https://6gkjxm84k5.execute-api.eu-central-1.amazonaws.com/post_votes'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': userPoolTokens.idToken,
        },
        body: payloadJson,
      );
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
}