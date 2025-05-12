import 'package:after_ets/widgets/authors/author-delete.dart';
import 'package:flutter/material.dart';
import 'package:after_ets/models/author.dart';
import 'package:after_ets/widgets/authors/author-edit-form.dart';

class AuthorCard extends StatelessWidget {
  final Author author;
  final Function(int) deleteAuthor;
  final Function(String, String) editAuthor;

  const AuthorCard({
    super.key,
    required this.author,
    required this.deleteAuthor,
    required this.editAuthor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(
              25.0,
            ), // Apply border radius to the image and icon
            child: Image.network(
              author.imageUrl ??
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
                        .people, // Display an image icon when the image fails to load
                    size: 30, // Set the icon size to fit within the rectangle
                    color: Colors.blue, // You can change the color of the icon
                  ),
                );
              },
            ),
          ),
          SizedBox(width: 10),
          // Wrap the author text inside an Expanded widget to prevent overflow
          Expanded(
            child: Text(
              author.name,
              maxLines: 1, // Limit the text to 2 lines
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          // AuthorEditForm and DeleteConfirmationDialog should be placed outside Expanded
          AuthorEditForm(editAuthor: editAuthor, oldAuthor: author),
          AuthorDeleteConfirmationDialog(
            author: author,
            onDelete: deleteAuthor,
          ),
        ],
      ),
    );
  }
}
