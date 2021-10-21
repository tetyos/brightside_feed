import 'package:http/http.dart' as http;

class HttpRequestHelper {

  static Future<http.Response> getInitialData(String queryJson) async {
    http.Response response = await http.post(
      Uri.parse('https://6gkjxm84k5.execute-api.eu-central-1.amazonaws.com/get_init_data'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: queryJson,
    );
    return response;
  }

  /// posts the given item. returns true if successful.
  static Future<bool> postItem(String itemAsJson) async {
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
}