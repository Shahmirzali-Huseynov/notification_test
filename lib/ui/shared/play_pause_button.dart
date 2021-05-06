import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minispotify/state/providers.dart';

class PlayPauseButton extends ConsumerWidget {
  final double width;
  final double height;
  final double iconSize;
  final IconData pauseIcon;
  final IconData playIcon;

  PlayPauseButton(
      {this.width, this.height, this.pauseIcon, this.playIcon, this.iconSize});

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    
    return watch(playingStateProvider).when(
        data: (isPlaying) => Center(
              child: SizedBox(
                height: height,
                width: width,
                child: IconButton(
                  padding: EdgeInsets.all(0),
                  icon: SizedBox(
                    height: height,
                    width: width,
                    child: Icon(
                      isPlaying ? pauseIcon : playIcon,
                      size: iconSize,
                    ),
                  ),
                  onPressed: () {
                    context.read(audioPlayerProvider).playOrPause();
                  },
                ),
              ),
            ),
        loading: () => Container(
                margin: EdgeInsets.all(8.0),
                width: 50,
                height: 50,
                child: CircularProgressIndicator(),
              ),
        error: (_, __) => Container());
  }
}
