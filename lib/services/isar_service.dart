import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yt_save/models/video_metadata.dart';


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
}