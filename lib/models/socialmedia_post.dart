// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

String _baseUrl = 'https://graduation.amiralsayed.me';

class SocialmediaPost {
  List<Data> data;
  String message;
  SocialmediaPost({required this.data, required this.message});
  factory SocialmediaPost.fromJason(Map<String, dynamic> jasonData) {
    return SocialmediaPost(
      data: List<Data>.from(jasonData['data'].map((x) => Data.fromJason(x))),
      message: jasonData['message'],
    );
  }
}

class Data {
  final String? caption;
  final List<Media>? media;
  final ImpressionsCount? impressionsCount;
  final int? shareCount;
  final int? saveCount;
  final String? date;
  final String? userId;

  Data({
    this.caption,
    this.media,
    this.impressionsCount,
    this.saveCount,
    this.shareCount,
    this.date,
    this.userId,
  });
  factory Data.fromJason(Map<String, dynamic> jasonData) {
    return Data(
      caption: jasonData['postCaption'],
      media:
          jasonData['media'] != null
              ? List<Media>.from(
                jasonData['media'].map((x) => Media.fromJson(x)),
              )
              : null,
      impressionsCount:
          jasonData['impressionsCount'] != null
              ? ImpressionsCount.fromJson(jasonData['impressionsCount'])
              : null,
      shareCount: jasonData['shareCount'],
      saveCount: jasonData['saveCount'],
      date: DateFormat.MMMMd(
        'en_US',
      ).format(DateTime.parse(jasonData['createdAt'])),

      userId: jasonData['author'],
    );
  }
}

class Media {
  final String? type;
  final String? url;
  final String? sId;

  Media({this.type, this.url, this.sId});

  factory Media.fromJson(Map<String, dynamic> jsonData) {
    return Media(
      type: jsonData['type'],
      url: _baseUrl + jsonData['url'],
      sId: jsonData['_id'],
    );
  }
}

class ImpressionsCount {
  int? like;
  int? love;
  int? care;
  int? laugh;
  int? sad;
  int? hate;
  int? total;

  ImpressionsCount({
    this.like,
    this.love,
    this.care,
    this.laugh,
    this.sad,
    this.hate,
    this.total,
  });
  factory ImpressionsCount.fromJson(Map<String, dynamic> jsonData) {
    return ImpressionsCount(
      like: jsonData['like'],
      love: jsonData['love'],
      care: jsonData['care'],
      laugh: jsonData['laugh'],
      sad: jsonData['sad'],
      hate: jsonData['hate'],
      total: jsonData['total'],
    );
  }
}
