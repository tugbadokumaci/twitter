import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:twitter/BottomNavbar.dart';
import 'package:twitter/bloc/home_page/home_cubit.dart';
import 'package:twitter/bloc/home_page/home_state.dart';
import 'package:twitter/utils/constants.dart';
import 'package:twitter/widget/tweet_containers_utils.dart';

import '../../Navbar.dart';
import '../../utils/theme_utils.dart';
import '../../widget/profile_photo_widget.dart';

class HomeView extends StatelessWidget {
  final HomeCubit viewModel;
  const HomeView({Key? key, required this.viewModel}) : super(key: key);

  // final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // viewModel.getTweetsByUserId(Constants.USER.userId);
    return BlocProvider<HomeCubit>(
      create: (_) => viewModel,
      child: _buildScaffold(context),
    );
  }

  SafeArea _buildScaffold(BuildContext context) {
    viewModel.getHomePageByUserId();

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
              child: CustomCircleAvatar(photoUrl: Constants.USER.profilePhoto),
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
      body: Container(
        child: SingleChildScrollView(
          child: BlocConsumer<HomeCubit, HomeState>(
            listener: (context, state) {
              // if (state is HomeInitial) {
              //   WidgetsBinding.instance.addPostFrameCallback((_) {
              //     viewModel.getTweetsByUserId(Constants.USER.userId);
              //   });
              // }
            },
            builder: (context, state) {
              debugPrint('Home view state: $state');
              if (state is HomeInitial) {
                // return _buildInitial();
              } else if (state is HomeLoading) {
                return _buildLoading();
              } else if (state is HomeSuccess) {
                return _buildSuccess(state);
              } else if (state is HomeError) {
                return _buildError();
              }
              return Container();
            },
          ),
        ),
      ),
    ));
  }

  Widget _buildInitial() {
    return const Center(
      child: Text('Home initial'),
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

  Widget _buildSuccess(HomeSuccess state) {
    debugPrint('now state is success and tweet container will start${state.tweetResource.data.toString()}');
    return Center(
        child: TweetListViewContainer(
      resource: state.tweetResource,
      baseViewModel: viewModel,
    ));
  }

  Widget _buildError() {
    return const Center(
      child: Text('Error View'),
    );
  }
}
