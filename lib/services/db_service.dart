import 'package:after_ets/models/author.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:after_ets/models/story.dart';

class DB {
  static final DB _instance = DB();
  static DB get instance => _instance;

  late Future<Isar> db;

  DB() {
    db = openIsar();
  }

  Future<Isar> openIsar() async {
    final dir = await getApplicationDocumentsDirectory();

    return await Isar.open(
      [StorySchema, AuthorSchema], // Add your schemas here
      directory: dir.path,
      inspector: true,
    );
  }

  Stream<List<Story>> getStorysStream() async* {
    final isar = await db;
    if (isar.storys.countSync() == 0) {
      clearAllStorys();
    }
    yield* isar.storys.where().watch(fireImmediately: true);
  }

  Future<void> addStory(String title, String desc, String imageUrl) async {
    final isar = await db;
    Story story = Story(title: title, story: desc, imageUrl: imageUrl);
    await isar.writeTxn(() => isar.storys.put(story));
  }

  Future<void> deleteStory(int id) async {
    final isar = await db;
    await isar.writeTxn(() => isar.storys.delete(id));
  }

  Future<void> updateStory(
    int id,
    String title,
    String desc,
    String imageUrl,
  ) async {
    final isar = await db;
    Story story = Story(id: id, title: title, story: desc, imageUrl: imageUrl);
    await isar.writeTxn(() => isar.storys.put(story));
  }

  Stream<List<Author>> getAuthorsStream() async* {
    final isar = await db;
    if (isar.authors.countSync() == 0) {
      clearAllAuthors();
    }
    yield* isar.authors.where().watch(fireImmediately: true);
  }

  Future<void> addAuthor(String name, String imageUrl) async {
    final isar = await db;
    Author author = Author(name: name, imageUrl: imageUrl);
    await isar.writeTxn(() => isar.authors.put(author));
  }

  Future<void> deleteAuthor(int id) async {
    final isar = await db;
    await isar.writeTxn(() => isar.authors.delete(id));
  }

  Future<void> updateAuthor(int id, String name, String imageUrl) async {
    final isar = await db;
    Author author = Author(id: id, name: name, imageUrl: imageUrl);
    await isar.writeTxn(() => isar.authors.put(author));
  }

  Future<void> clearAllAuthors() async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.authors.clear(); // Clear all authors from the database
    });
  }

  Future<void> clearAllStorys() async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.storys.clear(); // Clear all storys from the database
    });
  }

  Future<void> addAuthorToStory( int storyId, List<Author> selectedAuthors) async {
    final isar = await db;

    Story? story = await isar.storys.get(storyId);
    if (story == null) {
      print('Story with id $storyId not found');
      throw Exception('Story with id $storyId not found');
    }

    await isar.writeTxn(() async {
      await story.authors.reset();
    });

    story.authors.addAll(selectedAuthors); // Add new authors

    await isar.writeTxn(() async {
      await story.authors.save();
    });
  }

  Future<List<Author>> getAuthorsByStoryId(int storyId) async {
    final isar = await db;
    Story? story = await isar.storys.get(storyId);
    if (story == null) {
      throw Exception('Story with id $storyId not found');
    }

    await story.authors.load();
    return story.authors.toList();
  }

  Future<List<Author>> getAuthors() async {
    final isar = await db;
    return await isar.authors.where().findAll();
  }

  Stream<List<Author>> getAuthorsStreambyStoryId(int storyId) async* {
    final isar = await db;

    while (true) {
      Story? story = await isar.storys.get(storyId);

      if (story == null) {
        yield []; // If no story found, yield an empty list
      } else {
        yield story.authors.toList(); // Convert IsarLinks to a List<Author>
      }

      await Future.delayed(Duration(seconds: 1)); // Wait before checking again
    }
  }
}
