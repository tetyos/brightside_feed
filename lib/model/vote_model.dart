import 'package:nexth/backend_connection/api_key_identifier.dart' as APIKeys;
import 'package:flutter/material.dart';

abstract class VoteModel {
  int numberOfRatings = 0;
  bool voted = false;
  String get itemId;
  IconData get iconData;
  String get voteCategory;
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
  String get voteCategory => APIKeys.postUpVote;

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
  String get voteCategory => APIKeys.postImpactVote;

  @override
  IconData get iconData => Icons.whatshot_outlined;


  ImpactVoteModel({required itemId, required this.numberOfRatings, required this.voted}) : _itemId = itemId;

  ImpactVoteModel.empty()
      : _itemId = "",
        numberOfRatings = 0,
        voted = false;
}