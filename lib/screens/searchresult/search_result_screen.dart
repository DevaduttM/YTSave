import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yt_save/domain/appcolors.dart';
import 'package:yt_save/models/video_metadata.dart';
import 'package:yt_save/widgets/uihelper.dart';
import 'package:yt_save/providers/video_provider.dart';

class SearchResultScreen extends ConsumerStatefulWidget {
  final String query;
  const SearchResultScreen({super.key, required this.query});

  @override
  ConsumerState<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends ConsumerState<SearchResultScreen> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.query);
    Future.microtask(
      () => ref.read(searchProvider.notifier).search(widget.query),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);
    void handleSearch() {
      FocusScope.of(context).unfocus();
      ref
          .read(searchProvider.notifier)
          .search(_controller.text);
    }

    return Scaffold(
      backgroundColor: AppColors.background1,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
            height: 140,
            decoration: const BoxDecoration(
              color: Color(0xFF2B2B2B),
              boxShadow: [
                BoxShadow(
                  color: Color(0x66000000),
                  blurRadius: 8.3,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 11),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: UiHelper.CustomImage(img: "Back.png"),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: MediaQuery.of(context).size.width * 0.88,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFFAFAFAF),
                      width: 1,
                    ),
                  ),
                  child: TextField(
                    controller: _controller,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) =>  handleSearch(),
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Search or paste link",
                      hintStyle: const TextStyle(fontSize: 14),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 13,
                        horizontal: 12,
                      ),
                      suffixIcon: GestureDetector(
                        onTap: handleSearch,
                        child: UiHelper.CustomImage(img: "SearchOnly.png"),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),

          Expanded(
            child: searchState.when(
              data: (videos) {
                if (videos.isEmpty) {
                  return const Center(
                    child: Text(
                      'No results found',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: videos.length,
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 2),
                  itemBuilder: (context, index) {
                    final video = videos[index];
                    final metadata = VideoMetadata()
                      ..title = video.title
                      ..url = video.url
                      ..durationInSeconds = video.duration?.inSeconds ?? 0
                      ..thumbnailUrl = video.thumbnails.highResUrl
                      ..author = video.author;

                    return UiHelper.VideoCard(
                      context: context,
                      name: metadata.title,
                      channel: metadata.author,
                      imageUrl: metadata.thumbnailUrl,
                      video: video,
                      url: metadata.url,
                      home: false,
                    );
                  },
                );
              },
              loading: () => Padding(
                padding: const EdgeInsets.fromLTRB(2, 8, 2, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: List.generate(
                    4,
                        (index) => UiHelper.ShimmerWidget(context: context),
                  ),
                ),
              ),


              error: (err, st) => Center(
                child: Text(
                  'Error: $err',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
