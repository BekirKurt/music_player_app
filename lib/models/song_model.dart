import 'package:get/get.dart';

class Song {
  final int songId;
  RxString singerName;
  RxString songName;
  RxString coverPhoto;
  final String audioUrl;
  RxBool isFavorited;

  Song({
    required this.songId,
    required this.singerName,
    required this.songName,
    required this.coverPhoto,
    required this.audioUrl,
    required this.isFavorited,
  });
}
