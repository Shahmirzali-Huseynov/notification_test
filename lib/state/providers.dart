import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minispotify/models/audio_track_model.dart';

final playlistProvider = Provider(
  (ref) => AudioTrackModel(
    artistName: 'Benjamin Tissot',
    trackName: 'My Old East Coast (feat. Melanie)',
    thumbnail: 'https://www.bensound.com/bensound-img/ukulele.jpg',
    audioUrl: 'https://ia601403.us.archive.org/24/items/6dqvb-y-7-x-5-fss.-128/6dqvbY7X5FSs.128.mp3',
    //'https://www.bensound.com/bensound-music/bensound-ukulele.mp3',
  ),
);
// final audio = Audio(
//   "/assets/audio/country.mp3",
//   metas: Metas(
//     title: "Country",
//     artist: "Florent Champigny",
//     album: "CountryAlbum",
//     image: MetasImage.asset("assets/images/country.jpg"), //can be MetasImage.network
//   ),
// );
final audioPlayerProvider = Provider.autoDispose<AssetsAudioPlayer>((ref) {
  final playlist = ref.watch(playlistProvider);
  final audioPlayer = AssetsAudioPlayer();
  //audioPlayer.
  audioPlayer.open(
    Audio.network(
      playlist.audioUrl,
      metas: Metas(
        album: 'xxx',
        title: 'yyyy',
        artist: 'zzzz',
        image: MetasImage.network(
          playlist.thumbnail,
        ),
      ),
      // cached: true,
    ),
    notificationSettings: NotificationSettings(
      stopEnabled: false,
      customNextAction: (player) {
        player.seekBy(Duration(seconds: 4));
      },
    ),
    autoStart: false,
    showNotification: true,
  );
  return audioPlayer;
});

final currentlyPlayingProvider = StreamProvider.autoDispose<AudioTrackModel>((ref) {
  final playlist = ref.watch(playlistProvider);
  final audioPlayer = ref.watch(audioPlayerProvider);
  // return audioPlayer.currentPosition;
  return audioPlayer.current.map((playing) => playlist);
});

final totalDurationProvider = StreamProvider.autoDispose<double>((ref) {
  final audioPlayer = ref.watch(audioPlayerProvider);
  return audioPlayer.current.map((playing) => playing.audio.duration.inMilliseconds.toDouble());
});

final currentPositionProvider = StreamProvider.autoDispose<double>((ref) {
  final audioPlayer = ref.watch(audioPlayerProvider);
  return audioPlayer.currentPosition.map((position) => position.inMilliseconds.toDouble());
});

final totalDurationProviderVaxt = StreamProvider.autoDispose<double>((ref) {
  final audioPlayer = ref.watch(audioPlayerProvider);
  return audioPlayer.current.map((playing) => playing.audio.duration.inSeconds.toDouble());
});

final currentPositionProviderVaxt = StreamProvider.autoDispose<double>((ref) {
  final audioPlayer = ref.watch(audioPlayerProvider);
  return audioPlayer.currentPosition.map((position) => position.inSeconds.toDouble());
});

final playingStateProvider = StreamProvider.autoDispose<bool>((ref) {
  final audioPlayer = ref.watch(audioPlayerProvider);
  return audioPlayer.isPlaying;
});

//----------------------------------------------------------------------------------

// final playListProvider = Provider((ref) => AudioSource.uri(
//       Uri.parse(
//         "https://ia601403.us.archive.org/24/items/6dqvb-y-7-x-5-fss.-128/6dqvbY7X5FSs.128.mp3",
//       ),
//       tag: AudioMetadata(
//         album: "Ramazan Yazıları",
//         title: "Nureddin Yıldız - Ramazan ayı ne değildir?",
//         artwork: "https://i1.sndcdn.com/artworks-EyyEYEk9y6IRRzEk-iVffOA-t500x500.jpg",
//       ),
//     ));

// final audioPlayerProvider = Provider<AudioPlayer>((ref) {
//   //final playlist = ref.watch(playListProvider);
//   AudioPlayer player = AudioPlayer();

//   return player;
// });

// final playerSequenceStateStream = StreamProvider<SequenceState>((ref) {
//   final audioPlayer = ref.watch(audioPlayerProvider);
//   return audioPlayer.sequenceStateStream;
// });
