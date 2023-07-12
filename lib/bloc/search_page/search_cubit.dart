import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter/bloc/search_page/search_repository.dart';
import 'package:twitter/bloc/search_page/search_state.dart';
import 'package:twitter/models/user_model.dart';
import 'package:twitter/utils/resource.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchRepository _repo;
  SearchCubit({
    required SearchRepository repo,
  })  : _repo = repo,
        super(SearchInitial());

  TextEditingController searchController = TextEditingController();
  Resource<List<UserModel>> userResource = Resource(status: Status.LOADING, data: null, errorMessage: null);

  Future<void> searchUsers(String value) async {
    // emit(HomeLoading());
    userResource = await _repo.searchByUsername(searchController.text);
    if (userResource.data == null) {
      // no users found
    } else {
      if (userResource.status == Status.SUCCESS) {
        emit(SearchInitial());
      } else {
        debugPrint('error while searching users');
        emit(SearchError());
      }
    }
  }
}
