import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';
import 'package:nexth/backend_connection/api_key_identifier.dart' as API_Identifier;
import 'package:nexth/backend_connection/api_connector.dart';
import 'package:nexth/backend_connection/database_query.dart';
import 'package:nexth/model/category_tree_model.dart';
import 'package:nexth/model/category_tree_non_tech.dart';
import 'package:nexth/model/category_tree_tech.dart';
import 'package:nexth/model/list_models/category_list_model.dart';
import 'package:nexth/model/list_models/explore_likes_model.dart';
import 'package:nexth/model/list_models/explore_popular_model.dart';
import 'package:nexth/model/list_models/home_list_model.dart';
import 'package:nexth/model/list_models/incubator_list_model.dart';
import 'package:nexth/model/item_data.dart';
import 'package:nexth/model/list_models/item_list_model.dart';
import 'package:nexth/model/user_data.dart';
import 'package:nexth/model/vote_model.dart';
import 'package:nexth/navigation/app_state.dart';
import 'package:nexth/navigation/nexth_route_paths.dart';
import 'package:nexth/utils/ui_utils.dart';
import 'package:provider/provider.dart';

class ModelManager {
  static ModelManager _instance = ModelManager._();

  UserModel? userModel;
  bool isUserDataRetrieved = false;

  final Map<String, ItemData> allItems = {};
  final Map<String, CategoryElement> _allCategories = {};
  final List<ItemListModel> allModels = [];

  final ItemListModel homeModel = HomeListModel();
  final ItemListModel exploreLikesModel = ExploreLikesModel();
  ExplorePopularModel explorePopularModel = ExplorePopularModel(votingType: VoteType.impact, periodicity: Periodicity.week);

  final ItemListModel inc1IncubatorModel = IncubatorListModel(incubatorType: IncubatorType.inc1);
  final ItemListModel unsafeIncubatorModel = IncubatorListModel(incubatorType: IncubatorType.unsafe, isPreloadImages: false);

  // category item list
  final ItemListModel categoryItemModel = CategoryListModel();


  static ModelManager get instance => _instance;

  ModelManager._() {
    _initCategoryMap();
    allModels.addAll([
      homeModel,
      inc1IncubatorModel,
      unsafeIncubatorModel,
      exploreLikesModel,
      explorePopularModel,
      categoryItemModel,
    ]);
  }

  bool isAdmin() {
    return userModel != null && userModel!.rank == "admin";
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
    Set<String> allItemIds = allItems.keys.toSet();
    Map<String, dynamic> userData = await APIConnector.getUserData(allItemIds);
    Map<String, dynamic> votes = userData["votes"];
    Map<String, dynamic> userDoc = userData["userDoc"];
    this.userModel!.update(userDoc);
    for (ItemData item in allItems.values) {
      _updateVotesForItem(item, votes);
    }
    isUserDataRetrieved = true;
  }

  Future<void> logout(BuildContext context) async {
    AppState appState = Provider.of<AppState>(context, listen: false);
    if (!appState.isUserLoggedIn) {
      UIUtils.showSnackBar("Already logged out.", context);
      return;
    }
    try {
      await Amplify.Auth.signOut();
      ModelManager.instance.userModel = null;
      ModelManager.instance.isUserDataRetrieved = false;
      appState.currentRoutePath = LoginScreenPath();
    } on AuthException catch (e) {
      UIUtils.showSnackBar(e.message, context);
    }
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

  void deleteItem(ItemData itemData) {
    allItems.remove(itemData);
    for (ItemListModel model in allModels) {
      model.items.remove(itemData);
      model.fullyLoadedItems.remove(itemData);
    }
  }

  List<CategoryElement> getItemCategoriesFromJson(List<dynamic>? categoriesAsJson) {
    if (categoriesAsJson == null) return [];
    List<CategoryElement> categories = [];
    for (String categoryIdentifier in categoriesAsJson) {
      CategoryElement? categoryElement = _allCategories[categoryIdentifier];
      if (categoryElement != null) {
        categories.add(categoryElement);
      }
    }
    return categories;
  }

  void _initCategoryMap() {
    _allCategories[kTechCategory.categoryIdentifier] = kTechCategory;
    _allCategories[kNonTechCategory.categoryIdentifier] = kNonTechCategory;
    _addSubCategories(kTechCategory.levelTwoCategories);
    _addSubCategories(kNonTechCategory.levelTwoCategories);
  }

  void _addSubCategories(List<LevelTwoCategory> levelTwoCategories) {
    for (LevelTwoCategory levelTwoCategory in levelTwoCategories) {
      if (_allCategories.containsKey(levelTwoCategory.categoryIdentifier)) {
        print("SNH: Duplicate identifier detected for category");
        return;
      }
      _allCategories[levelTwoCategory.categoryIdentifier] = levelTwoCategory;

      for (LevelThreeCategory levelThreeCategory in levelTwoCategory.levelThreeElements) {
        if (_allCategories.containsKey(levelThreeCategory.categoryIdentifier)) {
          print("SNH: Duplicate identifier detected for category");
          return;
        }
        _allCategories[levelThreeCategory.categoryIdentifier] = levelThreeCategory;
      }
    }
  }

}