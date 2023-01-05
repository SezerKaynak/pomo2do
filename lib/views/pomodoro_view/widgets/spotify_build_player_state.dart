import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:pomotodo/core/providers/spotify_provider.dart';
import 'package:pomotodo/views/pomodoro_view/widgets/sized_icon_button.dart';
import 'package:pomotodo/views/pomodoro_view/widgets/spotify_image_widget.dart';
import 'package:provider/provider.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

Widget buildPlayerStateWidget(BuildContext context) {
  SpotifyProvider spotifyProvider = Provider.of<SpotifyProvider>(context);
  return StreamBuilder<PlayerState>(
    stream: SpotifySdk.subscribePlayerState(),
    builder: (BuildContext context, AsyncSnapshot<PlayerState> snapshot) {
      var track = snapshot.data?.track;
      spotifyProvider.currentTrackImageUri = track?.imageUri;
      var playerState = snapshot.data;
      if (playerState == null) {
        return Center(
          child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8), topRight: Radius.circular(8))),
            height: kToolbarHeight,
            child: InkWell(
              onTap: () {
                spotifyProvider.connectToSpotifyRemote();
              },
              child: const Center(
                  child: Text(
                "Spotify'a Bağlan",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              )),
            ),
          ),
        );
      } else if (track == null) {
        return Container(
            color: Theme.of(context).primaryColor,
            height: kToolbarHeight,
            child: Center(
              child: AutoSizeText(
                "Spotify'a bağlandı, uygulamadan şarkıyı açın.",
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                maxLines: 1,
                overflowReplacement: SizedBox(
                  height: kToolbarHeight,
                  child: Marquee(
                    blankSpace: 10,
                    text: "Spotify'a bağlandı, uygulamadan şarkıyı açın.",
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    velocity: 20.0,
                  ),
                ),
              ),
            ));
      }
      spotifyProvider.isPlaying = !playerState.isPaused;
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Stack(children: [
                spotifyImageWidget(track.imageUri),
                SizedBox(
                  width: kToolbarHeight * 3,
                  height: kToolbarHeight,
                  child: Center(
                    child: AutoSizeText(
                      track.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflowReplacement: SizedBox(
                        width: kToolbarHeight * 3,
                        height: kToolbarHeight,
                        child: Marquee(
                          blankSpace: 10,
                          text: track.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          velocity: 20.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  height: kToolbarHeight,
                  width: kToolbarHeight * 3,
                  child: Center(
                    child: Wrap(
                      spacing: 10,
                      runAlignment: WrapAlignment.center,
                      children: [
                        SizedIconButton(
                          width: 50,
                          icon: Icons.skip_previous,
                          onPressed: spotifyProvider.skipPrevious,
                        ),
                        spotifyProvider.isPlaying
                            ? SizedIconButton(
                                width: 50,
                                icon: Icons.pause,
                                onPressed: spotifyProvider.pause,
                              )
                            : SizedIconButton(
                                width: 50,
                                icon: Icons.play_arrow,
                                onPressed: spotifyProvider.resume,
                              ),
                        SizedIconButton(
                            width: 50,
                            icon: Icons.skip_next,
                            onPressed: spotifyProvider.skipNext),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}
