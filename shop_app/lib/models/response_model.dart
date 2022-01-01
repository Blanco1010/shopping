import 'dart:convert';

class ResponseApi {
  bool success;
  String message;
  dynamic error;
  dynamic data;

  ResponseApi({
    required this.success,
    required this.message,
    this.error,
    this.data,
  });

  factory ResponseApi.fromJson(String str) =>
      ResponseApi.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ResponseApi.fromMap(Map<String, dynamic> json) {
    return ResponseApi(
      success: json["success"],
      message: json["message"],
      error: json["error"],
      data: json["data"],
    );
  }

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "error": error ?? 'null',
        "data": data ?? 'null',
      };
}
