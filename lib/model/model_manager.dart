import 'package:flutter/material.dart';
import 'package:nexth/model/category_list_model.dart';
import 'package:nexth/model/home_list_model.dart';
import 'package:nexth/model/item_data.dart';
import 'package:nexth/model/item_list_model.dart';

class ModelManager {
  List<ItemListModel> allModels = [];

  final ItemListModel homeModel = HomeListModel();

  // category item lists
  ItemListModel _energyItemList = CategoryListModel(itemCategory: ItemCategory.energy);
  ItemListModel _informationItemList = CategoryListModel(itemCategory: ItemCategory.information);
  ItemListModel _healthItemList = CategoryListModel(itemCategory: ItemCategory.health);
  ItemListModel _mobilityItemList = CategoryListModel(itemCategory: ItemCategory.mobility);
  ItemListModel _foodItemList = CategoryListModel(itemCategory: ItemCategory.food);
  ItemListModel _otherItemList = CategoryListModel(itemCategory: ItemCategory.other);

  final List<ItemData> homeItemList = [];

  ModelManager() {
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