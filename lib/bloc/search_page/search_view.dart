import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter/BottomNavbar.dart';
import 'package:twitter/Navbar.dart';
import 'package:twitter/bloc/search_page/search_cubit.dart';
import 'package:twitter/bloc/search_page/search_state.dart';
import 'package:twitter/widget/user_containers_utils.dart';

import '../../utils/constants.dart';
import '../../utils/theme_utils.dart';
import '../../widget/profile_photo_widget.dart';

class SearchView extends StatelessWidget {
  final SearchCubit viewModel;
  const SearchView({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchCubit>(
      create: (_) => viewModel,
      child: _buildScaffold(context),
    );
  }

  SafeArea _buildScaffold(BuildContext context) {
    viewModel.getAllUsername();
    return SafeArea(
        child: Scaffold(
      // key: _scaffoldKey,
      appBar: AppBar(
        leadingWidth: 40,
        leading: Builder(
          builder: (ctx) {
            return GestureDetector(
              onTap: () {
                Scaffold.of(ctx).openDrawer(); // Open the drawer
              },
              child: CustomCircleAvatar(photoUrl: Constants.USER.profilePhoto, radius: 40),
            );
          },
        ),
        title: TextField(
          onTapOutside: (event) {
            FocusScope.of(context).unfocus();
          },
          controller: viewModel.searchController,
          onChanged: (value) {
            viewModel.searchUsers(value);
          },
          decoration: customInputDecoration(),
          cursorColor: Colors.white,
          style: (const TextStyle(color: Colors.white)),
        ),
      ),
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/tweet');
        },
        backgroundColor: CustomColors.blue,
        child: Container(
          width: 45, // Set the desired width
          height: 45, // Set the desired height
          child: Image.asset('assets/images/new_tweet.png'),
        ),
      ),
      drawer: const Navbar(),
      bottomNavigationBar: BottomNavbar(),
      body: SingleChildScrollView(
        child: BlocConsumer<SearchCubit, SearchState>(
          listener: (context, state) {
            if (state is SearchInitial) {
              // WidgetsBinding.instance.addPostFrameCallback((_) {
              //   viewModel.getAllUsername('');
              // });
            }
          },
          builder: (context, state) {
            debugPrint('Search view state: $state');
            if (state is SearchInitial) {
              // return _buildInitial(context);
            } else if (state is SearchLoading) {
              return _buildLoading();
            } else if (state is SearchSuccess) {
              return _buildSuccess(state);
            }

            return Container();
          },
        ),
      ),
    ));
  }

  // Widget _buildInitial(BuildContext context) {
  //   return SafeArea(
  //     child: Padding(
  //       padding: const EdgeInsets.all(8.0),
  //       child: Column(
  //         children: [
  //           const SizedBox(height: 30),
  //           UserListViewContainer(resource: viewModel.allUserResource),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  InputDecoration customInputDecoration() {
    return InputDecoration(
      contentPadding: EdgeInsets.zero,
      prefixIcon: Icon(Icons.search, color: CustomColors.lightGray),
      // suffixIcon: Icon(Icons.send, color: Color(0xfff48fb1)),
      hintText: "Twitter'da ara",
      hintStyle: TextStyle(color: CustomColors.lightGray),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: CustomColors.blue),
        borderRadius: BorderRadius.circular(22),
      ),
      enabledBorder: OutlineInputBorder(
        // borderSide: BorderSide(color: CustomColors.blue),
        borderRadius: BorderRadius.circular(22),
      ),
      filled: true, // Add filled property
      fillColor: CustomColors.black,
    );
  }

  Widget _buildLoading() {
    debugPrint('state is loading');
    return Center(
        child: LinearProgressIndicator(
      color: CustomColors.blue,
      backgroundColor: CustomColors.lightGray,
    ));
  }

  SafeArea _buildSuccess(SearchSuccess state) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: UserListViewContainer(resource: state.userResource),
      ),
    );
  }
}
