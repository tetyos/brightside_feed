import 'package:nexth/backend_connection/api_key_identifier.dart' as APIKeys;
import 'package:nexth/backend_connection/api_connector.dart';
import 'package:nexth/backend_connection/database_query.dart';
import 'package:nexth/model/category_list_model.dart';
import 'package:nexth/model/home_list_model.dart';
import 'package:nexth/model/incubator_list_model.dart';
import 'package:nexth/model/item_data.dart';
import 'package:nexth/model/item_list_model.dart';

class ModelManager {
  static ModelManager _instance = ModelManager._();
  Map<String, ItemData> allItems = {};
  List<ItemListModel> allModels = [];
  bool isUserVotesRetrieved = false;

  final ItemListModel homeModel = HomeListModel();
  final ItemListModel inc1IncubatorModel = IncubatorListModel(incubatorType: IncubatorType.inc1);
  final ItemListModel unsafeIncubatorModel = IncubatorListModel(incubatorType: IncubatorType.unsafe);

  // category item lists
  ItemListModel _energyItemList = CategoryListModel(itemCategory: ItemCategory.energy);
  ItemListModel _informationItemList = CategoryListModel(itemCategory: ItemCategory.information);
  ItemListModel _healthItemList = CategoryListModel(itemCategory: ItemCategory.health);
  ItemListModel _mobilityItemList = CategoryListModel(itemCategory: ItemCategory.mobility);
  ItemListModel _foodItemList = CategoryListModel(itemCategory: ItemCategory.food);
  ItemListModel _otherItemList = CategoryListModel(itemCategory: ItemCategory.other);

  static ModelManager get instance => _instance;

  ModelManager._() {
    allModels.addAll([homeModel, inc1IncubatorModel, unsafeIncubatorModel, _energyItemList, _informationItemList, _healthItemList, _mobilityItemList, _foodItemList, _otherItemList]);
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

  void addItemsFromJson(Map<String, dynamic> itemsMap) {
    for (MapEntry<String, dynamic> entry in itemsMap.entries) {
      allItems[entry.key] = ItemData.fromJson(entry.value);
    }
  }

  Future<List<ItemData>> getItems(DatabaseQuery moreItemsDBQuery, bool isUserLoggedIn) async {
    List<dynamic> resultsForQuery = await APIConnector.getItems(moreItemsDBQuery, isUserLoggedIn);
    List<ItemData> newItems = [];
    for (dynamic itemJson in resultsForQuery) {
      String itemId = itemJson[APIKeys.itemId];
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

  Future<void> retrieveUserVotes() async {
    Set<String> allItemIds = {};
    for (ItemListModel model in allModels) {
      for (ItemData item in model.items) {
        allItemIds.add(item.id);
      }
    }
    Map<String, dynamic> itemIdsToVoteData = await APIConnector.getUserVotes(allItemIds);
    for (ItemListModel model in allModels) {
      for (ItemData item in model.items) {
        _updateVotesForItem(item, itemIdsToVoteData);
      }
    }
    isUserVotesRetrieved = true;
  }

  void _updateVotesForItem(ItemData item, Map<String, dynamic> itemIdsToVoteData) {
    Map<String, dynamic>? voteData = itemIdsToVoteData[item.id];
    if (voteData != null) {
      List<dynamic>? votesOnItem = voteData[APIKeys.votesArray];
      if (votesOnItem == null || votesOnItem.isEmpty) return;
      item.upVoteModel.voted = votesOnItem.contains(APIKeys.postUpVote);
      item.impactVoteModel.voted = votesOnItem.contains(APIKeys.postImpactVote);
    }
  }
}