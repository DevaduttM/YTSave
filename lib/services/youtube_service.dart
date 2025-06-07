import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YoutubeService {
  final yt = YoutubeExplode();

  Future<Video?> getVideoDetails(String url) async {
    try {
      var video = await yt.videos.get(url);
      return video;
    }
    catch(_) {
      return null;
    }
  }

  Future<List<Video>> searchVideos(String query) async {
    try {
      final video = await yt.videos.get(query);
      return [video];
    } catch (_) {
      var searchResults = await yt.search(query);
      return searchResults.whereType<Video>().toList();
    }
  }


  void dispose() {
    yt.close();
  }
}