import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:minispotify/models/audio_track_model.dart';
import 'package:minispotify/state/providers.dart';
import 'package:minispotify/ui/shared/currently_playing_thumbnail.dart';
import 'package:minispotify/ui/shared/currently_playing_title.dart';
import 'package:minispotify/ui/shared/play_pause_button.dart';
import 'package:minispotify/ui/shared/player_slider.dart';

import 'package:minispotify/extensions.dart';
import 'package:rxdart/rxdart.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class PlayerPage extends StatefulWidget {
  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  @override
  void dispose() {
    context.read(audioPlayerProvider).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          'My Awesome Playlist',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_arrow_down,
            size: 32,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0.0,
      ),
      body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xFFe63946), Colors.black.withOpacity(0.6)],
                  stops: [0.0, 0.4],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  tileMode: TileMode.repeated)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 60.0,
                  ),
                  child: CurrentlyPlayingThumbnail(
                    height: MediaQuery.of(context).size.width - 60,
                    width: MediaQuery.of(context).size.width - 60,
                  )),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: CurrentlyPlayingText(
                    fontSize: 14,
                  )),
              Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: PlayerControlWidget())
            ],
          )),
    );
  }
}

class PlayerControlWidget extends StatefulWidget {
  final ValueChanged<Duration> onChanged;
  PlayerControlWidget({
    this.onChanged,
  });
  @override
  _PlayerControlWidgetState createState() => _PlayerControlWidgetState();
}

class _PlayerControlWidgetState extends State<PlayerControlWidget> {
  AssetsAudioPlayer audioPlayer;
  @override
  void didChangeDependencies() {
    audioPlayer = context.read(audioPlayerProvider);

    super.didChangeDependencies();
  }

  double _dragValue;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Consumer(
              builder: (context, watch, child) {
                final totalDuration = watch(currentPositionProviderVaxt);
                return totalDuration.when(
                    data: (value) => Text("A ${Duration(seconds: value.toInt()).format()}"),
                    loading: () => Container(),
                    error: (_, __) => Container());
              },
            ),
            Flexible(
              flex: 2,
              child: Consumer(
                builder: (context, watch, child) {
                  final _player = watch(audioPlayerProvider);
                  final _playerDuration =
                      watch(totalDurationProvider).when(data: (duration) => duration, loading: () => 0.0, error: (_, __) => 0.0);
                  final _playerCurrent = watch(currentPositionProvider)
                      .when(data: (position) => position, loading: () => 0.0, error: (_, __) => 0.0);

                  // final _playerCurrent = watch(currentPositionProvider);
                  //final _playerDuration = watch(totalDurationProvider);
                  return StreamBuilder<Duration>(
                    stream: _player.currentPosition,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Slider(
                          value: 0.0,
                          onChanged: (double value) => null,
                          activeColor: Colors.transparent,
                          inactiveColor: Colors.transparent,
                        );
                      }
//
                      final Playing playing2 = _player.current.value;
                      Duration position = snapshot.data;
                      if (position == playing2.audio.duration) {
                        _dragValue = null;
                      } else {
                        _dragValue = position.inMilliseconds.toDouble();
                      }
                      print('object  ${position} - ${playing2.audio.duration}');
                      var _xxx = min(
                          _dragValue ?? position.inMilliseconds.toDouble(), playing2.audio.duration.inMilliseconds.toDouble());
                      return SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: Colors.white,
                          inactiveTrackColor: Colors.white.withOpacity(0.3),
                          thumbColor: Colors.white,
                          overlayColor: Colors.white.withOpacity(0.3),
                          trackHeight: 2,
                          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 4),
                        ),
                        child: SfSlider(
                          activeColor: Colors.blue,
                          inactiveColor: Colors.amber[50],
                          min: 0.0,
                          max: playing2.audio.duration.inMilliseconds.toDouble(),
                          value: _xxx,

//                         double _value = 4.0;

// SfSlider(
//   min: 0.0,
//   max: 10.0,
//   value: _value,
//   interval: 1,
//   showTicks: true,
//   showLabels: true,
//   inactiveColor: Colors.red,
//   onChanged: (dynamic newValue) {
//     setState(() {
//       _value = newValue;
//     });
//    },
// )

                          onChanged: (value) {
                            setState(() {
                              _dragValue = value;

                              print('object2  ${position} - ${playing2.audio.duration}');
                            });

                            print('object3  ${position} - ${playing2.audio.duration}');
                            _player.seek(Duration(milliseconds: value.toInt()));
                          },

                          // onChangeEnd: (value) {
                          //   // if (widget.onChanged != null) {
                          //   //   widget.onChanged(Duration(milliseconds: value.round()));
                          //   // }
                          //   _player.seek(Duration(milliseconds: value.round()));

                          //   _dragValue = null;
                          // },
                        ),
                      );
                    },
                  );
                },
              ),
              // PlayerSlider(
              //   isMini: false,
              // ),
            ),
            Consumer(
              builder: (context, watch, child) {
                final totalDuration = watch(totalDurationProviderVaxt);
                return totalDuration.when(
                    data: (value) => Text(Duration(seconds: value.toInt()).format()),
                    loading: () => Container(),
                    error: (_, __) => Container());
              },
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 90,
              width: 90,
              child: IconButton(
                icon: Icon(
                  Icons.skip_previous,
                  size: 40,
                ),
                onPressed: () {
                  audioPlayer.previous();
                },
              ),
            ),
            SizedBox(
              height: 90,
              width: 90,
              child: PlayPauseButton(
                height: 90,
                width: 90,
                iconSize: 70,
                pauseIcon: Icons.pause_circle_filled,
                playIcon: Icons.play_circle_filled,
              ),
            ),
            SizedBox(
              height: 90,
              width: 90,
              child: IconButton(
                icon: Icon(
                  Icons.skip_next,
                  size: 40,
                ),
                onPressed: () {
                  _dragValue = null;
                  audioPlayer.next();
                },
              ),
            ),
          ],
        )
      ],
    );
  }
}
