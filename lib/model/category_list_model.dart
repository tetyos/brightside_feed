import 'package:flutter/material.dart';
import 'package:nexth/backend_connection/api_key_identifier.dart' as API_Identifier;
import 'package:nexth/backend_connection/database_query.dart';
import 'package:nexth/model/item_list_model.dart';

class CategoryListModel extends ItemListModel {
  @override
  int itemsToFetchDuringAppStart = 5;
  @override
  int imagesToPreloadDuringAppStart = 3;

  final ItemCategory itemCategory;

  CategoryListModel({required this.itemCategory});

  @override
  DatabaseQuery? getDBQueryForInitialization() {
    if (itemsToFetchDuringAppStart <= 0) return null;
    return new DatabaseQuery(
        sortBy: API_Identifier.searchQuery_SortBy_DateAdded,
        limit: itemsToFetchDuringAppStart,
        categories: [itemCategory.toString()]);
  }

  @override
  DatabaseQuery getDBQuery() {
    return new DatabaseQuery(
        sortBy: API_Identifier.searchQuery_SortBy_DateAdded,
        limit: numberOfItemsToRequest,
        categories: [itemCategory.toString()]);
  }

  @override
  DatabaseQuery getMoreItemsDBQuery(String dateLT) {
    return new DatabaseQuery(
        sortBy: API_Identifier.searchQuery_SortBy_DateAdded,
        limit: numberOfItemsToRequest,
        categories: [itemCategory.toString()],
        dateLT: dateLT);
  }
}

enum ItemCategory { energy, information, health, mobility, food, other }

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

  String get imagePath {
    switch (this) {
      case ItemCategory.energy:
        return 'images/default_card_images/energy.jpg';
      case ItemCategory.information:
        return 'images/default_card_images/information.jpg';
      case ItemCategory.health:
        return 'images/default_card_images/med_tech.jpg';
      case ItemCategory.mobility:
        return 'images/default_card_images/mobility.jpg';
      case ItemCategory.food:
        return 'images/default_card_images/food.jpg';
      case ItemCategory.other:
        return 'images/default_card_images/other.jpg';
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
