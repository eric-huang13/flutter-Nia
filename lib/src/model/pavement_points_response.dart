// To parse this JSON data, do
//
//     final pavementPointsResponse = pavementPointsResponseFromJson(jsonString);
//
//PavementPointsResponse pavementPointsResponseFromJson(String str) => PavementPointsResponse.fromJson(json.decode(str));
//
//String pavementPointsResponseToJson(PavementPointsResponse data) => json.encode(data.toJson());

class PavementPointsResponse {
  bool success;

  PavementPointsResponse({
    this.success,
  });

  factory PavementPointsResponse.fromJson(Map<String, dynamic> json) =>
      PavementPointsResponse(
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
      };
}
