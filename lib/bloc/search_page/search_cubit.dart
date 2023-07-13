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
  // Resource<List<UserModel>> userResource = Resource(status: Status.LOADING, data: null, errorMessage: null);
  // Resource<List<UserModel>> allUserResource = Resource(status: Status.LOADING, data: null, errorMessage: null);

  late Resource<List<UserModel>> userResource;

  Future<void> searchUsers(String value) async {
    emit(SearchLoading());

    if (searchController.text == '') {
      userResource = await _repo.getAllUsername();
      emit(SearchSuccess(userResource: userResource));
    } else {
      userResource = await _repo.searchByUsername(searchController.text);
      emit(SearchSuccess(userResource: userResource));

      // debugPrint(userResource.errorMessage);
      // debugPrint('search cubit -> searchUsers -> userResource status ERROR');
    }
  }

  Future<void> getAllUsername() async {
    userResource = await _repo.getAllUsername();

    if (userResource.status == Status.SUCCESS) {
      emit(SearchSuccess(userResource: userResource));
    } else {
      debugPrint(userResource.errorMessage);
      debugPrint('search cubit -> getAllUsername -> userResource status ERROR');
    }
  }
}
