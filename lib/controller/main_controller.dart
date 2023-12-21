import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player_app/models/song_model.dart';
import 'package:music_player_app/views/home_view.dart';

class AudioController extends GetxController {
  AudioPlayer audioPlayer = AudioPlayer();
  RxBool isPlaying = false.obs;
  RxBool isPlayingFirstTime = false.obs;

  Rx<Duration?> duration = const Duration(seconds: 0).obs;
  Rx<Duration?> position = const Duration(seconds: 0).obs;
  var index = 0.obs;
  var songPercentage = 0.0.obs;
  var songSeconds = 0.obs;

  // this value observes main home body changes
  Rx<Widget> currentWidget = Rx<Widget>(const HomeView());

  // bottombar observer
  RxInt whichView = 1.obs;

  RxList<Song> favoritedSongs = <Song>[].obs;
  var songList = [
    Song(
      songId: 0,
      singerName: RxString("Maroon5"),
      songName: RxString("Girls like you ft Cardi B"),
      audioUrl:
          "audios/audio1_Maroon_5_-_Girls_Like_You_ft_Cardi_B[MP3.support].mp3",
      coverPhoto: RxString("assets/images/maroon_5.jpeg"),
      isFavorited: RxBool(false),
    ),
    Song(
      songId: 1,
      singerName: RxString("Mi Gna"),
      songName: RxString("Super Sako Ft  Spitakci Hayko"),
      audioUrl: "audios/audio2_Mi Gna   Super Sako Ft  Spitakci Hayko.mp3",
      coverPhoto: RxString("assets/images/migna.jpg"),
      isFavorited: RxBool(false),
    ),
    Song(
      songId: 2,
      singerName: RxString("Wiz Khalifa, Juicy J ft Miley Cyrus"),
      songName: RxString("Will made it"),
      audioUrl:
          "audios/audio3_Mike WiLL Made-It - 23 (Explicit) ft. Miley Cyrus, Wiz Khalifa, Juicy J.mp3",
      coverPhoto: RxString("assets/images/wizkhalifa.jpg"),
      isFavorited: RxBool(false),
    ),
    Song(
      songId: 3,
      singerName: RxString("No Method"),
      songName: RxString("Let Me Go (Official Lyric Video)"),
      audioUrl:
          "audios/audio4_No Method - Let Me Go (Official Lyric Video).mp3",
      coverPhoto: RxString("assets/images/nomethod.jpg"),
      isFavorited: RxBool(false),
    ),
    Song(
      songId: 4,
      singerName: RxString("PostMalone"),
      songName: RxString("Rockstar"),
      audioUrl:
          "audios/audio5_Post_Malone_-_rockstar_ft_21_Savage[MP3.support].mp3",
      coverPhoto: RxString("assets/images/rockstar.jpg"),
      isFavorited: RxBool(false),
    ),
    Song(
      songId: 5,
      singerName: RxString("Shakira"),
      songName: RxString("Chantaje ft. Maluma"),
      audioUrl: "audios/audio6_Shakira - Chantaje ft. Maluma.mp3",
      coverPhoto: RxString("assets/images/shakira.jpg"),
      isFavorited: RxBool(false),
    )
  ].obs;

  // filter songs

  var filteredSongs = <Song>[].obs;
  var isFound = true.obs;

  final TextEditingController searchController = TextEditingController();
  void filterSongs(String query) {
    filteredSongs.assignAll(songList.where((Song song) {
      final singerNameLower = song.singerName.value.toLowerCase();
      final songNameLower = song.songName.value.toLowerCase();
      final queryLower = query.toLowerCase();

      return singerNameLower.contains(queryLower) ||
          songNameLower.contains(queryLower);
    }).toList());

    if (filteredSongs.isNotEmpty) {
      isFound.value = true;
    } else {
      isFound.value = false;
    }
  }

  // functions
  void startMusicPlaying() {
    audioPlayer = AudioPlayer();
    audioPlayer
        .setSource(AssetSource(songList[index.value].audioUrl))
        .then((value) {
      audioPlayer.play(AssetSource(songList[index.value].audioUrl));
    });
    isPlaying.value = true;
  }

  Future<void> seekToDec(Duration position) async =>
      await audioPlayer.seek(position);

  void nextSong() {
    audioPlayer.stop();
    audioPlayer.dispose();
    index.value >= songList.length - 1 ? index.value = 0 : index.value++;
    startMusicPlaying();
    Future.delayed(const Duration(seconds: 1), () => getAndSetDuration());
  }

  void previousSong() {
    if (position.value!.inSeconds > 5) {
      audioPlayer.stop();
      audioPlayer.dispose();
      startMusicPlaying();
      Future.delayed(const Duration(seconds: 1), () => getAndSetDuration());
    } else {
      audioPlayer.stop();
      audioPlayer.dispose();
      index.value > 0 ? index.value-- : index.value = songList.length - 1;
      startMusicPlaying();
      Future.delayed(const Duration(seconds: 1), () => getAndSetDuration());
    }
  }

  void getPlayerChanges(Duration? newPosition) {
    audioPlayer.onPositionChanged.listen((newPosition) {
      position.value = newPosition;
      songPercentage.value = (position.value!.inSeconds.toDouble() /
          duration.value!.inSeconds.toDouble());
      songSeconds.value = newPosition.inSeconds;
    });
    //songCompleted();
    audioPlayer.onPlayerComplete.listen((event) {
      nextSong();
    });
  }

  // void songCompleted() {
  //   audioPlayer.onPlayerComplete.listen((event) {
  //     nextSong();
  //   });
  // }

  Future<void> getAndSetDuration() async {
    // final durationValue = await audioPlayer.getDuration();
    // duration.value = durationValue;

    try {
      Duration? durationValue = await Future.delayed(
          const Duration(seconds: 1), () => audioPlayer.getDuration());
      duration.value = durationValue;
    } catch (e) {
      print('getDuration error: $e');
    }
    try {
      Duration? positionValue = await Future.delayed(
          const Duration(seconds: 1), () => audioPlayer.getCurrentPosition());
      position.value = positionValue;
      getPlayerChanges(positionValue);
    } catch (e) {
      print('getCurrentPosition error: $e');
    }
//    getPlayerChanges(positionValue);
  }

  // favorite songs functions
  void addFavoriteSong() => favoritedSongs.add(songList[index.value]);

  void removeFavoriteSong(int songId) =>
      favoritedSongs.removeWhere((Song song) => song.songId == songId);

  void removeFavoriteSongFromView(int songId) {
    favoritedSongs.removeWhere((Song song) => song.songId == songId);
    for (var song in songList) {
      if (song.songId == songId) {
        song.isFavorited.value = !song.isFavorited.value;
        break;
      }
    }
  }

  void onPressedFavoriteIcon([int songId = 0]) {
    if (songList[index.value].isFavorited.value) {
      removeFavoriteSong(songId);
    } else {
      addFavoriteSong();
    }
    songList[index.value].isFavorited.value =
        !songList[index.value].isFavorited.value;
  }
}
