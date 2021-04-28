class PostUserActivityCommentResponse {
  Success success;

  PostUserActivityCommentResponse({
    this.success,
  });

  factory PostUserActivityCommentResponse.fromJson(Map<String, dynamic> json) =>
      PostUserActivityCommentResponse(
        success: Success.fromJson(json["success"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success.toJson(),
      };
}

class Success {
  int fieldCount;
  int affectedRows;
  int insertId;
  String info;
  int serverStatus;
  int warningStatus;

  Success({
    this.fieldCount,
    this.affectedRows,
    this.insertId,
    this.info,
    this.serverStatus,
    this.warningStatus,
  });

  factory Success.fromJson(Map<String, dynamic> json) => Success(
        fieldCount: json["fieldCount"],
        affectedRows: json["affectedRows"],
        insertId: json["insertId"],
        info: json["info"],
        serverStatus: json["serverStatus"],
        warningStatus: json["warningStatus"],
      );

  Map<String, dynamic> toJson() => {
        "fieldCount": fieldCount,
        "affectedRows": affectedRows,
        "insertId": insertId,
        "info": info,
        "serverStatus": serverStatus,
        "warningStatus": warningStatus,
      };
}
