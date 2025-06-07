import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:yt_save/services/youtube_service.dart';

final youtubeServiceProvider = Provider<YoutubeService>((ref) {
  return YoutubeService();
});
class SearchNotifier extends StateNotifier<AsyncValue<List<Video>>> {
  final YoutubeService _service;

  SearchNotifier(this._service) : super(const AsyncValue.data([]));

  Future<void> search(String query) async {
    state = const AsyncValue.loading();
    try {
      final results = await _service.searchVideos(query);
      state = AsyncValue.data(results);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void clear() {
    state = const AsyncValue.data([]);
  }
}

final searchProvider = StateNotifierProvider<SearchNotifier, AsyncValue<List<Video>>>(
      (ref) => SearchNotifier(ref.read(youtubeServiceProvider)),
);
