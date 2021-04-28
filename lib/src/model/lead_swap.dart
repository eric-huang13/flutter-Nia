class LeadSwapResponse {
  bool success;

  LeadSwapResponse({
    this.success,
  });

  factory LeadSwapResponse.fromJson(Map<String, dynamic> json) => LeadSwapResponse(
    success: json["success"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
  };
}