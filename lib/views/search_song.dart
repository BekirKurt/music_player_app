import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player_app/controller/main_controller.dart';
import 'package:music_player_app/views/home_view.dart';
import 'package:music_player_app/views/song_player_detail.dart';

class SearchSongView extends StatefulWidget {
  const SearchSongView({super.key});

  @override
  State<SearchSongView> createState() => _SearchSongViewState();
}

class _SearchSongViewState extends State<SearchSongView> {
  final AudioController audioController = Get.put(AudioController());
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

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
                const SizedBox(height: 16),
                IconButton(
                    onPressed: () {
                      audioController.whichView.value = 1;
                      audioController.currentWidget.value = const HomeView();
                    },
                    icon: const Icon(Icons.arrow_back_ios_new_outlined)),
                Text(
                  "Search songs..",
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: 50,
              child: TextField(
                controller: searchController,
                onChanged: (value) => audioController.filterSongs(value),
                decoration: InputDecoration(
                    focusColor: const Color(0xFFBEBEBE),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF323232)),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF323232)),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    prefixIcon: const Icon(Icons.search),
                    prefixIconColor: const Color(0xFFBEBEBE),
                    filled: true,
                    fillColor: const Color(0xFF191919),
                    hintStyle: const TextStyle(color: Color(0xFFBEBEBE)),
                    hintText: "Search for artists or songs"),
                style: const TextStyle(color: Color(0xFFBEBEBE)),
              ),
            ),
            SizedBox(
              height: 500,
              child: Obx(
                () => audioController.isFound.value &&
                        audioController.filteredSongs.isEmpty
                    ? ListView.builder(
                        itemCount: audioController.songList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              audioController.audioPlayer.stop();
                              audioController.index.value =
                                  audioController.songList[index].songId;
                              audioController.startMusicPlaying();
                              audioController.currentWidget.value =
                                  const PlayerView();
                              audioController.isPlayingFirstTime.value = true;
                              audioController.whichView.value = 3;
                              Future.delayed(const Duration(seconds: 1),
                                  () => audioController.getAndSetDuration());
                            },
                            leading: Image.asset(
                              audioController.songList[index].coverPhoto.value,
                              fit: BoxFit.fitHeight,
                              width: 60,
                            ),
                            title: Text(
                                audioController
                                    .songList[index].singerName.value,
                                style: Theme.of(context).textTheme.bodySmall),
                            subtitle: Text(
                                audioController.songList[index].songName.value),
                          );
                        },
                      )
                    : !audioController.isFound.value
                        ? const Center(
                            child: Text("songs or artist not found.."))
                        : ListView.builder(
                            itemCount: audioController.filteredSongs.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                onTap: () {
                                  audioController.audioPlayer.stop();
                                  audioController.index.value = audioController
                                      .filteredSongs[index].songId;
                                  audioController.startMusicPlaying();
                                  audioController.currentWidget.value =
                                      const PlayerView();
                                  audioController.isPlayingFirstTime.value =
                                      true;
                                  audioController.whichView.value = 3;
                                  Future.delayed(
                                      const Duration(seconds: 1),
                                      () =>
                                          audioController.getAndSetDuration());
                                },
                                leading: Image.asset(
                                  audioController
                                      .filteredSongs[index].coverPhoto.value,
                                  fit: BoxFit.fitHeight,
                                  width: 60,
                                ),
                                title: Text(
                                    audioController
                                        .filteredSongs[index].singerName.value,
                                    style:
                                        Theme.of(context).textTheme.bodySmall),
                                subtitle: Text(audioController
                                    .filteredSongs[index].songName.value),
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
