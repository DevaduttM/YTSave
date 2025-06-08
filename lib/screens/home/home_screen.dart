import 'package:flutter/material.dart';
import 'package:yt_save/domain/appcolors.dart';
import 'package:yt_save/models/video_metadata.dart';
import 'package:yt_save/services/isar_service.dart';
import 'package:yt_save/widgets/uihelper.dart';
import 'package:yt_save/main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with RouteAware {
  late IsarService _isarService;
  List<VideoMetadata> _videos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _isarService = IsarService();
    _loadVideos();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }

  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    _isLoading = true;
    _loadVideos();
  }

  Future<void> _loadVideos() async {
    final videos = await _isarService.getAllVideos();
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      _videos = videos;
      _isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background1,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.background3, AppColors.background4],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.all(Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x40000000),
                    blurRadius: 7.9,
                    spreadRadius: 5,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              height: MediaQuery.of(context).size.height * 0.27,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          UiHelper.CustomText(
                            text: "YT",
                            color: Color(0xFFFFFFFF),
                            fontfamily: "bold",
                            fontsize: 24,
                          ),
                          UiHelper.CustomText(
                            text: " Save",
                            color: Color(0xFF000000),
                            fontfamily: "bold",
                            fontsize: 24,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          UiHelper.CustomText(
                            text: "Download and view Youtube videos",
                            fontfamily: "bold",
                            color: Color(0xFF181035),
                            fontsize: 13,
                          ),
                          UiHelper.CustomText(
                            text: " Effortlessly",
                            fontfamily: "bold",
                            color: Color(0xFF313131),
                            fontsize: 13,
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          UiHelper.CustomTextField(
                            controller: SearchController(),
                            context: context,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: UiHelper.CustomText(
                text: "Your Downloads",
                color: Colors.white,
                fontsize: 22,
              ),
            ),
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 50),
              child: _isLoading
                  ? Center(
                      child: Column(
                        children: List.generate(
                          4,
                          (index) => UiHelper.ShimmerWidget(context: context),
                        ),
                      ),
                    )
                  : _videos.isEmpty
                  ? Center(
                      child: UiHelper.CustomText(
                        text: "No Downloaded Videos",
                        color: Colors.white54,
                        fontsize: 16,
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 2),
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: _videos.length,
                            itemBuilder: (context, index) {
                              final video = _videos[index];
                              return UiHelper.VideoCardTwo(
                                context: context,
                                name: video.title,
                                channel: video.author,
                                imageUrl: video.thumbnailUrl,
                                url: video.url,
                                home: true,
                                filePath: video.filepath,
                                seconds: video.durationInSeconds,
                                id: video.id
                              );
                            },
                          ),
                        )

                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
