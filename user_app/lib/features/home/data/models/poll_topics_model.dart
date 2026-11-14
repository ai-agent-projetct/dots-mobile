class PollTopicsResponseModel {
  PollTopicsResponseModel({
    this.status,
    this.msg,
    this.pollTopicsData,
  });

  dynamic status;
  dynamic msg;
  List<PollTopicsData>? pollTopicsData;

  factory PollTopicsResponseModel.fromJson(Map<String, dynamic> json) =>
      PollTopicsResponseModel(
        status: json["status"],
        msg: json["message"],
        pollTopicsData: json["data"] != null
            ? List<PollTopicsData>.from(
                json["data"].map((x) => PollTopicsData.fromJson(x)))
            : [],
      );
}

class PollTopicsData {
  PollTopicsData({
    this.topicId,
    this.topic,
    this.isActive,
  });

  dynamic topicId;
  dynamic topic;
  dynamic isActive;

  factory PollTopicsData.fromJson(Map<String, dynamic> json) => PollTopicsData(
        topicId: json["topic_id"],
        topic: json["topic"],
        isActive: json["is_active"],
      );

  Map<String, dynamic> toJson() => {
        "topic_id": topicId,
        "topic": topic,
        "is_active": isActive,
      };
}
