import 'package:after_ets/models/author.dart';
import 'package:after_ets/services/db_service.dart';
import 'package:after_ets/widgets/stories/story-author-edit.dart';
import 'package:flutter/material.dart';
import 'package:after_ets/models/story.dart';

class StoryDetailPage extends StatelessWidget {
  final Story story;
  final Function(int, List<Author>) addAuthorToStory;
  const StoryDetailPage({
    super.key,
    required this.story,
    required this.addAuthorToStory,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar with back arrow
      appBar: AppBar(
        backgroundColor: Colors.yellow[300],
        title: Text(
          story.title,
          maxLines: 1, // Limit the text to 2 lines
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.blue,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),
      body: SingleChildScrollView(
        // Makes the content scrollable
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 2 / 5,
              width: double.infinity,
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
                    decoration: BoxDecoration(color: Colors.blue[50]),
                    child: Icon(Icons.image, size: 30, color: Colors.blue),
                  );
                },
              ),
            ),

            // Padding around the text content
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Using StreamBuilder to listen to authors stream
                      StreamBuilder<List<Author>>(
                        stream: DB.instance.getAuthorsStreambyStoryId(
                          story.id,
                        ), // Assuming you have a stream method to get authors
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator(); // While loading
                          } else if (snapshot.hasError) {
                            return Text('Error loading authors');
                          } else if (snapshot.hasData) {
                            final authors = snapshot.data!;
                            if (authors.isNotEmpty) {
                              return Text(
                                authors.map((author) => author.name).join(', '),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Colors.blue,
                                ),
                              );
                            } else {
                              return Text(
                                'No authors available',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blueGrey,
                                ),
                              );
                            }
                          }
                          return SizedBox(); // If no data is received
                        },
                      ),

                      AddRemoveAuthorsForm(
                        story: story,
                        addAuthorToStory: addAuthorToStory,
                      ),
                    ],
                  ),
                  Text(
                    story.story,
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
