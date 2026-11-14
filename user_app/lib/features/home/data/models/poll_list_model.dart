class PollsListResponseModel {
  PollsListResponseModel({
    this.status,
    this.msg,
    this.pollsListData,
  });

  dynamic status;
  dynamic msg;
  List<PollsListData>? pollsListData;

  factory PollsListResponseModel.fromJson(Map<String, dynamic> json) =>
      PollsListResponseModel(
        status: json["status"],
        msg: json["message"],
        pollsListData: json["data"] != null
            ? List<PollsListData>.from(
                json["data"].map((x) => PollsListData.fromJson(x)))
            : [],
      );
}

class PollsListData {
  PollsListData({
    this.id,
    this.question,
    this.image,
    this.allowMultipleAnswer,
    this.isApproved,
    this.pollCreatedUser,
    this.topicId,
    this.topic,
    this.pollOptions,
  });

  dynamic id;
  dynamic question;
  dynamic image;
  dynamic allowMultipleAnswer;
  dynamic isApproved;
  PollCreatedUser? pollCreatedUser;
  dynamic topicId;
  dynamic topic;
  List<PollOptions>? pollOptions;

  factory PollsListData.fromJson(Map<String, dynamic> json) => PollsListData(
        id: json["id"],
        question: json["question"],
        image: json["image"],
        allowMultipleAnswer: json["allowMultipleAnswers"],
        isApproved: json["is_approved"],
        pollCreatedUser: PollCreatedUser.fromJson(json["user"] ?? {}),
        topicId: json["topic_id"],
        topic: json["topic"],
        pollOptions: json["options"] != null
            ? List<PollOptions>.from(
                json["options"].map((x) => PollOptions.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "question": question,
        "image": image,
        "allowMultipleAnswers": allowMultipleAnswer,
        "isApproved": isApproved,
        "user": pollCreatedUser!.toJson(),
        "topic_id": topicId,
        "topic": topic,
        "options": List<PollOptions>.from(pollOptions!.map((x) => x.toJson())),
      };
}

class PollCreatedUser {
  PollCreatedUser({
    this.userId,
    this.userName,
    this.userImage,
  });

  dynamic userId;
  dynamic userName;
  dynamic userImage;

  factory PollCreatedUser.fromJson(Map<String, dynamic> json) =>
      PollCreatedUser(
        userId: json["user_id"],
        userName: json["user_name"],
        userImage: json["profile_img"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "user_name": userName,
        "profile_img": userImage,
      };
}

class PollOptions {
  PollOptions({
    this.id,
    this.voteTotalCount,
    this.optionText,
    this.selectUser,
  });

  dynamic id;
  dynamic voteTotalCount;
  dynamic optionText;
  List<OptionsSelectedUser>? selectUser;

  factory PollOptions.fromJson(Map<String, dynamic> json) => PollOptions(
        id: json["id"],
        voteTotalCount: json["vote_count"],
        optionText: json["option_text"],
        selectUser: json["selected_users"] != null
            ? List<OptionsSelectedUser>.from(json["selected_users"]
                .map((x) => OptionsSelectedUser.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "vote_count": voteTotalCount,
        "option_text": optionText,
        "selected_users":
            List<OptionsSelectedUser>.from(selectUser!.map((x) => x.toJson())),
      };
}

class OptionsSelectedUser {
  OptionsSelectedUser({
    this.userId,
    this.userName,
    this.userImage,
  });

  dynamic userId;
  dynamic userName;
  dynamic userImage;

  factory OptionsSelectedUser.fromJson(Map<String, dynamic> json) =>
      OptionsSelectedUser(
        userId: json["user_id"],
        userName: json["user_name"],
        userImage: json["profile_img"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "user_name": userName,
        "profile_img": userImage,
      };
}
