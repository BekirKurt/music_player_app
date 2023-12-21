import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player_app/controller/main_controller.dart';
import 'package:music_player_app/views/home_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final AudioController audioController = Get.put(AudioController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      audioController.whichView.value = 1;
                      audioController.currentWidget.value = const HomeView();
                    },
                    icon: const Icon(Icons.arrow_back_ios_new_outlined)),
                Text("Profile page..",
                    style: Theme.of(context).textTheme.displaySmall)
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(children: [
                CircleAvatar(child: Text("1")),
                SizedBox(width: 10),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("username"),
                    Text("Mail"),
                  ],
                ))
              ]),
            ),
            //  Text(audioController.songs[0].artist.value),

            Obx(() => Text(
                "Total favorite song count : ${audioController.favoritedSongs.length}")),
          ],
        ),
      ),
    );
  }
}
