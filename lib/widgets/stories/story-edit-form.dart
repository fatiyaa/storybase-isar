import 'package:flutter/material.dart';

import '../../models/story.dart';

class StoryEditForm extends StatefulWidget {
  final Story oldStory;
  final Function(String, String, String) editStory;
  const StoryEditForm({
    super.key,
    required this.editStory,
    required this.oldStory,
  });

  @override
  StoryEditFormState createState() => StoryEditFormState();
}

class StoryEditFormState extends State<StoryEditForm> {
  late TextEditingController titleController;
  late TextEditingController storyController;
  late TextEditingController imageUrlController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.oldStory.title);
    storyController = TextEditingController(text: widget.oldStory.story);
    imageUrlController = TextEditingController(text: widget.oldStory.imageUrl);
  }

  _showEditStoryDialog() {
    setState(() {
      titleController.text = widget.oldStory.title;
      storyController.text = widget.oldStory.story;
      imageUrlController.text = widget.oldStory.imageUrl;
    });
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Your Story'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              // TextField(
              //   controller: storyController,
              //   decoration: InputDecoration(labelText: 'Your Story'),
              // ),
              TextField(
                controller: storyController,
                decoration: InputDecoration(labelText: 'Your Story'),
                maxLines: 5, // Initially show 5 lines
                keyboardType: TextInputType.multiline,
                style: TextStyle(fontSize: 16),
                scrollPadding: EdgeInsets.all(20),
              ),
              TextField(
                controller: imageUrlController,
                decoration: InputDecoration(labelText: 'Image URL'),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        widget.editStory(
                          titleController.text,
                          storyController.text,
                          imageUrlController.text,
                        );
                        Navigator.pop(context);
                      },
                      child: Text('Edit Story'),
                    ),
                  ),
                  SizedBox(width: 10),
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('cancel'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: _showEditStoryDialog, icon: Icon(Icons.edit));
  }
}
