part of 'item_list_model_cubit.dart';

@immutable
abstract class ItemListModelState {
  final ItemListModel itemListModel = ModelManager.instance.explorePopularModel;
}

class ItemListModelInitial extends ItemListModelState {
  @override
  final ItemListModel itemListModel = ModelManager.instance.explorePopularModel;
}

class ItemListModelReset extends ItemListModelState {
  @override
  final ItemListModel itemListModel;

  ItemListModelReset({required this.itemListModel});
}

class ItemListModelChanged extends ItemListModelState {
  @override
  final ItemListModel itemListModel;

  ItemListModelChanged({required this.itemListModel});
}