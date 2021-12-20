import 'package:nexth/components/category_chooser/category_tree.dart';

const RootCategory kTechCategory = const RootCategory(
  displayTitle: "Tech",
  categoryIdentifier: "tech",
  levelTwoCategories: [
    energyCategory,
    mobilityCategory,
    foodCategory,
    informationTechCategory,
    medTechCategory,
    materialsCategory,
    recyclingCategory,
    otherTechCategory
  ],
);

// ---------- Energy------------

const LevelTwoCategory energyCategory = const LevelTwoCategory(
  displayTitle: "Energy",
  categoryIdentifier: "energy",
  levelThreeElements: [solarCategory, windCategory, storageCategory, hydrogenTechCategory],
);
const LevelThreeCategory solarCategory =
    const LevelThreeCategory(displayTitle: "Solar", categoryIdentifier: "solar");
const LevelThreeCategory windCategory =
    const LevelThreeCategory(displayTitle: "Wind", categoryIdentifier: "wind");
const LevelThreeCategory hydrogenTechCategory =
    const LevelThreeCategory(displayTitle: "Hydrogen Tech", categoryIdentifier: "hydrogenTech");
const LevelThreeCategory storageCategory =
    const LevelThreeCategory(displayTitle: "Storage", categoryIdentifier: "storage");

// ---------- Mobility------------
const LevelTwoCategory mobilityCategory = const LevelTwoCategory(
  displayTitle: "Mobility",
  categoryIdentifier: "mobility",
  levelThreeElements: [eMobilityCategory, batteryTechCategory, hydrogenTech],
);
const LevelThreeCategory eMobilityCategory =
    const LevelThreeCategory(displayTitle: "E-Mobility", categoryIdentifier: "eMobility");
const LevelThreeCategory batteryTechCategory =
    const LevelThreeCategory(displayTitle: "Battery tech", categoryIdentifier: "batteryTech");
const LevelThreeCategory hydrogenTech = const LevelThreeCategory(
    displayTitle: "Hydrogen mobility", categoryIdentifier: "hydrogenMobilityTech");

// ---------- Food------------
const LevelTwoCategory foodCategory = const LevelTwoCategory(
  displayTitle: "Food",
  categoryIdentifier: "food",
  levelThreeElements: [verticalFarms],
);
const LevelThreeCategory verticalFarms =
    const LevelThreeCategory(displayTitle: "Vertical farms", categoryIdentifier: "verticalFarms");

// ---------- Others ------------

const LevelTwoCategory medTechCategory = const LevelTwoCategory(
  displayTitle: "Med Tech",
  categoryIdentifier: "medTech",
  levelThreeElements: [],
);

const LevelTwoCategory informationTechCategory = const LevelTwoCategory(
  displayTitle: "IT",
  categoryIdentifier: "informationTech",
  levelThreeElements: [],
);

const LevelTwoCategory materialsCategory = const LevelTwoCategory(
  displayTitle: "Materials",
  categoryIdentifier: "materials",
  levelThreeElements: [],
);

const LevelTwoCategory recyclingCategory = const LevelTwoCategory(
  displayTitle: "Recycling",
  categoryIdentifier: "recyclingTech",
  levelThreeElements: [],
);

const LevelTwoCategory otherTechCategory = const LevelTwoCategory(
  displayTitle: "Other",
  categoryIdentifier: "otherTech",
  levelThreeElements: [],
);
