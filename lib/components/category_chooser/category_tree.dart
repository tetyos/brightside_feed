abstract class CategoryElement {
  String get displayTitle;
  String get categoryIdentifier;
}

class RootCategory implements CategoryElement{
  final List<LevelTwoCategory> _levelTwoCategories;
  final String _displayTitle;
  final String _categoryIdentifier;

  const RootCategory(
      {required String displayTitle, required String categoryIdentifier, required List<LevelTwoCategory> levelTwoCategories})
      : _displayTitle = displayTitle,
        _categoryIdentifier = categoryIdentifier,
        _levelTwoCategories = levelTwoCategories;

  @override
  String get categoryIdentifier => _categoryIdentifier;

  @override
  String get displayTitle => _displayTitle;

  @override
  String toString() => displayTitle;

  List<LevelTwoCategory> get levelTwoCategories => _levelTwoCategories;
}

class LevelTwoCategory implements CategoryElement {
  final List<LevelThreeCategory> _levelThreeElements;
  final String _displayTitle;
  final String _categoryIdentifier;

  const LevelTwoCategory(
      {required String displayTitle, required String categoryIdentifier, required List<LevelThreeCategory> levelThreeElements})
      : _displayTitle = displayTitle,
        _categoryIdentifier = categoryIdentifier,
        _levelThreeElements = levelThreeElements;

  @override
  String get categoryIdentifier => _categoryIdentifier;

  @override
  String get displayTitle => _displayTitle;

  @override
  String toString() => displayTitle;

  List<LevelThreeCategory> get levelThreeElements => _levelThreeElements;
}

class LevelThreeCategory implements CategoryElement {
  final String _displayTitle;
  final String _categoryIdentifier;

  const LevelThreeCategory(
      {required displayTitle, required categoryIdentifier})
      : _displayTitle = displayTitle,
        _categoryIdentifier = categoryIdentifier;

  @override
  String get categoryIdentifier => _categoryIdentifier;

  @override
  String get displayTitle => _displayTitle;

  @override
  String toString() => displayTitle;
}