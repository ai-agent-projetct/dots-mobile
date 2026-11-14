class CreatetrendsResponsemodel {
  final bool status;
  final String message;
  final TrendPostData data;

  CreatetrendsResponsemodel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CreatetrendsResponsemodel.fromJson(Map<String, dynamic> json) {
    return CreatetrendsResponsemodel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: TrendPostData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'message': message, 'data': data.toJson()};
  }
}

class TrendPostData {
  final String mediaId;

  TrendPostData({required this.mediaId});

  factory TrendPostData.fromJson(Map<String, dynamic> json) {
    return TrendPostData(mediaId: json['media_id'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'media_id': mediaId};
  }
}
