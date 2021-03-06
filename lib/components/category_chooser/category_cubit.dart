import 'package:bloc/bloc.dart';
import 'package:brightside_feed/model/category_tree_model.dart';

class CategoryCubit extends Cubit<List<CategoryElement>> {
  final Function(List<CategoryElement>) callback;

  CategoryCubit({
    required this.callback,
    List<CategoryElement> initElements = const [],
  }) : super([...initElements]);

  void addElement(CategoryElement categoryElement) {
    state.add(categoryElement);
    callback(state);
    emit(List.of(state));
  }

  void removeElement(CategoryElement categoryElement) {
    state.remove(categoryElement);
    callback(state);
    emit(List.of(state));
  }

  void removeElements(List<CategoryElement> categoryElements) {
    categoryElements.forEach((element) {
      state.remove(element);
    });
    callback(state);
    emit(List.of(state));
  }
}
