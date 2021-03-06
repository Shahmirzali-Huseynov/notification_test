import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:minispotify/state/providers.dart';

class CurrentlyPlayingText extends ConsumerWidget {
  final double fontSize;
  final TextAlign textAlign;

  CurrentlyPlayingText({this.fontSize, this.textAlign = TextAlign.center});

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final currentlyPlaying = watch(playlistProvider);
    return Text(
      '${currentlyPlaying.trackName} \u25CF ${currentlyPlaying.artistName} ',
      style: TextStyle(fontSize: fontSize),
      textAlign: textAlign,
      overflow: TextOverflow.ellipsis,
    );
    // loading: () => Container(),
    // error: (_, __) => Container());
  }
}
