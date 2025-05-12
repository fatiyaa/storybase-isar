import 'package:after_ets/models/story.dart';
import 'package:isar/isar.dart';

part 'author.g.dart';

@Collection()
class Author {
  Id id;
  final String name;
  final String imageUrl;
  final stories = IsarLinks<Story>();

  Author({this.id = Isar.autoIncrement, required this.name, required this.imageUrl});
}
