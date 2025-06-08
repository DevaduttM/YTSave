import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:yt_save/domain/appcolors.dart';
import 'package:shimmer/shimmer.dart';
import 'package:yt_save/screens/home/home_screen.dart';
import 'package:yt_save/services/download_service.dart';
import 'package:yt_save/services/isar_service.dart';
import 'package:yt_save/widgets/liquid_loading.dart';
import 'package:yt_save/widgets/youtube_player.dart';
import 'package:open_file/open_file.dart';


import '../screens/searchresult/search_result_screen.dart';

class UiHelper {
  static CustomImage({required String img}) {
    return Image.asset("assets/images/$img");
  }

  static CustomText({
    required String text,
    required Color color,
    String? fontfamily,
    required double fontsize,
  }) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontsize,
        fontFamily: fontfamily ?? "regular",
        color: color,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  static CustomTextField({
    required TextEditingController controller,
    required BuildContext context,
  }) {
    void handleSearch() {
      final query = controller.text.trim();
      if (query.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchResultScreen(query: query),
          ),
        );
      }
    }
    return Container(
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.white,
      ),
      child: TextField(
        controller: controller,
        textInputAction: TextInputAction.search,
        onSubmitted: (_) => handleSearch(),
        decoration: InputDecoration(
          hintText: "Search or paste link to download",
          hintStyle: TextStyle(fontSize: 14),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          suffixIcon: GestureDetector(
            onTap: handleSearch,
            child: UiHelper.CustomImage(img: "Search.png"),
          ),
        ),
      ),
    );
  }

  static CustomTextFieldTwo({
    required TextEditingController controller,
    required BuildContext context,
  }) {
    return Container(
      height: 35,
      margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Color(0xFFAFAFAF), width: 0.5),
        color: Color(0xFFFFFFFF),
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: "Search or paste link",
          hintStyle: TextStyle(fontSize: 14),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 11, horizontal: 12),
          suffixIcon: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchResultScreen(query: controller.text.trim(),)),
              );
            },
            icon: UiHelper.CustomImage(img: "Search.png"),
          ),
        ),
      ),
    );
  }

  static DownloadOptions({
    required String type,
    required String quality,
    required String size,
    required BuildContext context,
    required VoidCallback onPressed,
    double? progress,
  }) {

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.85,
      child: progress == null ? Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  UiHelper.CustomText(
                    text: type,
                    color: Colors.white,
                    fontsize: 15,
                  ),
                  UiHelper.CustomText(
                    text: quality,
                    color: Color(0xFF9C9C9C),
                    fontsize: 12,
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      UiHelper.CustomText(
                        text: size,
                        color: Color(0xFF9C9C9C),
                        fontsize: 12,
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: onPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: EdgeInsets.all(0),
                        ),
                        child: UiHelper.CustomImage(img: "Download.png"),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ) : Column(
        children: [
          if (progress <= 1.0)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 4,
                color: Colors.green,
                backgroundColor: Colors.grey.shade800,
              ),
            )
          else if(progress == 1.5)
            Padding(padding: const EdgeInsets.only(top: 9.0),
              child: CircularProgressIndicator(),)
          else if(progress == 2.0)
              Padding(padding: const EdgeInsets.only(top: 9.0),
                child: UiHelper.CustomText(text: "Download Complete", color: Colors.white, fontsize: 10),),
          SizedBox(height: 5,),
        ],
      )
    );
  }

  static Widget ShimmerWidget({required BuildContext context}) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF3B3B3B),
      highlightColor: const Color(0xFF4E4E4E),
      child: Container(
        height: 133,
        width: MediaQuery.of(context).size.width * 0.95,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF2C2C2C),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  static Widget ShimmerWidgetTwo({required BuildContext context}) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF3B3B3B),
      highlightColor: const Color(0xFF4E4E4E),
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        decoration: BoxDecoration(
          color: const Color(0xFF2C2C2C),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }


  static VideoCard({
    required BuildContext context,
    required String name,
    required String channel,
    required bool home,
    required String imageUrl,
    required Video video,
    required String url,
  }) {

    final downloadService = DownloadService();
    final seconds = video.duration?.inSeconds ?? 0;

    return Container(
      height: 120,
      width: MediaQuery.of(context).size.width * 0.9,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.background5,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 6.2,
            offset: Offset(1, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => YoutubePlayerPage(videoUrl: url, name:name, channel: channel, video: video,),
                ),
              );
            },
            child: Container(
              height: 107,
              width: (MediaQuery.of(context).size.width * 0.95) / 2.35,
              decoration: BoxDecoration(
                color: Color(0xFF535353),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(imageUrl,
                      fit: BoxFit.fitWidth,
                      height: 107,
                      width: (MediaQuery.of(context).size.width + 0.95) / 2.35,),
                  ),
                  // UiHelper.CustomImage(img: "SplashLogo.png"),
                  UiHelper.CustomImage(img: "Play.png"),
                  Positioned(
                    bottom: 5,
                      right: 5,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(5, 1, 5, 1),
                        height: 15,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: Color(0xBF000000),
                        ),
                          child: UiHelper.CustomText(text: "${seconds~/60}:${(seconds % 60).toString().padLeft(2, '0')}", color: Colors.white, fontsize: 10),
                      )
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            width: (MediaQuery.of(context).size.width * 0.95) / 1.9,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: UiHelper.CustomText(
                        text: name,
                        color: Colors.white,
                        fontfamily: "bold",
                        fontsize: 12,
                      ),),
                      home
                          ? UiHelper.CustomText(
                              text: "MP4",
                              color: Color(0xFFDBDF60),
                              fontfamily: "bold",
                              fontsize: 10,
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      UiHelper.CustomText(
                        text: channel,
                        color: Colors.white,
                        fontsize: 10,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  home
                      ? SizedBox(
                          width:
                              (MediaQuery.of(context).size.width * 0.95) / 1.9,
                          height: 30,
                          child: ElevatedButton(
                            onPressed: () {
                              print("hi");
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0XFFDBDF5B),
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.all(4.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: UiHelper.CustomText(
                              text: "Go to location",
                              color: Colors.black,
                              fontsize: 10,
                            ),
                          ),
                        )
                      : SizedBox(
                          width:
                              (MediaQuery.of(context).size.width * 0.95) / 1.9,
                          height: 30,
                          child: ElevatedButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                ),
                                builder: (context) {
                                  return DownloadStreamsSheet(
                                    video: video,
                                    url: url,
                                    downloadService: downloadService,
                                  );
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0XFFDBDF5B),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static VideoCardTwo({
    required BuildContext context,
    required String name,
    required String channel,
    required bool home,
    required String imageUrl,
    required String url,
    required String filePath,
    required int seconds,
    required int id,
    required VoidCallback onDelete
  }) {
    print(filePath);

    return Container(
      height: 120,
      width: MediaQuery.of(context).size.width * 0.9,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.background5,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 6.2,
            offset: Offset(1, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
           Container(
              height: 107,
              width: (MediaQuery.of(context).size.width * 0.95) / 2.35,
              decoration: BoxDecoration(
                color: Color(0xFF535353),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(imageUrl,
                      fit: BoxFit.fitWidth,
                      height: 107,
                      width: (MediaQuery.of(context).size.width + 0.95) / 2.35,),
                  ),
                  // UiHelper.CustomImage(img: "SplashLogo.png"),
                  UiHelper.CustomImage(img: "Play.png"),
                  Positioned(
                      bottom: 5,
                      right: 5,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(5, 1, 5, 1),
                        height: 15,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: Color(0xBF000000),
                        ),
                        child: UiHelper.CustomText(text: "${seconds~/60}:${(seconds % 60).toString().padLeft(2, '0')}", color: Colors.white, fontsize: 10),
                      )
                  )
                ],
              ),
            ),
          SizedBox(
            width: (MediaQuery.of(context).size.width * 0.95) / 1.9,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: UiHelper.CustomText(
                        text: name,
                        color: Colors.white,
                        fontfamily: "bold",
                        fontsize: 12,
                      ),),
                      SizedBox(width: 5,),
                      GestureDetector(
                        onTap: () async {
                          final shouldDelete = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              backgroundColor: AppColors.background2,
                              title: UiHelper.CustomText(text: "Delete Video", color: Colors.white, fontsize: 20),
                              content: UiHelper.CustomText(text: "Are you sure you want to delete this video?", color: Colors.white70, fontsize: 12),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(false),
                                  child: UiHelper.CustomText(text: "Cancel", color: Colors.white54, fontsize: 14)
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(true),
                                  child: UiHelper.CustomText(text: "Ok", color: Colors.red, fontsize: 14)
                                ),
                              ],
                            ),
                          );

                          if (shouldDelete == true) {
                            final isarService = IsarService();
                            try {
                              await isarService.deleteVideoWithFile(id);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)
                                  ),
                                  content: UiHelper.CustomText(
                                    text: "Video Deleted Successfully",
                                    color: Colors.white70,
                                    fontsize: 12,
                                  ),
                                  backgroundColor: Color(0xFF4B4B4B),
                                  behavior: SnackBarBehavior.floating,
                                  duration: Duration(seconds: 2),
                                ),
                              );

                              onDelete();
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)
                                  ),
                                  content: UiHelper.CustomText(
                                    text: "Error! Could not delete file",
                                    color: Colors.white70,
                                    fontsize: 12,
                                  ),
                                  backgroundColor: Color(0xFF4B4B4B),
                                  behavior: SnackBarBehavior.floating,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          }
                        },
                        child: UiHelper.CustomImage(img: "DeleteIcon.png"),
                      )
                    ],
                  ),
                  SizedBox(height: 7,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      UiHelper.CustomText(
                        text: channel,
                        color: Colors.white,
                        fontsize: 10,
                      ),
                      UiHelper.CustomText(
                        text: filePath.contains(".")
                            ? filePath.substring(filePath.lastIndexOf(".") + 1).toUpperCase()
                            : "",
                        color: Color(0xFFDBDF60),
                        fontfamily: "bold",
                        fontsize: 9,
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  SizedBox(
                    width:
                    (MediaQuery.of(context).size.width * 0.95) / 1.9,
                    height: 30,
                    child: ElevatedButton(
                      onPressed: () {
                        OpenFile.open(filePath);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0XFFDBDF5B),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.all(4.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: UiHelper.CustomText(
                        text: "Go to location",
                        color: Colors.black,
                        fontsize: 10,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}



class DownloadStreamsSheet extends StatefulWidget {
  final Video video;
  final DownloadService downloadService;
  final String url;

  const DownloadStreamsSheet({
    super.key,
    required this.video,
    required this.downloadService,
    required this.url
  });

  @override
  State<DownloadStreamsSheet> createState() => DownloadStreamsSheetState();
}

class DownloadStreamsSheetState extends State<DownloadStreamsSheet> {
  bool _showButton = false;
  bool _timeStarted = false;
  final Map<int, double> _downloadProgress = {};
  List<dynamic>? streams;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadStreams();
  }

  Future<void> _loadStreams() async {
    try {
      final streamsMap = await widget.downloadService.getAvailableStreams(widget.url);
      setState(() {
        streams = streamsMap.toList();
      });
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double? isDownloading = _downloadProgress.values.isNotEmpty
        ? _downloadProgress.values.first
        : null;

    // double isDownloading = 2.5;

    if (isDownloading == null) {
      return Container(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: BoxDecoration(
          color: Color(0xFF282828),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            SizedBox(height: 6),
            Container(
              width: 70,
              height: 3,
              decoration: BoxDecoration(
                color: Color(0xFF4B4B4B),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Download Options",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(height: 15),
            Divider(color: Color(0xFF5C5C5C)),
            Expanded(
                child: error != null
                    ? Center(child: Text("Error: $error", style: TextStyle(color: Colors.red)))
                    : streams == null
                    ? Center(
                  child: Column(
                    children: List.generate(
                      5,
                          (index) => UiHelper.ShimmerWidgetTwo(context: context),
                    ),
                  ),
                )
                    :
                streams!.isEmpty ? Center(
                  child: UiHelper.CustomText(text: "No Streams Available", color: Colors.white, fontsize: 16),
                )
                    : ListView.separated(
                    itemCount: streams!.length,
                    separatorBuilder: (_, __) => const Divider(color: Color(0xFF5C5C5C)),
                    itemBuilder: (context, index) {
                      final stream = streams![index];
                      final progress = _downloadProgress[index];

                      final isAudio = stream is AudioOnlyStreamInfo;
                      final type = isAudio ? "Audio - MP3" : "Video - MP4";

                      final quality = isAudio
                          ? "${stream.bitrate.bitsPerSecond ~/ 1000} Kbps"
                          : (stream as MergedStream).qualityLabel ?? "Unknown";

                      final sizeMB = isAudio
                          ? "${stream.size.totalMegaBytes.toStringAsFixed(1)} MB"
                          : "${(stream as MergedStream).video.size.totalMegaBytes.toStringAsFixed(1)} MB";


                      return UiHelper.DownloadOptions(
                        type: type,
                        quality: quality,
                        size: sizeMB,
                        context: context,
                        progress: null,
                        onPressed: () async {
                          setState(() => _downloadProgress[index] = 0.0);
                          await widget.downloadService.downloadVideo(
                            streamInfo: stream,
                            videoUrl: widget.url,
                            onProgress: (double newProgress) {
                              setState(() {
                                _downloadProgress[index] = newProgress;
                              });
                            },
                          );
                        },
                      );
                    }

                )


            ),
          ],
        ),
      );
    }

    else if (isDownloading == 1.5 || isDownloading == 2.5){
      return Container(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Color(0xFF282828),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
              children: [
                SizedBox(height: 6),
                Container(
                  width: 70,
                  height: 3,
                  decoration: BoxDecoration(
                    color: Color(0xFF4B4B4B),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Processing...",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                SizedBox(height: 15),
                Divider(color: Color(0xFF5C5C5C)),
                Container(
                  height: MediaQuery.of(context).size.height * 0.35,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: Colors.white,
                      ),
                      SizedBox(height: 20,),
                      isDownloading == 1.5 ?
                      Text(
                        "Processing Video...",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ) : Text(
                        "Processing Audio...",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                ),

              ]
          )
      );
    }

    else if(isDownloading == 2.0) {
      _timeStarted = true;

      Future.delayed(Duration(seconds: 2), () {
        if(mounted){
          setState(() {
            _showButton = true;
          });
        }
      });
      return Container(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Color(0xFF282828),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
              children: [
                SizedBox(height: 6),
                Container(
                  width: 70,
                  height: 3,
                  decoration: BoxDecoration(
                    color: Color(0xFF4B4B4B),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Completed...",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                SizedBox(height: 15),
                Divider(color: Color(0xFF5C5C5C)),
                Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.35,
                  child: Column(
                    children: [
                      Lottie.asset("assets/images/Tick_Animation.json", width: 250, height: 250, repeat: false, animate: true),
                      _showButton ?
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(),
                            ),
                          );
                        },
                        child: Container(
                          height: 35,
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color(0xFFDBDF5B)
                          ),
                          alignment: Alignment.center,
                          child: UiHelper.CustomText(text: "Go to Downloads", color: Colors.black, fontsize: 12),
                        ),
                      ) : SizedBox.shrink()
                    ],
                  )
                )
              ]
          )
      );
    }
    else if(isDownloading <= 1.0) {
      return Container(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Color(0xFF282828),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
              children: [
                SizedBox(height: 6),
                Container(
                  width: 70,
                  height: 3,
                  decoration: BoxDecoration(
                    color: Color(0xFF4B4B4B),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Downloading...",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                SizedBox(height: 15,),
                Divider(color: Color(0xFF5C5C5C)),
                SizedBox(height: 50),
                Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white70
                      ),
                      height: 100,
                      width: 200,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LiquidLoading(progress: isDownloading),
                          ),
                          UiHelper.CustomImage(img: "DownloadIcon.png")
                        ],
                      )
                    ),
                ),
                SizedBox(height: 20,),
                UiHelper.CustomText(text: "Downloading: ${(isDownloading*100).toInt()}%", color: Colors.white, fontsize: 18),
                SizedBox(height: 20,),
                GestureDetector(
                  onTap: () {Navigator.pop(context);},
                  child: Container(
                    width: 200,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white70
                    ),
                    child: Center(child: UiHelper.CustomText(text: "Cancel", color: Colors.black, fontsize: 16)),
                  ),
                )
              ]
          )
      );
    }
    else {
      return Container(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Color(0xFF282828),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
              children: [
                SizedBox(height: 6),
                Container(
                  width: 70,
                  height: 3,
                  decoration: BoxDecoration(
                    color: Color(0xFF4B4B4B),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Error",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                SizedBox(height: 15),

              ]
          )
      );
    }
  }
}

