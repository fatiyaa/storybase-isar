import 'package:after_ets/models/author.dart';
import 'package:isar/isar.dart';

part 'story.g.dart';

@Collection()
class Story {
  Id id;
  final String title;
  final String story;
  final String imageUrl;

  @Backlink(to: 'stories')
  final authors = IsarLinks<Author>();

  Story({
    this.id = Isar.autoIncrement,
    required this.title,
    required this.story,
    required this.imageUrl,
  });
}
