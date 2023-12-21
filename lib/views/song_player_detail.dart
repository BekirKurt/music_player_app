import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player_app/controller/main_controller.dart';
import 'package:music_player_app/views/home_view.dart';

class PlayerView extends StatefulWidget {
  const PlayerView({super.key});

  @override
  State<PlayerView> createState() => _PlayerViewState();
}

class _PlayerViewState extends State<PlayerView> {
  final AudioController audioController = Get.put(AudioController());
  @override
  void initState() {
    super.initState();
    audioController.getAndSetDuration();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () {
                      audioController.whichView.value = 1;
                      audioController.currentWidget.value = const HomeView();
                    },
                    icon: const Icon(Icons.arrow_back_ios_new_outlined)),
                Text(
                  "Now Playing..",
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ],
            ),
            const SizedBox(height: 26),
            Container(
                height: 350,
                width: 350,
                color: Colors.amber.shade600,
                child: Obx(
                  () => Image.asset(
                    audioController
                        .songList[audioController.index.value].coverPhoto.value,
                    fit: BoxFit.cover,
                  ),
                )),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                        () => Text(audioController
                            .songList[audioController.index.value]
                            .singerName
                            .value),
                      ),
                      Obx(
                        () => Text(
                            audioController
                                .songList[audioController.index.value]
                                .songName
                                .value,
                            style: Theme.of(context).textTheme.displaySmall),
                      )
                    ],
                  ),
                  Obx(() => IconButton(
                        onPressed: () => audioController.onPressedFavoriteIcon(
                            audioController
                                .songList[audioController.index.value].songId),
                        icon: audioController
                                .songList[audioController.index.value]
                                .isFavorited
                                .value
                            ? const Icon(Icons.favorite,
                                color: Colors.red, size: 26)
                            : const Icon(Icons.favorite, size: 26),
                      ))
                ],
              ),
            ),
            const SizedBox(height: 18),
            // Container(
            //     padding: const EdgeInsets.symmetric(horizontal: 20),
            //     child: Obx(
            //       () => LinearProgressIndicator(
            //         value: audioController.songPercentage.value,
            //         backgroundColor: Colors.grey,
            //         valueColor:
            //             const AlwaysStoppedAnimation<Color>(Colors.blue),
            //       ),
            //     )),
            Obx(
              () => Slider(
                min: 0,
                max: audioController.duration.value!.inSeconds.ceilToDouble() +
                    2,
                value: audioController.position.value!.inSeconds.toDouble(),
                onChanged: (value) {
                  audioController.seekToDec(Duration(seconds: value.toInt()));
                },
                onChangeStart: (value) {
                  audioController.seekToDec(Duration(seconds: value.toInt()));
                },
                onChangeEnd: (value) {
                  audioController.seekToDec(Duration(seconds: value.toInt()));
                },
              ),
            ),

            const SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => Text(
                      "${audioController.position.value?.inMinutes}:${(audioController.position.value!.inSeconds % 60).toString().padLeft(2, '0')}")),
                  Obx(() => Text(
                      "${audioController.duration.value?.inMinutes}:${(audioController.duration.value!.inSeconds % 60).toString().padLeft(2, '0')}"))
                  //Text(widget.song.duration.toString()),
                ],
              ),
            ),

            const SizedBox(height: 18),
            // Text(audioController
            //     .songList[audioController.index.value].audioUrl),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration: const BoxDecoration(
                      color: Color(0xFF323232), shape: BoxShape.circle),
                  child: IconButton(
                      onPressed: () {
                        audioController.previousSong();
                        Future.delayed(const Duration(seconds: 1),
                            () => audioController.getAndSetDuration());
                      },
                      icon: const Icon(Icons.skip_previous_rounded)),
                ),
                Container(
                  height: 60,
                  width: 60,
                  decoration: const BoxDecoration(
                      color: Color(0xFF323232), shape: BoxShape.circle),
                  child: IconButton(
                      onPressed: () {
                        audioController.seekToDec(Duration(
                            seconds: audioController.position.value!.inSeconds -
                                10));
                      },
                      icon: const Icon(Icons.replay_10)),
                ),
                Container(
                    height: 80,
                    width: 80,
                    decoration: const BoxDecoration(
                        color: Color(0xFF323232), shape: BoxShape.circle),
                    child: Obx(
                      () => IconButton(
                          onPressed: () {
                            if (audioController.isPlaying.value) {
                              audioController.isPlaying.value = false;
                              audioController.audioPlayer.pause();
                            } else {
                              if (audioController.isPlayingFirstTime.value) {
                                audioController.isPlaying.value = true;
                                audioController.audioPlayer.resume();
                              } else {
                                audioController.isPlayingFirstTime.value = true;
                                audioController.startMusicPlaying();
                                Future.delayed(
                                  const Duration(seconds: 1),
                                  () => audioController.getAndSetDuration(),
                                );
                              }
                            }
                          },
                          icon: audioController.isPlaying.value
                              ? const Icon(Icons.pause)
                              : const Icon(Icons.play_arrow)),
                    )),
                Container(
                  height: 60,
                  width: 60,
                  decoration: const BoxDecoration(
                      color: Color(0xFF323232), shape: BoxShape.circle),
                  child: IconButton(
                      onPressed: () {
                        audioController.seekToDec(Duration(
                            seconds: audioController.position.value!.inSeconds +
                                10));
                      },
                      icon: const Icon(Icons.forward_10)),
                ),
                Container(
                  height: 60,
                  width: 60,
                  decoration: const BoxDecoration(
                      color: Color(0xFF323232), shape: BoxShape.circle),
                  child: IconButton(
                    onPressed: () {
                      audioController.nextSong();
                      Future.delayed(const Duration(seconds: 1),
                          () => audioController.getAndSetDuration());
                    },
                    icon: const Icon(Icons.skip_next_rounded),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
