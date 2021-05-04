import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minispotify/models/audio_track_model.dart';

final playlistProvider = Provider((ref) => [
      AudioTrackModel(
          artistName: 'Benjamin Tissot',
          trackName: 'My Old East Coast (feat. Melanie)',
          thumbnail: 'https://www.bensound.com/bensound-img/ukulele.jpg',
          audioUrl: 'https://www.bensound.com/bensound-music/bensound-ukulele.mp3'),
      AudioTrackModel(
          artistName: 'Benjamin Tissot',
          trackName: 'Creative Minds',
          thumbnail: 'https://www.bensound.com/bensound-img/creativeminds.jpg',
          audioUrl: 'https://www.bensound.com/bensound-music/bensound-creativeminds.mp3'),
      AudioTrackModel(
          artistName: 'Benjamin Tissot',
          trackName: 'Little Idea',
          thumbnail: 'https://www.bensound.com/bensound-img/littleidea.jpg',
          audioUrl: 'https://www.bensound.com/bensound-music/bensound-littleidea.mp3'),
      AudioTrackModel(
          artistName: 'Benjamin Tissot',
          trackName: 'Jazzy Frenchy',
          thumbnail: 'https://www.bensound.com/bensound-img/jazzyfrenchy.jpg',
          audioUrl: 'https://www.bensound.com/bensound-music/bensound-jazzyfrenchy.mp3'),
      AudioTrackModel(
          artistName: 'Benjamin Tissot',
          trackName: 'Cute',
          thumbnail: 'https://www.bensound.com/bensound-img/littleidea.jpg',
          audioUrl: 'https://www.bensound.com/bensound-music/bensound-littleidea.mp3'),
      AudioTrackModel(
          artistName: 'Benjamin Tissot',
          trackName: 'Cute',
          thumbnail: 'https://www.bensound.com/bensound-img/cute.jpg',
          audioUrl: 'https://www.bensound.com/bensound-music/bensound-cute.mp3'),
      AudioTrackModel(
          artistName: 'Benjamin Tissot',
          trackName: 'Memories',
          thumbnail: 'https://www.bensound.com/bensound-img/memories.jpg',
          audioUrl: 'https://www.bensound.com/bensound-music/bensound-memories.mp3'),
      AudioTrackModel(
          artistName: 'Benjamin Tissot',
          trackName: 'Slow Motion',
          thumbnail: 'https://www.bensound.com/bensound-img/slowmotion.jpg',
          audioUrl: 'https://www.bensound.com/bensound-music/bensound-slowmotion.mp3'),
      AudioTrackModel(
          artistName: 'Benjamin Tissot',
          trackName: 'Funny Song',
          thumbnail: 'https://www.bensound.com/bensound-img/funnysong.jpg',
          audioUrl: 'https://www.bensound.com/bensound-music/bensound-funnysong.mp3'),
    ]);
final audio = Audio(
  "/assets/audio/country.mp3",
  metas: Metas(
    title: "Country",
    artist: "Florent Champigny",
    album: "CountryAlbum",
    image: MetasImage.asset("assets/images/country.jpg"), //can be MetasImage.network
  ),
);
final audioPlayerProvider = Provider.autoDispose<AssetsAudioPlayer>((ref) {
  final playlist = ref.watch(playlistProvider);
  final audioPlayer = AssetsAudioPlayer();
  //audioPlayer.
  audioPlayer.open(
    Playlist(
      audios: playlist
          .map((audioTrackModel) => Audio.network(
                audioTrackModel.audioUrl,
                metas: Metas(
                  album: 'xxx',
                  title: 'yyyy',
                  artist: 'zzzz',
                  image: MetasImage.network(
                    audioTrackModel.thumbnail,
                  ),
                ),
                // cached: true,
              ))
          .toList(),
    ),
    notificationSettings: NotificationSettings(
      customNextAction: (player) {
        print('30 saniye saga');
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
   return audioPlayer.current.map((playing) => playlist[playing.index]);
});

final totalDurationProvider = StreamProvider.autoDispose<double>((ref) {
  final audioPlayer = ref.watch(audioPlayerProvider);
  return audioPlayer.current.map((playing) => playing.audio.duration.inMilliseconds.toDouble());
});

final currentPositionProvider = StreamProvider.autoDispose<double>((ref) {
  final audioPlayer = ref.watch(audioPlayerProvider);
  return audioPlayer.currentPosition.map((position) => position.inMilliseconds.toDouble());
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
