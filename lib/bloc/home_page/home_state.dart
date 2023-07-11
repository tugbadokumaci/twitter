abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {}

class HomeError extends HomeState {}

class HomeTabChanged extends HomeState {
  final int index;

  HomeTabChanged({required this.index});
}
