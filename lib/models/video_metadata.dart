import 'package:isar/isar.dart';

part 'video_metadata.g.dart';

@collection
class VideoMetadata {
  Id id = Isar.autoIncrement;

  String title = '';
  String url = '';
  String filepath = '';
  int durationInSeconds = 0;
  String thumbnailUrl = '';
  String author = '';
}