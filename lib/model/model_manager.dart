import 'package:nexth/backend_connection/api_key_identifier.dart' as API_Identifier;
import 'package:nexth/backend_connection/api_connector.dart';
import 'package:nexth/backend_connection/database_query.dart';
import 'package:nexth/model/category_list_model.dart';
import 'package:nexth/model/explore_likes_model.dart';
import 'package:nexth/model/explore_popular_model.dart';
import 'package:nexth/model/home_list_model.dart';
import 'package:nexth/model/incubator_list_model.dart';
import 'package:nexth/model/item_data.dart';
import 'package:nexth/model/item_list_model.dart';
import 'package:nexth/model/user_data.dart';
import 'package:nexth/model/vote_model.dart';

class ModelManager {
  static ModelManager _instance = ModelManager._();

  UserModel? userModel;
  bool isUserDataRetrieved = false;

  Map<String, ItemData> allItems = {};
  List<ItemListModel> allModels = [];

  final ItemListModel homeModel = HomeListModel();
  final ItemListModel exploreLikesModel = ExploreLikesModel();
  ExplorePopularModel explorePopularModel = ExplorePopularModel(votingType: VoteType.impact, periodicity: Periodicity.week);

  final ItemListModel inc1IncubatorModel = IncubatorListModel(incubatorType: IncubatorType.inc1);
  final ItemListModel unsafeIncubatorModel = IncubatorListModel(incubatorType: IncubatorType.unsafe, isPreloadImages: false);

  // category item lists
  ItemListModel _energyItemList = CategoryListModel(itemCategory: ItemCategory.energy);
  ItemListModel _informationItemList = CategoryListModel(itemCategory: ItemCategory.information);
  ItemListModel _healthItemList = CategoryListModel(itemCategory: ItemCategory.health);
  ItemListModel _mobilityItemList = CategoryListModel(itemCategory: ItemCategory.mobility);
  ItemListModel _foodItemList = CategoryListModel(itemCategory: ItemCategory.food);
  ItemListModel _otherItemList = CategoryListModel(itemCategory: ItemCategory.other);

  static ModelManager get instance => _instance;

  ModelManager._() {
    allModels.addAll([
      homeModel,
      inc1IncubatorModel,
      unsafeIncubatorModel,
      exploreLikesModel,
      explorePopularModel,
      _energyItemList,
      _informationItemList,
      _healthItemList,
      _mobilityItemList,
      _foodItemList,
      _otherItemList
    ]);
  }

  ItemListModel getModelForCategory(ItemCategory itemCategory) {
    switch (itemCategory) {
      case ItemCategory.energy:
        return _energyItemList;
      case ItemCategory.information:
        return _informationItemList;
      case ItemCategory.health:
        return _healthItemList;
      case ItemCategory.mobility:
        return _mobilityItemList;
      case ItemCategory.food:
        return _foodItemList;
      case ItemCategory.other:
        return _otherItemList;
    }
  }

  ItemListModel getModelForIncubatorType(IncubatorType incubatorType) {
    switch (incubatorType) {
      case IncubatorType.inc1:
        return inc1IncubatorModel;
      case IncubatorType.unsafe:
        return unsafeIncubatorModel;
    }
  }

  void addItemsFromJson(Map<String, dynamic> itemsMap) {
    for (MapEntry<String, dynamic> entry in itemsMap.entries) {
      allItems[entry.key] = ItemData.fromJson(entry.value);
    }
  }

  Future<List<ItemData>> getItems(DatabaseQuery moreItemsDBQuery, bool isUserLoggedIn) async {
    List<dynamic> resultsForQuery = await APIConnector.getItems(moreItemsDBQuery, isUserLoggedIn);
    List<ItemData> newItems = [];
    for (dynamic itemJson in resultsForQuery) {
      String itemId = itemJson[API_Identifier.itemId];
      ItemData? oldItem = allItems[itemId];
      ItemData newItem;
      if (oldItem != null) {
        newItem = oldItem.update(itemJson);
      } else {
        newItem = ItemData.fromJson(itemJson);
      }
      newItems.add(newItem);
    }
    return newItems;
  }

  Future<void> retrieveUserData() async {
    Set<String> allItemIds = {};
    for (ItemListModel model in allModels) {
      for (ItemData item in model.items) {
        allItemIds.add(item.id);
      }
    }
    Map<String, dynamic> userData = await APIConnector.getUserData(allItemIds);
    Map<String, dynamic> votes = userData["votes"];
    Map<String, dynamic> userDoc = userData["userDoc"];
    this.userModel!.update(userDoc);
    for (ItemListModel model in allModels) {
      for (ItemData item in model.items) {
        _updateVotesForItem(item, votes);
      }
    }
    isUserDataRetrieved = true;
  }

  void _updateVotesForItem(ItemData item, Map<String, dynamic> itemIdsToVoteData) {
    Map<String, dynamic>? voteData = itemIdsToVoteData[item.id];
    if (voteData != null) {
      List<dynamic>? votesOnItem = voteData[API_Identifier.votesArray];
      if (votesOnItem == null || votesOnItem.isEmpty) {
        return;
      }
      item.upVoteModel.voted = votesOnItem.contains(API_Identifier.upVote);
      item.impactVoteModel.voted = votesOnItem.contains(API_Identifier.impactVote);
      item.inspiringVoteModel.voted = votesOnItem.contains(API_Identifier.inspiringVote);
      item.wellWrittenVoteModel.voted = votesOnItem.contains(API_Identifier.wellWrittenVote);
    }
  }
}