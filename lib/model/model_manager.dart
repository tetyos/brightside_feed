import 'package:flutter/material.dart';
import 'package:nexth/components/item_card_custom.dart';
import 'package:nexth/model/item_data.dart';

class ModelManager {
  final List<ItemData> initialDataRecent = [];
  List<ItemCardCustom> recentItemList = [];
  final List<ItemData> incubatorManualItemList = [];
  final List<ItemData> incubatorScrapedItemList = [];

  // category item lists
  List<ItemData> _energyItemList = [];
  List<ItemData> _informationItemList = [];
  List<ItemData> _healthItemList = [];
  List<ItemData> _mobilityItemList = [];
  List<ItemData> _foodItemList = [];
  List<ItemData> _otherItemList = [];

  ModelManager();

  void setCategoryItems(ItemCategory itemCategory, List<ItemData> items) {
    switch (itemCategory) {
      case ItemCategory.energy:
        _energyItemList = items;
        break;
      case ItemCategory.information:
        _informationItemList = items;
        break;
      case ItemCategory.health:
        _healthItemList = items;
        break;
      case ItemCategory.mobility:
        _mobilityItemList = items;
        break;
      case ItemCategory.food:
        _foodItemList = items;
        break;
      case ItemCategory.other:
        _otherItemList = items;
        break;
    }
  }

  List<ItemData> getCategoryItems(ItemCategory itemCategory) {
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