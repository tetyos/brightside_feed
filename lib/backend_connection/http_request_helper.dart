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
}