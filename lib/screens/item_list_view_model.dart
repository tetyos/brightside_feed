import 'package:inspired/components/item_card_custom.dart';
import 'package:inspired/utils/preview_data_loader.dart';

class ItemListViewModel {
  final List<ItemData> initialDataRecent = [];
  final List<ItemData> initialDataIncubator = [];
  final List<ItemData> initialDataExplore = [];
  List<ItemCardCustom> recentItemList = [];
  List<ItemCardCustom> incubatorItemList = [];
  List<ItemCardCustom> exploreItemList = [];

  ItemListViewModel();
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

extension SelectedColorExtension on ItemCategory {
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
}