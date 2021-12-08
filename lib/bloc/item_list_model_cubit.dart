import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:nexth/model/explore_popular_model.dart';
import 'package:nexth/model/incubator_list_model.dart';
import 'package:nexth/model/item_list_model.dart';
import 'package:nexth/model/model_manager.dart';
import 'package:nexth/model/vote_model.dart';

part 'item_list_model_state.dart';

class ItemListModelCubit extends Cubit<ItemListModelState> {
  ItemListModelCubit() : super(ItemListModelInitial());

  void changeFilter(Periodicity periodicity, VoteType votingType) {
    ExplorePopularModel itemListModel = ExplorePopularModel(periodicity: periodicity, votingType: votingType);
    ModelManager.instance.explorePopularModel = itemListModel;
    emit(ItemListModelReset(itemListModel: itemListModel));
  }

  void resetIncubatorModel(IncubatorType incubatorType) {
    ItemListModel itemListModel = ModelManager.instance.getModelForIncubatorType(incubatorType);
    itemListModel.reset();
    emit(ItemListModelReset(itemListModel: itemListModel));
  }
}
