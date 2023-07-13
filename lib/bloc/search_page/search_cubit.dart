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
  Resource<List<UserModel>> allUserResource = Resource(status: Status.LOADING, data: null, errorMessage: null);

  Future<void> searchUsers(String value) async {
    emit(SearchLoading());
    userResource = await _repo.searchByUsername(searchController.text);
    if (userResource.status == Status.SUCCESS) {
      if (searchController.text == '') {
        emit(SearchInitial());
      } else {
        emit(SearchSuccess());
      }
    } else {
      debugPrint(userResource.errorMessage);
      debugPrint('search cubit -> searchUsers -> userResource status ERROR');
    }
  }

  Future<void> getAllUsername() async {
    allUserResource = await _repo.getAllUsername();

    if (allUserResource.status == Status.SUCCESS) {
      emit(SearchInitial());
    } else {
      debugPrint(allUserResource.errorMessage);
      debugPrint('search cubit -> getAllUsername -> allUserResource status ERROR');
    }
  }
}
