import 'package:twitter/models/user_model.dart';
import 'package:twitter/utils/resource.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  final Resource<List<UserModel>> userResource;

  SearchSuccess({required this.userResource});
}

class SearchError extends SearchState {}
