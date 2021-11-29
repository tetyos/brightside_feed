import 'package:flutter/material.dart';
import 'package:nexth/backend_connection/api_key_identifier.dart' as APIKeys;
import 'package:nexth/backend_connection/api_connector.dart';
import 'package:nexth/backend_connection/database_query.dart';
import 'package:nexth/model/category_list_model.dart';
import 'package:nexth/model/home_list_model.dart';
import 'package:nexth/model/item_data.dart';
import 'package:nexth/model/item_list_model.dart';

class ModelManager {
  static ModelManager _instance = ModelManager._();
  Map<String, ItemData> allItems = {};
  List<ItemListModel> allModels = [];
  bool isUserVotesRetrieved = false;

  final ItemListModel homeModel = HomeListModel();

  // category item lists
  ItemListModel _energyItemList = CategoryListModel(itemCategory: ItemCategory.energy);
  ItemListModel _informationItemList = CategoryListModel(itemCategory: ItemCategory.information);
  ItemListModel _healthItemList = CategoryListModel(itemCategory: ItemCategory.health);
  ItemListModel _mobilityItemList = CategoryListModel(itemCategory: ItemCategory.mobility);
  ItemListModel _foodItemList = CategoryListModel(itemCategory: ItemCategory.food);
  ItemListModel _otherItemList = CategoryListModel(itemCategory: ItemCategory.other);

  static ModelManager get instance => _instance;

  ModelManager._() {
    allModels.addAll([homeModel, _energyItemList, _informationItemList, _healthItemList, _mobilityItemList, _foodItemList, _otherItemList]);
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

  Future<List<ItemData>> getItems(DatabaseQuery moreItemsDBQuery) async {
    List<dynamic> resultsForQuery = await APIConnector.getItems(moreItemsDBQuery);
    List<ItemData> newItems = [];
    for (dynamic itemJson in resultsForQuery) {
      ItemData newItem = ItemData.fromJson(itemJson);
      allItems[newItem.id] = newItem;
      newItems.add(ItemData.fromJson(itemJson));
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
      List<dynamic>? votesOnItem = voteData['votes'];
      if (votesOnItem == null || votesOnItem.isEmpty) return;
      item.upVoteModel.voted = votesOnItem.contains(APIKeys.postUpVote);
      item.impactVoteModel.voted = votesOnItem.contains(APIKeys.postImpactVote);
    }
  }
}

enum ItemCategory {energy, information, health, mobility, food, other}

ItemCategory? getItemCategoryFromString(String? itemCategory) {
  if (itemCategory == null) return null;
  if (itemCategory == ItemCategory.energy.toString()) return ItemCategory.energy;
  if (itemCategory == ItemCategory.information.toString()) return ItemCategory.information;
  if (itemCategory == ItemCategory.health.toString()) return ItemCategory.health;
  if (itemCategory == ItemCategory.mobility.toString()) return ItemCategory.mobility;
  if (itemCategory == ItemCategory.food.toString()) return ItemCategory.food;
  if (itemCategory == ItemCategory.other.toString()) return ItemCategory.other;
}

extension ItemCategoryExtension on ItemCategory {
  String get displayTitle {
    switch (this) {
      case ItemCategory.energy:
        return 'Energy';
      case ItemCategory.information:
        return 'Information';
      case ItemCategory.health:
        return 'Health';
      case ItemCategory.mobility:
        return 'Mobility';
      case ItemCategory.food:
        return 'Food';
      case ItemCategory.other:
        return 'Other';
    }
  }

  IconData get icon {
    switch (this) {
      case ItemCategory.energy:
        return Icons.bolt;
      case ItemCategory.information:
        return Icons.lightbulb_outline;
      case ItemCategory.health:
        return Icons.health_and_safety_outlined;
      case ItemCategory.mobility:
        return Icons.directions_car_outlined;
      case ItemCategory.food:
        return Icons.agriculture_outlined;
      case ItemCategory.other:
        return Icons.pending_outlined;
    }
  }
}