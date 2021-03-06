import 'package:brightside_feed/model/category_tree_model.dart';

const RootCategory kNonTechCategory = const RootCategory(
  displayTitle: "Non-Tech",
  categoryIdentifier: "nonTech",
  levelTwoCategories: [
    bioDiversityCategory,
    socialJusticeCategory,
    peaceBuildingCategory,
    recyclingNonTechCategory,
    otherNonTechCategory
  ],
);


const LevelTwoCategory bioDiversityCategory = const LevelTwoCategory(
  displayTitle: "Bio diversity",
  categoryIdentifier: "bioDiversity",
  levelThreeElements: [],
);

const LevelTwoCategory socialJusticeCategory = const LevelTwoCategory(
  displayTitle: "Social justice",
  categoryIdentifier: "socialJustice",
  levelThreeElements: [],
);

const LevelTwoCategory peaceBuildingCategory = const LevelTwoCategory(
  displayTitle: "Cooperation",
  categoryIdentifier: "peaceBuilding",
  levelThreeElements: [],
);

const LevelTwoCategory recyclingNonTechCategory = const LevelTwoCategory(
  displayTitle: "Recycling",
  categoryIdentifier: "recyclingNonTech",
  levelThreeElements: [],
);

const LevelTwoCategory otherNonTechCategory = const LevelTwoCategory(
  displayTitle: "Other",
  categoryIdentifier: "otherNonTech",
  levelThreeElements: [],
);
