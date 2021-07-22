import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

final audioCache = AudioCache(
      prefix: "assets/sound/",
      fixedPlayer: AudioPlayer()..setReleaseMode(ReleaseMode.STOP));