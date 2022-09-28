import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:chat2/data/models/models.dart';
import 'package:chat2/data/repository/repository.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final Repository _categoryRepository;
  StreamSubscription? _categorySubscription;

  CategoryBloc({required categoryRepository})
      : _categoryRepository = categoryRepository,
        super(CategoriesLoading()) {
    on<LoadCategories>(_onLoadCategories);
    on<UpdateCategories>(_onUpdateCategories);
  }

  void _onLoadCategories(
      LoadCategories event,
      Emitter<CategoryState> emit,
      ) {
    _categorySubscription?.cancel();
    _categorySubscription = _categoryRepository.getAllCategories().listen(
          (categories) => add(UpdateCategories()),
    );
  }

  void _onUpdateCategories(
      UpdateCategories event,
      Emitter<CategoryState> emit,
      ) {
    emit(CategoriesLoaded(categories: event.categoryList));
  }
}
