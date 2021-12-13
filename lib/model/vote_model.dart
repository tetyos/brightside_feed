import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nexth/backend_connection/api_key_identifier.dart' as API_Identifier;
import 'package:flutter/material.dart';

abstract class VoteModel {
  final VoteType voteType = VoteType.upVote;
  String get itemId;
  int numberOfRatings = 0;
  bool voted = false;
  IconData get iconData => voteType.icon;
  String get voteIdentifier => voteType.voteIdentifier;
  String get displayText => voteType.displayTitle;
}

enum VoteType {upVote, impact, inspiring, wellWritten}

extension VoteTypeExtension on VoteType {
  String get displayTitle {
    switch (this) {
      case VoteType.upVote:
        return 'Up Vote';
      case VoteType.impact:
        return 'High impact';
      case VoteType.inspiring:
        return 'Inspiring';
      case VoteType.wellWritten:
        return 'Well written';
    }
  }

  IconData get icon {
    switch (this) {
      case VoteType.upVote:
        return Icons.thumb_up_alt_outlined;
      case VoteType.impact:
        return Icons.public;
      case VoteType.inspiring:
        return FontAwesomeIcons.grinStars;
      case VoteType.wellWritten:
        return FontAwesomeIcons.featherAlt;
    }
  }

  String get voteIdentifier {
    switch (this) {
      case VoteType.upVote:
        return API_Identifier.upVote;
      case VoteType.impact:
        return API_Identifier.impactVote;
      case VoteType.inspiring:
        return API_Identifier.inspiringVote;
      case VoteType.wellWritten:
        return API_Identifier.wellWrittenVote;
    }
  }

  String get totalVotesIdentifier {
    switch (this) {
      case VoteType.upVote:
        return API_Identifier.totalUpVotes;
      case VoteType.impact:
        return API_Identifier.totalImpactVotes;
      case VoteType.inspiring:
        return API_Identifier.totalInspiringVotes;
      case VoteType.wellWritten:
        return API_Identifier.totalWellWrittenVotes;
    }
  }
}

class UpVoteModel extends VoteModel {

  @override
  final VoteType voteType = VoteType.upVote;

  final String _itemId;

  @override
  int numberOfRatings;
  @override
  bool voted;

  @override
  String get itemId => _itemId;

  UpVoteModel({required itemId, required this.numberOfRatings, required this.voted}) : _itemId = itemId;

  UpVoteModel.empty()
      : _itemId = "",
        numberOfRatings = 0,
        voted = false;
}

class ImpactVoteModel extends VoteModel {

  @override
  final VoteType voteType = VoteType.impact;

  final String _itemId;

  @override
  int numberOfRatings;
  @override
  bool voted;

  @override
  String get itemId => _itemId;

  ImpactVoteModel({required itemId, required this.numberOfRatings, required this.voted}) : _itemId = itemId;

  ImpactVoteModel.empty()
      : _itemId = "",
        numberOfRatings = 0,
        voted = false;
}

class InspiringVoteModel extends VoteModel {

  @override
  final VoteType voteType = VoteType.inspiring;

  final String _itemId;

  @override
  int numberOfRatings;
  @override
  bool voted;

  @override
  String get itemId => _itemId;


  InspiringVoteModel({required itemId, required this.numberOfRatings, required this.voted}) : _itemId = itemId;

  InspiringVoteModel.empty()
      : _itemId = "",
        numberOfRatings = 0,
        voted = false;
}

class WellWrittenVoteModel extends VoteModel {

  @override
  final VoteType voteType = VoteType.wellWritten;

  final String _itemId;

  @override
  int numberOfRatings;
  @override
  bool voted;

  @override
  String get itemId => _itemId;

  WellWrittenVoteModel({required itemId, required this.numberOfRatings, required this.voted}) : _itemId = itemId;

  WellWrittenVoteModel.empty()
      : _itemId = "",
        numberOfRatings = 0,
        voted = false;
}