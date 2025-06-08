import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yt_save/models/video_metadata.dart';
import 'dart:io';


class IsarService {
  late Future<Isar> db ;

  IsarService() {
    db = openIsarDB();
  }

  Future<Isar> openIsarDB() async {
    final existing = Isar.getInstance();
    if (existing != null) return existing;

    final dir = await getApplicationDocumentsDirectory();
    return await Isar.open([VideoMetadataSchema], directory: dir.path);
  }

  Future<void> saveMetadata(VideoMetadata data) async {
    final isar = await db;
    await isar.writeTxn(() => isar.videoMetadatas.put(data));
  }

  Future<List<VideoMetadata>> getAllVideos() async {
    print("isar service");
    try{
      final isar = await db;
      return await isar.videoMetadatas.where().findAll();
    }
    catch (e, stacktrace) {
      print("Error in getAllVideos: $e");
      print(stacktrace);
      rethrow;
    }
  }

  Future<void> deleteVideoWithFile(int id) async {
    final isar = await db;

    await isar.writeTxn(() async {
      final video = await isar.videoMetadatas.get(id);
      if (video == null) {
        print("Video with id $id not found in DB.");
        return;
      }

      final filePath = video.filepath;

      final file = File(filePath);
      if (await file.exists()) {
        try {
          await file.delete();
          print("Deleted video file at $filePath");
        } catch (e) {
          print("Failed to delete file: $e");
        }
      } else {
        print("No file found at $filePath");
      }

      final deleted = await isar.videoMetadatas.delete(id);
      if (!deleted) {
        print("Failed to delete metadata with id $id");
      }
    });
  }
}