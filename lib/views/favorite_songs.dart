import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player_app/controller/main_controller.dart';
import 'package:music_player_app/views/home_view.dart';
import 'package:music_player_app/views/song_player_detail.dart';

class FavoriteSongsView extends StatefulWidget {
  const FavoriteSongsView({super.key});

  @override
  State<FavoriteSongsView> createState() => _FavoriteSongsViewState();
}

class _FavoriteSongsViewState extends State<FavoriteSongsView> {
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
                Text("Favorite songs..",
                    style: Theme.of(context).textTheme.displaySmall)
              ],
            ),
            SizedBox(
              height: 400,
              child: audioController.favoritedSongs.isEmpty
                  ? const Center(child: Text("List is empty.."))
                  : Obx(
                      () => ListView.builder(
                        itemCount: audioController.favoritedSongs.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              // if the current songId is equal to  ontapped favorite song, the song will not be changed.
                              if (audioController
                                      .favoritedSongs[index].songId ==
                                  audioController
                                      .songList[audioController.index.value]
                                      .songId) {
                                audioController.currentWidget.value =
                                    const PlayerView();
                                audioController.whichView.value = 3;
                              } else {
                                audioController.audioPlayer.stop();
                                audioController.index.value = audioController
                                    .favoritedSongs[index].songId;
                                audioController.startMusicPlaying();
                                audioController.currentWidget.value =
                                    const PlayerView();
                                audioController.whichView.value = 3;
                                audioController.isPlayingFirstTime.value = true;
                                Future.delayed(const Duration(seconds: 1),
                                    () => audioController.getAndSetDuration());
                              }
                            },
                            leading: Image.asset(
                              audioController
                                  .favoritedSongs[index].coverPhoto.value,
                              fit: BoxFit.fitHeight,
                              width: 60,
                            ),
                            title: Text(
                              audioController
                                  .favoritedSongs[index].singerName.value,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            subtitle: Text(
                              audioController
                                  .favoritedSongs[index].songName.value,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            trailing: IconButton(
                                onPressed: () => audioController
                                    .removeFavoriteSongFromView(audioController
                                        .favoritedSongs[index].songId),
                                icon: const Icon(Icons.remove,
                                    color: Colors.white)),
                          );
                        },
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
