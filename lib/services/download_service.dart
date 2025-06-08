import 'dart:io';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:yt_save/models/video_metadata.dart';
import 'package:yt_save/services/isar_service.dart';

class DownloadService {
  final YoutubeExplode yt = YoutubeExplode();

  Future<List<dynamic>> getAvailableStreams(String url) async {
    var manifest = await yt.videos.streams.getManifest(url);

    List<AudioOnlyStreamInfo> audioStreams = manifest.audioOnly
        .where((stream) =>
    double.parse(stream.bitrate.toString().substring(0, stream.bitrate
        .toString()
        .length - 7)) > 128)
        .toList();

      List<VideoOnlyStreamInfo> videoOnlyStreams = manifest.videoOnly.where((e) => e.container == StreamContainer.mp4 && e.qualityLabel != "144p").toList();

      AudioOnlyStreamInfo? highestAudio = audioStreams.isNotEmpty
          ? audioStreams.reduce(
              (a, b) => double.parse(a.bitrate.toString().substring(0, a.bitrate.toString().length - 7)) > double.parse(b.bitrate.toString().substring(0, b.bitrate.toString().length - 7)) ? a : b)
          : null;

      var grouped = <String, List<VideoOnlyStreamInfo>>{};
      for (var stream in videoOnlyStreams) {
        grouped
            .putIfAbsent(stream.qualityLabel ?? "Unknown", () => [])
            .add(stream);
      }

      List<MergedStream> mergedStreams = [];
      grouped.forEach((quality, streams) {
        var maxVideo = streams.reduce((a, b) => double.parse(a.size.toString().substring(0, a.size.toString().length - 3)) > double.parse(b.size.toString().substring(0, b.size.toString().length - 3)) ? a : b);
        if (highestAudio != null) {
          mergedStreams.add(MergedStream(video: maxVideo, audio: highestAudio, qualityLabel: maxVideo.qualityLabel));
        }
      });

      List<dynamic> combined =[];
      combined.addAll(mergedStreams);
      combined.addAll(audioStreams);

      return combined;

  }

  Future<void> downloadVideo ({
    required dynamic streamInfo,
    required String videoUrl,
    void Function(double progress)? onProgress,
}) async {
    try{
      final yt = YoutubeExplode();
      final isarService = IsarService();
      final video = await yt.videos.get(videoUrl);
      final dir = await getApplicationDocumentsDirectory();

      final safeTitle = video.title.replaceAll(RegExp(r'[^\w\s\-]'), '_');
      final author = video.author;
      final thumbnailUrl = video.thumbnails.highResUrl;
      final duration = video.duration?.inSeconds ?? 0;

      String filePath = "";
      String fileName = "";

      if (streamInfo is AudioOnlyStreamInfo) {
        fileName = "$safeTitle-audio.mp3";
        final tempAudioFile = File("${dir.path}/temp_audio.webm");
        filePath = "${dir.path}/$fileName";

        final stream = yt.videos.streams.get(streamInfo);
        final file = File(filePath);
        final fileStream = tempAudioFile.openWrite();

        int totalBytes = streamInfo.size.totalBytes;
        int bytesWritten = 0;

        await for (final chunk in stream) {
          fileStream.add(chunk);
          bytesWritten += chunk.length;
          if (onProgress != null) {
            onProgress(bytesWritten / totalBytes);
          }
        }
        await fileStream.flush();
        await fileStream.close();

        print("Converting to MP3");

        if(onProgress != null) onProgress(2.5);
        try{
          await FFmpegKit.execute(
              '-i "${tempAudioFile.path}" -vn -c:a libmp3lame -b:a 320k "${file.path}"'
          );
          print("Conversion complete");
          if(onProgress != null) onProgress(2);
        }
        catch (e) {
          print("Conversion Error $e");
        }

        if (await tempAudioFile.exists()) {
          await tempAudioFile.delete();
        }

      }

      else if (streamInfo is MergedStream) {
        fileName = "$safeTitle-${streamInfo.qualityLabel}.mp4";
        filePath = "${dir.path}/$fileName";

        final videoStream = yt.videos.streams.get(streamInfo.video);
        final audioStream = yt.videos.streams.get(streamInfo.audio);

        final tempVideoFile = File("${dir.path}/temp_video.mp4");
        final tempAudioFile = File("${dir.path}/temp_audio.webm");

        // await videoStream.pipe(tempVideoFile.openWrite());
        // await audioStream.pipe(tempAudioFile.openWrite());


        int videoTotalBytes = streamInfo.video.size.totalBytes;
        int audioTotalBytes = streamInfo.audio.size.totalBytes;
        int totalBytes = videoTotalBytes + audioTotalBytes;

        int bytesDownloaded = 0;

        final videoSink = tempVideoFile.openWrite();
        await for (final chunk in videoStream) {
          videoSink.add(chunk);
          bytesDownloaded += chunk.length;
          if (onProgress != null) {
            onProgress(bytesDownloaded / totalBytes);
          }
          double progress = (bytesDownloaded / totalBytes) * 100;
          print("Downloading video/audio... ${progress.toStringAsFixed(2)}%");
        }
        await videoSink.flush();
        await videoSink.close();

        final audioSink = tempAudioFile.openWrite();
        await for (final chunk in audioStream) {
          audioSink.add(chunk);
          bytesDownloaded += chunk.length;
          if (onProgress != null) {
            onProgress(bytesDownloaded / totalBytes);
          }
          double progress = (bytesDownloaded / totalBytes) * 100;
          print("Downloading video/audio... ${progress.toStringAsFixed(2)}%");
        }
        await audioSink.flush();
        await audioSink.close();

        print("Filepath: $filePath");

        final mergedFile = File(filePath);
        print("Merging...");
        if(onProgress != null) onProgress(1.5);
        try{
          await FFmpegKit.execute(
              '-i "${tempVideoFile.path}" -i "${tempAudioFile.path}" -c:v copy -c:a aac -strict experimental "${mergedFile.path}"'
          );
          print("Merge complete");
          if(onProgress != null) onProgress(2);
        }
        catch (e) {
          print("Merge Error $e");
        }

        if (await tempVideoFile.exists()) {
          await tempVideoFile.delete();
        }
        if (await tempAudioFile.exists()) {
          await tempAudioFile.delete();
        }
      }

      final metadata = VideoMetadata()
        ..title = video.title
        ..url = videoUrl
        ..filepath = filePath
        ..durationInSeconds = duration
        ..thumbnailUrl = thumbnailUrl
        ..author = author;

      await isarService.saveMetadata(metadata);
      yt.close();
    }
    catch (e) {
      if(onProgress != null) onProgress(-1);
      print("Download Unsuccessful, $e");
    }
  }


  void dispose() {
    yt.close();
  }
}
class MergedStream {
  final VideoOnlyStreamInfo video;
  final AudioOnlyStreamInfo audio;
  final String? qualityLabel;

  MergedStream({required this.video, required this.audio, this.qualityLabel});
}

