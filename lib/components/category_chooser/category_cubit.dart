import 'package:bloc/bloc.dart';
import 'package:nexth/components/category_chooser/category_tree.dart';

class CategoryCubit extends Cubit<List<CategoryElement>> {
  final Function(List<CategoryElement>) callback;
  CategoryCubit({required this.callback}) : super([]);

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
