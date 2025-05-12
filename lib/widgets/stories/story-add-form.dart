import 'package:flutter/material.dart';

class StoryAddForm extends StatefulWidget {
  final Function(String, String, String) addStory;
  const StoryAddForm({super.key, required this.addStory});

  @override
  StoryAddFormState createState() => StoryAddFormState();
}

class StoryAddFormState extends State<StoryAddForm> {
  String title = '';
  String story = '';
  String imageUrl = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Your Story'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            onChanged: (value) => setState(() => title = value),
            decoration: InputDecoration(labelText: 'Title'),
          ),
          TextField(
            onChanged: (value) => setState(() => story = value),
            decoration: InputDecoration(labelText: 'Your Story'),
            maxLines: 5, // Initially show 5 lines
            keyboardType: TextInputType.multiline,
            style: TextStyle(fontSize: 16),
            scrollPadding: EdgeInsets.all(20),
          ),
          TextField(
            onChanged: (value) => setState(() => imageUrl = value),
            decoration: InputDecoration(labelText: 'Image URL'),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.addStory(title, story, imageUrl);
                    Navigator.pop(context); // Close the dialog
                  },
                  child: Text('Add Story'),
                ),
              ),
              SizedBox(width: 10),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
