import 'package:after_ets/models/story.dart';
import 'package:flutter/material.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final Story story;
  final Function(int) onDelete;

  const DeleteConfirmationDialog({
    super.key,
    required this.story,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.delete),
      onPressed: () {
        // Show delete confirmation dialog when the trash icon is pressed
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Delete the Story?'),
              content: Text('Are you sure to delete ${story.title} story?'),
              actions: [
                // "Yes" button
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    onDelete(story.id); // Trigger onDelete action
                    Navigator.pop(context); // Close the dialog after deleting
                  },
                  child: Text('Ok'),
                ),
                // "No" button
              ],
            );
          },
        );
      },
    );
  }
}
