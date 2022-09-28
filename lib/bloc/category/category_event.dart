part of 'category_bloc.dart';


abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class LoadCategories extends CategoryEvent {}

class UpdateCategories extends CategoryEvent {
  final List<CategoryProduct> categoryList;

  const UpdateCategories({this.categoryList = const <CategoryProduct>[]});

  @override
  List<Object> get props => [categoryList];
}
