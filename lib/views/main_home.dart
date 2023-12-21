import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player_app/controller/main_controller.dart';
import 'package:music_player_app/views/favorite_songs.dart';
import 'package:music_player_app/views/home_view.dart';
import 'package:music_player_app/views/profile_view.dart';
import 'package:music_player_app/views/search_song.dart';
import 'package:music_player_app/views/song_player_detail.dart';

class MainHomeView extends StatefulWidget {
  const MainHomeView({super.key});

  @override
  State<MainHomeView> createState() => _MainHomeViewState();
}

class _MainHomeViewState extends State<MainHomeView> {
  final AudioController audioController = Get.put(AudioController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF161616),
      body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 3500),
          switchInCurve: Curves.bounceInOut,
          switchOutCurve: Curves.bounceOut,
          child: Obx(() => audioController.currentWidget.value)),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            color: const Color(0xFF191919),
            child: Obx(
              () => SizedBox(
                height: audioController.whichView == 3 ? 52 : 100,
                child: Column(
                  children: <Widget>[
                    audioController.whichView == 3
                        ? Container()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                                GestureDetector(
                                  onTap: () {
                                    audioController.currentWidget.value =
                                        const PlayerView();
                                    audioController.whichView.value = 3;
                                  },
                                  child: SizedBox(
                                    width: 300,
                                    child: Row(
                                      children: [
                                        Obx(
                                          () => Image.asset(
                                            audioController
                                                .songList[
                                                    audioController.index.value]
                                                .coverPhoto
                                                .value,
                                            fit: BoxFit.fitHeight,
                                            width: 50,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Obx(() => Text(audioController
                                                .songList[
                                                    audioController.index.value]
                                                .singerName
                                                .value)),
                                            Obx(() => Text(audioController
                                                .songList[
                                                    audioController.index.value]
                                                .songName
                                                .value))
                                          ],
                                        )),
                                      ],
                                    ),
                                  ),
                                ),
                                Obx(
                                  () => IconButton(
                                      onPressed: () {
                                        if (audioController.isPlaying.value) {
                                          audioController.isPlaying.value =
                                              false;
                                          audioController.audioPlayer.pause();
                                        } else {
                                          if (audioController
                                              .isPlayingFirstTime.value) {
                                            audioController.isPlaying.value =
                                                true;
                                            audioController.audioPlayer
                                                .resume();
                                          } else {
                                            audioController.isPlayingFirstTime
                                                .value = true;
                                            audioController.startMusicPlaying();
                                          }
                                        }
                                      },
                                      icon: audioController.isPlaying.value
                                          ? const Icon(Icons.pause)
                                          : const Icon(Icons.play_arrow)),
                                )
                              ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Obx(() => IconButton(
                              onPressed: () {
                                audioController.whichView.value = 1;
                                audioController.currentWidget.value =
                                    const HomeView();
                              },
                              icon: audioController.whichView.value == 1
                                  ? const Icon(
                                      Icons.home,
                                      color: Color(0xFF88AB8E),
                                      size: 32,
                                    )
                                  : const Icon(Icons.home))),
                          Obx(() => IconButton(
                              onPressed: () {
                                audioController.whichView.value = 2;
                                audioController.currentWidget.value =
                                    const SearchSongView();
                                audioController.filterSongs("");
                              },
                              icon: audioController.whichView.value == 2
                                  ? const Icon(
                                      Icons.search,
                                      color: Color(0xFF88AB8E),
                                      size: 32,
                                    )
                                  : const Icon(Icons.search))),
                          Obx(() => IconButton(
                              onPressed: () {
                                audioController.whichView.value = 3;
                                audioController.currentWidget.value =
                                    const PlayerView();
                              },
                              icon: audioController.whichView.value == 3
                                  ? const Icon(
                                      Icons.music_note_rounded,
                                      color: Color(0xFF88AB8E),
                                      size: 32,
                                    )
                                  : const Icon(Icons.music_note_rounded))),
                          Obx(() => IconButton(
                              onPressed: () {
                                //_changeWidget(const FavoriteSongsView());
                                audioController.whichView.value = 4;
                                audioController.currentWidget.value =
                                    const FavoriteSongsView();
                                audioController.getAndSetDuration();
                              },
                              icon: audioController.whichView.value == 4
                                  ? const Icon(Icons.favorite,
                                      color: Color(0xFF88AB8E), size: 32)
                                  : const Icon(Icons.favorite))),
                          Obx(() => IconButton(
                              onPressed: () {
                                //_changeWidget(const FavoriteSongsView());
                                audioController.whichView.value = 5;
                                audioController.currentWidget.value =
                                    const ProfileView();
                                audioController.getAndSetDuration();
                              },
                              icon: audioController.whichView.value == 5
                                  ? const Icon(Icons.person,
                                      color: Color(0xFF88AB8E), size: 32)
                                  : const Icon(Icons.person))),
                          // IconButton(
                          //     onPressed: () {}, icon: const Icon(Icons.person)),
                        ]),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
