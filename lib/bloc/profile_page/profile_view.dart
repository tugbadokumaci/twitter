import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter/bloc/profile_page/profile_cubit.dart';
import 'package:twitter/bloc/profile_page/profile_state.dart';
import 'package:twitter/utils/button_utils.dart';
import 'package:twitter/utils/constants.dart';
import 'package:twitter/widget/profile_photo_widget.dart';
import 'package:twitter/widget/tweet_containers_utils.dart';
import '../../utils/box_constants.dart';
import '../../utils/theme_utils.dart';
import '../../widget/box.dart';
import '../../widget/media_containers_utils.dart';

class ProfileView extends StatelessWidget {
  final ProfileCubit viewModel;
  const ProfileView({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileCubit>(
      create: (_) => viewModel,
      child: _buildScaffold(context),
    );
  }

  Widget _buildScaffold(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Constants.USER.name,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
        centerTitle: false,
      ),
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/tweet');
          viewModel.getUserProfile();
        },
        backgroundColor: CustomColors.blue,
        child: SizedBox(
          width: 45, // Set the desired width
          height: 45, // Set the desired height
          child: Image.asset('assets/images/new_tweet.png'),
        ),
      ),
      body: SingleChildScrollView(
        child: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is ProfileInitial) {
              //   debugPrint('listener profileinitial ');
              //   WidgetsBinding.instance.addPostFrameCallback((_) {
              //     debugPrint('method invoked');
              // viewModel.getUserTweets();
              //   });
              //   // devamlı cagırılıyor mu?
            }
          },
          builder: (context, state) {
            debugPrint('Profile view state: $state');
            if (state is ProfileInitial) {
              return _buildInitial(context);
            }
            if (state is ProfileLoading) {
              return _buildLoading();
            } else if (state is ProfileSuccess) {
              return _buildSuccess(context);
            } else if (state is ProfileError) {
              return _buildError();
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget _buildInitial(BuildContext context) {
    viewModel.getUserProfile();
    return const Center(
      child: Text('profile initial'),
    );
  }

  Widget _buildLoading() {
    return Center(
        child: CircularProgressIndicator(
      color: CustomColors.blue,
      backgroundColor: CustomColors.lightGray,
    ));
  }

  Widget _buildSuccess(BuildContext context) {
    return Center(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _profileHeader(context),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(Constants.USER.name, style: Theme.of(context).textTheme.headlineSmall),
              Text(
                '@${Constants.USER.username}',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(color: CustomColors.lightGray),
              ),
              const Box(size: BoxSize.SMALL, type: BoxType.VERTICAL),
              Text((Constants.USER.bio == '' ? 'Biyografi bilgisi bulunmamaktadır.' : Constants.USER.bio)),
              const Box(size: BoxSize.SMALL, type: BoxType.VERTICAL),
              Padding(
                padding: const EdgeInsets.only(bottom: 3.0),
                child: Row(
                  children: [
                    const Icon(Icons.pin_drop, size: 20),
                    Text((Constants.USER.location == '' ? 'Konum bilgisi bulunmamaktadır.' : 'Konum, Konum'))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 3.0),
                child: Row(
                  children: [const Icon(Icons.cake, size: 20), Text(Constants.USER.birthday)],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 3.0),
                child: Row(
                  children: [const Icon(Icons.calendar_month, size: 20), Text(Constants.USER.accountCreationDate)],
                ),
              ),
              const Box(size: BoxSize.SMALL, type: BoxType.VERTICAL),
              Row(
                children: [
                  Text('${Constants.USER.following.length} Takip edilen'),
                  const Box(size: BoxSize.MEDIUM, type: BoxType.HORIZONTAL),
                  Text('${Constants.USER.followers.length} Takipçi'),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.5, // Half of the screen height
          child: DefaultTabController(
            length: 5, // Number of tabs
            child: Column(
              children: [
                TabBar(
                  isScrollable: true,
                  indicatorColor: CustomColors.blue,
                  tabs: const [
                    Tab(text: 'Tweetler'),
                    Tab(text: 'Yanıtlar'),
                    Tab(text: 'Öne Çıkanlar'),
                    Tab(text: 'Medya'),
                    Tab(text: 'Beğeni'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      tweetContainer(),
                      yanitlarContainer(),
                      oneCikanlarContainer(),
                      medyaContainer(),
                      begeniContainer(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  SizedBox _profileHeader(BuildContext context) {
    return SizedBox(
      height: 170,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(height: 170, width: MediaQuery.of(context).size.width, color: Colors.black),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
                height: 130,
                width: MediaQuery.of(context).size.width,
                child: Image.asset('assets/images/default_background.webp', fit: BoxFit.fitWidth)),
          ),
          Positioned(
              bottom: 0.0, right: 300.0, child: CustomCircleAvatar(photoUrl: Constants.USER.profilePhoto, radius: 40)),
          Align(
            alignment: const Alignment(0.9, 1.3),
            child: MyButtonWidget(
              onPressed: () {
                Navigator.pushNamed(context, '/edit');
              },
              buttonColor: Colors.transparent,
              content: const Text('Profili Düzenle'),
              context: context,
              height: 30,
              width: 100,
              borderColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget tweetContainer() {
    if (viewModel.tweetResource.data == null) {
      return const Center(child: Text('Atımış tweetiniz bulunmamaktadır.'));
    }
    return tweetListViewContainer(resource: viewModel.tweetResource);
  }

  Widget yanitlarContainer() {
    return Container(
      color: Colors.black,
      child: const Center(child: Text('Yanıtınız bulunmamaktadır.')),
    );
  }

  Widget oneCikanlarContainer() {
    return Container(
      color: Colors.black,
      child: const Center(child: Text('One Cıkanlarınız bulunmamaktadır.')),
    );
  }

  Widget medyaContainer() {
    if (viewModel.mediaResource.data == null) {
      return const Center(child: Text('Atımış tweetiniz bulunmamaktadır.'));
    }
    return mediaListViewContainer(viewModel.mediaResource);
  }

  Widget begeniContainer() {
    return Container(
      color: Colors.black,
      child: const Center(child: Text('Begeniniz bulunmamaktadır.')),
    );
  }

  Widget _buildError() {
    return const Center(
      child: Text('Profile Error'),
    );
  }
}
