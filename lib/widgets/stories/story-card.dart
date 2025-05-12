import 'package:after_ets/models/author.dart';
import 'package:after_ets/pages/story-detail-page.dart';
import 'package:after_ets/services/db_service.dart';
import 'package:after_ets/widgets/stories/story-delete.dart';
import 'package:flutter/material.dart';
import 'package:after_ets/models/story.dart';
import 'package:after_ets/widgets/stories/story-edit-form.dart';

class StoryCard extends StatelessWidget {
  final Story story;
  final Function(int) deleteStory;
  final Function(String, String, String) editStory;

  const StoryCard({
    super.key,
    required this.story,
    required this.deleteStory,
    required this.editStory,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to StoryDetailPage when the card is tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => StoryDetailPage(
                  story: story,
                  addAuthorToStory:
                      (int storyId, List<Author> authors) =>
                          DB.instance.addAuthorToStory(storyId, authors),
                ), // Pass the story to the detail page
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
        // margin: EdgeInsets.only(bottom: 24),

        // decoration: BoxDecoration(
        //   // border: Border.all(color: Colors.black),
        //   borderRadius: BorderRadius.circular(8.0),
        //   boxShadow: [
        //     BoxShadow(
        //       color: Colors.yellow.shade200.withAlpha(96),
        //       blurRadius: 12,
        //       offset: Offset(0, 5),
        //     ),
        //   ],
        //   color: Colors.yellow[50],
        // ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(
                25.0,
              ), // Apply border radius to the image and icon
              child: Image.network(
                story.imageUrl ??
                    '', // If imageUrl is null, it will fallback to empty string
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (
                  BuildContext context,
                  Object error,
                  StackTrace? stackTrace,
                ) {
                  // Return a rectangular icon when the image is not available
                  return Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.blue[50], // Background color of the icon
                      borderRadius: BorderRadius.circular(
                        25.0,
                      ), // Apply rounded corners to the icon container
                    ),
                    child: Icon(
                      Icons
                          .image, // Display an image icon when the image fails to load
                      size: 30, // Set the icon size to fit within the rectangle
                      color:
                          Colors.blue, // You can change the color of the icon
                    ),
                  );
                },
              ),
            ),

            SizedBox(width: 10),
            // Wrap the story text inside an Expanded widget to prevent overflow
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    story.title,
                    maxLines: 1, // Limit the text to 2 lines
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  // Make sure the text does not overflow and truncates with ellipsis
                  Text(
                    story.story,
                    maxLines: 1, // Limit the text to 2 lines
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
            ),
            // StoryEditForm and DeleteConfirmationDialog should be placed outside Expanded
            StoryEditForm(editStory: editStory, oldStory: story),
            DeleteConfirmationDialog(story: story, onDelete: deleteStory),
          ],
        ),
      ),
    );
  }
}
