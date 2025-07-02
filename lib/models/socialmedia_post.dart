// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:citio/core/utils/variables.dart';

class SocialmediaPost {
  List<Data> data;
  String message;

  SocialmediaPost({required this.data, required this.message});

  factory SocialmediaPost.fromJason(Map<String, dynamic> jasonData) {
    return SocialmediaPost(
      data: (jasonData['data'] as List?)
              ?.map((x) => Data.fromJason(x))
              .toList() ??
          [],
      message: jasonData['message'] ?? '',
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
  final bool adminPost;
  final List<String>? tags;

  Data({
    this.caption,
    this.media,
    this.impressionsCount,
    this.saveCount,
    this.shareCount,
    this.date,
    this.userId,
    required this.adminPost,
    this.tags,
  });

  factory Data.fromJason(Map<String, dynamic> jasonData) {
    return Data(
      caption: jasonData['postCaption'] ?? '',
      media: (jasonData['media'] as List?)
              ?.map((x) => Media.fromJson(x))
              .toList() ??
          [],
      impressionsCount: jasonData['impressionsCount'] != null
          ? ImpressionsCount.fromJson(jasonData['impressionsCount'])
          : null,
      shareCount: jasonData['shareCount'],
      saveCount: jasonData['saveCount'],
      date: (jasonData['createdAt'] != null &&
              jasonData['createdAt'].toString().isNotEmpty)
          ? getTimeAgo(jasonData['createdAt'])
          : 'التاريخ غير متوفر',
      userId: jasonData['author'],
      adminPost: jasonData['adminPost'] ?? false,
      tags: (jasonData['tags'] as List?)?.map((e) => e.toString()).toList(),
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
      url: jsonData['url'] != null
          ? Urls.socialmediaBaseUrl + jsonData['url']
          : null,
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

String getTimeAgo(String dateString) {
  try {
    final date = DateTime.parse(dateString);
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inSeconds < 60) {
      return 'منذ ${diff.inSeconds} ثانية';
    } else if (diff.inMinutes < 60) {
      return 'منذ ${diff.inMinutes} دقيقة';
    } else if (diff.inHours < 24) {
      return 'منذ ${diff.inHours} ساعة';
    } else if (diff.inDays < 7) {
      return 'منذ ${diff.inDays} يوم';
    } else {
      return DateFormat.yMMMMd('ar_EG').format(date);
    }
  } catch (_) {
    return 'تاريخ غير صالح';
  }
}
