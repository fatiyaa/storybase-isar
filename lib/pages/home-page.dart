import 'package:after_ets/pages/author-page.dart';
import 'package:flutter/material.dart';
import 'package:after_ets/services/db_service.dart';
import 'package:after_ets/widgets/stories/story-add-form.dart';
import 'package:after_ets/widgets/stories/story-card.dart';
import 'package:after_ets/models/story.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Set the background image to fill the entire screen
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            'https://wallpapers.com/images/high/aesthetic-white-background-dlajdv5qxtbwqbs3.webp',
          ), // Background image from assets
          fit: BoxFit.cover, // Ensures the image covers the entire screen
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.yellow[300],
          title: const Text(
            'StoryBase',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 32,
              color: Colors.blue,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(children: [Storys(), SizedBox(height: 20)]),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () => _showAddStoryDialog(context),
              child: Icon(Icons.add),
              backgroundColor: Colors.yellow[300],
            ),
            SizedBox(height: 10), // Space between the buttons
            FloatingActionButton(
              onPressed: () {
                // Navigate to AuthorPage when the people icon is clicked
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AuthorPage(),
                  ), // Navigate to AuthorPage
                );
              },
              child: Icon(Icons.person),
              backgroundColor: Colors.yellow[300],
            ),
          ],
        ),
      ),
    );
  }

  // Show the Add Story dialog
  void _showAddStoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => StoryAddForm(
            addStory: (String title, String story, String imageUrl) {
              DB.instance.addStory(
                title,
                story,
                imageUrl,
              ); // Add story to the database
            },
          ),
    );
  }
}

class Storys extends StatelessWidget {
  Storys({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Story>>(
      stream: DB.instance.getStorysStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No stories found'));
        } else {
          List<Story> storys = snapshot.data!;

          return ListView.separated(
            shrinkWrap: true,
            itemCount: storys.length,
            itemBuilder: (context, index) {
              return StoryCard(
                story: storys[index],
                deleteStory:
                    (int id) => DB.instance.deleteStory(storys[index].id),
                editStory:
                    (String title, String desc, String url) => DB.instance
                        .updateStory(storys[index].id, title, desc, url),
              );
            },
            separatorBuilder: (context, index) {
              return Divider(color: Colors.grey, thickness: 1);
            },
          );
        }
      },
    );
  }
}
