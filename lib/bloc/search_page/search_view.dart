import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:twitter/BottomNavbar.dart';
import 'package:twitter/Navbar.dart';
import 'package:twitter/bloc/search_page/search_cubit.dart';
import 'package:twitter/bloc/search_page/search_state.dart';

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
        title: FaIcon(FontAwesomeIcons.twitter, size: 35, color: CustomColors.blue),
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
            // if (state is SearchInitial) {
            //   WidgetsBinding.instance.addPostFrameCallback((_) {
            //     viewModel.getUserTweets();
            //   });
            // }
          },
          builder: (context, state) {
            debugPrint('Search view state: $state');
            if (state is SearchInitial) {
              return _buildInitial(context, state);
            } else if (state is SearchLoading) {
              return _buildLoading();
            } else if (state is SearchSuccess) {
              return _buildSuccess();
            } else if (state is SearchError) {
              return _buildError();
            }
            return Container();
          },
        ),
      ),
    ));
  }

  Widget _buildInitial(BuildContext context, SearchInitial state) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: const Text('Select user',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  )),
            ),
            const SizedBox(
              height: 30,
            ),
            TextField(
              controller: viewModel.searchController,
              //onChanged: (value) => viewModel.searchUsers(value),
              onChanged: (value) {
                viewModel.searchUsers(value);
              },
              decoration: customInputDecoration(),
              cursorColor: Color(0xfff48fb1),
              style: (TextStyle(color: Colors.white)),
            ),
            Container(
              color: Colors.transparent,
              child: (viewModel.userResource.data == null)
                  ? Text('no user registered')
                  : ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: viewModel.userResource.data!.length ?? 0,
                      itemBuilder: (context, index) {
                        final item = viewModel.userResource.data![index];

                        if (viewModel.userResource.data!.isNotEmpty) {
                          return ListTile(
                            leading: Icon(Icons.person, color: Colors.deepPurple),
                            title: Text(
                              item.email,
                              style: TextStyle(color: Colors.white),
                            ),
                            // onTap: () {
                            //   debugPrint(item.toString());
                            //   showModalBottomSheet(
                            //     context: context,
                            //     builder: (BuildContext context) {
                            //       return Column(
                            //         crossAxisAlignment: CrossAxisAlignment.center,
                            //         children: [
                            //           const Text('Enter the Task', style: TextStyle(fontSize: 30)),
                            //           const SizedBox(height: 16.0),
                            //           CustomForm(viewModel: viewModel, receiverId: item.userId),
                            //         ],
                            //       );
                            //     },
                            //   );
                            //   ;
                            // },
                          );
                        } else {
                          return Container(child: Text('No user found'));
                        }
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration customInputDecoration() {
    return const InputDecoration(
      prefixIcon: Icon(Icons.search, color: Color(0xfff48fb1)),
      suffixIcon: Icon(Icons.send, color: Color(0xfff48fb1)),
      hintText: 'Search by email',
      hintStyle: TextStyle(color: Colors.white),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xfff48fb1)),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xfff48fb1)),
      ),
    );
  }

  SafeArea _buildLoading() {
    return SafeArea(child: Text('Search load'));
  }

  SafeArea _buildSuccess() {
    return SafeArea(child: Text('Search success'));
  }

  SafeArea _buildError() {
    return SafeArea(child: Text('Search error'));
  }
}
