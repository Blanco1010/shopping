import 'dart:convert';

class ResponseApi {
  bool success;
  String message;
  String error;
  String? data;

  ResponseApi({
    required this.success,
    required this.message,
    required this.error,
    this.data,
  });

  factory ResponseApi.fromJson(String str) =>
      ResponseApi.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ResponseApi.fromMap(Map<String, dynamic> json) {
    try {
      data:
      json['data'];
    } catch (error) {
      print(error);
    }

    return ResponseApi(
      success: json["success"],
      message: json["message"],
      error: json["error"],
    );
  }

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "error": error,
      };
}
