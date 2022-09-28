part of 'category_bloc.dart';


abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object> get props => [];
}

class CategoriesLoading extends CategoryState {}

class CategoriesLoaded extends CategoryState {
  final List<CategoryProduct> categories;

  const CategoriesLoaded({this.categories = const <CategoryProduct>[]});

  @override
  List<Object> get props => [categories];
}
