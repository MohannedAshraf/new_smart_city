// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'mycolors.dart';

abstract class Urls {
  static const String SocialBaseUrl = 'https://graduation.amiralsayed.me/api/';
  static const String notificationBaseUrl =
      'https://api.citio.tech/gateway/notification-service';

  static const String socialmediaBaseUrl =
      'https://api.citio.tech/gateway/Social-media';

  static const String serviceProviderbaseUrl =
      'https://api.citio.tech/gateway/service-provider';

  static const String governmentbaseUrl =
      'https://api.citio.tech/gateway/government';

  static const String issueBaseUrl =
      'https://api.citio.tech/gateway/issuing-report';

  static const String cmsBaseUrl = 'https://api.citio.tech/gateway/cms';
}

abstract class Styles {
  static const Map<String, Map<String, dynamic>> govTabStyles = {
    'الأحوال المدنية': {
      'color': Color(0x1A607D8B),
      'icon': Icons.badge,
      'fontColor': Colors.blueGrey,
    },
    'الإسكان': {
      'color': Color(0x1AFF9800),
      'icon': Icons.directions_bus,
      'fontColor': Colors.orange,
    },
    'التموين /التجارة': {
      'color': Color(0x1AFF5252),
      'icon': Icons.local_hospital,
      'fontColor': Colors.redAccent,
    },
    'الجوازات والهجرة': {
      'color': Color(0x1A4CAF50),
      'icon': Icons.attach_money,
      'fontColor': Colors.green,
    },
    'التجارة': {
      'color': Color(0x1A673AB7),
      'icon': Icons.shopping_cart,
      'fontColor': Colors.deepPurple,
    },
  };

  static const Map<String, Map<String, dynamic>> requestsStyle = {
    'Completed': {
      'color': MyColors.fadedAccepted,
      'icon': Icons.check,
      'fontColor': MyColors.accepted,
    },
    'Pending': {
      'color': MyColors.fadedInProgress,
      'icon': Icons.hourglass_empty,
      'fontColor': MyColors.inProgress,
    },
    'Rejected': {
      'color': MyColors.fadedRejected,
      'icon': Icons.cancel,
      'fontColor': MyColors.rejected,
    },
    'ُEdited': {
      'color': MyColors.firefighterShade,
      'icon': Icons.edit_note,
      'fontColor': MyColors.firefighter,
    },
  };
}
