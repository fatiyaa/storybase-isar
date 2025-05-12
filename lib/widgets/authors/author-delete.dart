import 'package:after_ets/models/author.dart';
import 'package:flutter/material.dart';

class AuthorDeleteConfirmationDialog extends StatelessWidget {
  final Author author;
  final Function(int) onDelete;

  const AuthorDeleteConfirmationDialog({
    super.key,
    required this.author,
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
              title: Text('Delete the Author?'),
              content: Text('Are you sure to delete ${author.name} author?'),
              actions: [
                // "Yes" button
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    onDelete(author.id); // Trigger onDelete action
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
