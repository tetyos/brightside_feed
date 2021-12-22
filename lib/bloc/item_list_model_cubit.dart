import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:nexth/model/category_tree_model.dart';
import 'package:nexth/model/list_models/category_list_model.dart';
import 'package:nexth/model/list_models/explore_popular_model.dart';
import 'package:nexth/model/list_models/incubator_list_model.dart';
import 'package:nexth/model/list_models/item_list_model.dart';
import 'package:nexth/model/model_manager.dart';
import 'package:nexth/model/vote_model.dart';

part 'item_list_model_state.dart';

class ItemListModelCubit extends Cubit<ItemListModelState> {
  ItemListModelCubit() : super(ItemListModelInitial());

  void changeFilter(Periodicity periodicity, VoteType votingType) {
    ExplorePopularModel explorePopularModel = ModelManager.instance.explorePopularModel;
    explorePopularModel.periodicity = periodicity;
    explorePopularModel.votingType = votingType;
    explorePopularModel.reset();
    emit(ItemListModelReset(itemListModel: explorePopularModel));
  }

  void changeCategory(CategoryElement categoryElement) {
    CategoryListModel categoryListModel = ModelManager.instance.categoryItemModel;
    categoryListModel.categories = [categoryElement];
    categoryListModel.reset();
    emit(ItemListModelReset(itemListModel: categoryListModel));
  }

  void resetIncubatorModel(IncubatorType incubatorType) {
    ItemListModel itemListModel = ModelManager.instance.getModelForIncubatorType(incubatorType);
    itemListModel.reset();
    emit(ItemListModelReset(itemListModel: itemListModel));
  }
}
