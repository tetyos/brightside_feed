import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nexth/backend_connection/api_key_identifier.dart' as APIKeys;
import 'package:flutter/material.dart';

abstract class VoteModel {
  int numberOfRatings = 0;
  bool voted = false;
  String get itemId;
  IconData get iconData;
  String get identifier;
  String get displayText;
}

class UpVoteModel extends VoteModel {

  final String _itemId;

  @override
  int numberOfRatings;
  @override
  bool voted;

  @override
  String get itemId => _itemId;

  @override
  String get identifier => APIKeys.postUpVote;

  @override
  String get displayText => "Up Vote";

  @override
  IconData get iconData => Icons.thumb_up_alt_outlined;


  UpVoteModel({required itemId, required this.numberOfRatings, required this.voted}) : _itemId = itemId;

  UpVoteModel.empty()
      : _itemId = "",
        numberOfRatings = 0,
        voted = false;
}

class ImpactVoteModel extends VoteModel {

  final String _itemId;

  @override
  int numberOfRatings;
  @override
  bool voted;

  @override
  String get itemId => _itemId;

  @override
  String get identifier => APIKeys.postImpactVote;

  @override
  String get displayText => "High Impact";

  @override
  IconData get iconData => Icons.public;


  ImpactVoteModel({required itemId, required this.numberOfRatings, required this.voted}) : _itemId = itemId;

  ImpactVoteModel.empty()
      : _itemId = "",
        numberOfRatings = 0,
        voted = false;
}

class InspiringVoteModel extends VoteModel {

  final String _itemId;

  @override
  int numberOfRatings;
  @override
  bool voted;

  @override
  String get itemId => _itemId;

  @override
  String get identifier => APIKeys.postInspiringVote;

  @override
  String get displayText => "Inspiring";

  @override
  IconData get iconData => FontAwesomeIcons.grinStars;


  InspiringVoteModel({required itemId, required this.numberOfRatings, required this.voted}) : _itemId = itemId;

  InspiringVoteModel.empty()
      : _itemId = "",
        numberOfRatings = 0,
        voted = false;
}

class WellWrittenVoteModel extends VoteModel {

  final String _itemId;

  @override
  int numberOfRatings;
  @override
  bool voted;

  @override
  String get itemId => _itemId;

  @override
  String get identifier => APIKeys.postWellWrittenVote;

  @override
  String get displayText => "Well written";

  @override
  IconData get iconData => FontAwesomeIcons.featherAlt;


  WellWrittenVoteModel({required itemId, required this.numberOfRatings, required this.voted}) : _itemId = itemId;

  WellWrittenVoteModel.empty()
      : _itemId = "",
        numberOfRatings = 0,
        voted = false;
}