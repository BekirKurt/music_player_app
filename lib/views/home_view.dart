import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player_app/controller/main_controller.dart';
import 'package:music_player_app/views/search_song.dart';
import 'package:music_player_app/views/song_player_detail.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final AudioController audioController = Get.put(AudioController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(children: [
          const SizedBox(height: 30),
          headerWidget,
          const SizedBox(height: 20),
          GestureDetector(
              onTap: () {
                audioController.currentWidget.value = const SearchSongView();
                audioController.filterSongs("");
              },
              child: searchWidget),
          const SizedBox(height: 20),
          popularMusics,
          newReleases
        ]),
      ),
    );
  }

  Widget get headerWidget => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            CircleAvatar(child: Text("1")),
            SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Hello"),
                Text("MusicElegance"),
              ],
            )
          ],
        ),
      );

  Widget get searchWidget => Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 50,
        child: TextField(
          enabled: false,
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
      );

  Widget get popularMusics => Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 300,
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Popular Musics",
                style: Theme.of(context).textTheme.displaySmall,
              ),
              TextButton(
                  onPressed: () {
                    audioController.whichView.value = 2;
                    audioController.currentWidget.value =
                        const SearchSongView();
                    audioController.filterSongs("");
                  },
                  child: Row(children: [
                    Text(
                      "See all",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const Icon(
                      Icons.navigate_next_outlined,
                      color: Colors.white,
                    )
                  ]))
            ],
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  width: 200,
                  child: GestureDetector(
                    onTap: () {
                      audioController.audioPlayer.stop();
                      audioController.index.value =
                          audioController.songList[index + 1].songId;
                      audioController.startMusicPlaying();
                      audioController.currentWidget.value =
                          const PlayerView(); // changeWidget(const PlayerView());
                      audioController.whichView.value = 3;
                      audioController.isPlayingFirstTime.value = true;
                      Future.delayed(const Duration(seconds: 1),
                          () => audioController.getAndSetDuration());
                    },
                    child: Card(
                      //color: Colors.green.shade400,
                      child: Obx(
                        () => Image.asset(
                          audioController.songList[index + 1].coverPhoto.value,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ]),
      );

  Widget get newReleases => Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("New Releases",
                  style: Theme.of(context).textTheme.displaySmall),
              TextButton(
                  onPressed: () {
                    audioController.whichView.value = 2;
                    audioController.currentWidget.value =
                        const SearchSongView();
                    audioController.filterSongs("");
                  },
                  child: Row(children: [
                    Text("See all",
                        style: Theme.of(context).textTheme.bodyMedium),
                    const Icon(
                      Icons.navigate_next_outlined,
                      color: Colors.white,
                    )
                  ]))
            ],
          ),
          for (var i = 0; i < audioController.songList.length; i++)
            ListTile(
              onTap: () {
                audioController.audioPlayer.stop();
                audioController.index.value = i;
                audioController.startMusicPlaying();
                audioController.currentWidget.value = const PlayerView();
                audioController.whichView.value = 3;
                audioController.isPlayingFirstTime.value = true;
                Future.delayed(const Duration(seconds: 1),
                    () => audioController.getAndSetDuration());
              },
              leading: Obx(
                () => Image.asset(
                  audioController.songList[i].coverPhoto.value,
                  fit: BoxFit.fitHeight,
                  width: 60,
                ),
              ),
              title: Text(
                audioController.songList[i].singerName.value,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              subtitle: Text(
                audioController.songList[i].songName.value,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              trailing: const Icon(Icons.arrow_forward_ios_rounded,
                  color: Colors.white),
            )
        ]),
      );
}
