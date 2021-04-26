import 'dart:convert';

class WSResponse {
  bool success;
  dynamic response;
  String error;

  WSResponse(this.success, this.response, this.error);

  @override
  String toString() {
    if (response is Map) {
      return json.encode(response);
    }
    return response.toString();
  }
}
