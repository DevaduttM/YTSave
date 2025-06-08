import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:yt_save/domain/appcolors.dart';
import 'package:yt_save/services/download_service.dart';
import 'package:yt_save/widgets/uihelper.dart';

class YoutubePlayerPage extends StatefulWidget {
  final String videoUrl;
  final String name;
  final String channel;
  final Video video;

  const YoutubePlayerPage({
    required this.videoUrl,
    required this.name,
    required this.channel,
    required this.video,
  });

  @override
  State<YoutubePlayerPage> createState() => _YoutubePlayerPageState();
}

class _YoutubePlayerPageState extends State<YoutubePlayerPage> {
  late YoutubePlayerController _controller;
  final downloadService = DownloadService();
  bool isFullScreen = false;

  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl) ?? "";

    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );

    _controller.addListener(() {
      if (_controller.value.isFullScreen != isFullScreen) {
        _handleFullscreenChange(_controller.value.isFullScreen);
      }
    });
  }

  void _handleFullscreenChange(bool fullscreen) {
    setState(() {
      isFullScreen = fullscreen;
    });

    if (fullscreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
  }

  Future<bool> _onWillPop() async {
    if (isFullScreen) {
      _controller.toggleFullScreenMode();
      _handleFullscreenChange(false);
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: isFullScreen
            ? null
            : AppBar(
          title: UiHelper.CustomText(
              text: "Video Player", color: Colors.white, fontsize: 18),
          backgroundColor: AppColors.background2,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        backgroundColor: AppColors.background1,
        body: SafeArea(
          child: YoutubePlayerBuilder(
            player: YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              bottomActions: const [
                CurrentPosition(),
                ProgressBar(isExpanded: true),
                PlaybackSpeedButton(),
                FullScreenButton(),
              ],
            ),
            builder: (context, player) {
              return Column(
                children: [
                  // Video player takes the top portion
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: player,
                  ),
                  if (!isFullScreen) ...[
                    const SizedBox(height: 20),
                    UiHelper.CustomText(
                        text: widget.name,
                        color: Colors.white,
                        fontsize: 16),
                    UiHelper.CustomText(
                        text: widget.channel,
                        color: Colors.white54,
                        fontsize: 14),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: (MediaQuery.of(context).size.width * 0.95) / 1.9,
                      height: 30,
                      child: ElevatedButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20)),
                            ),
                            builder: (context) {
                              return DownloadStreamsSheet(
                                video: widget.video,
                                url: widget.videoUrl,
                                downloadService: downloadService,
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0XFFDBDF5B),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.all(4.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: UiHelper.CustomText(
                          text: "Download",
                          color: Colors.black,
                          fontsize: 10,
                        ),
                      ),
                    ),
                  ]
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
