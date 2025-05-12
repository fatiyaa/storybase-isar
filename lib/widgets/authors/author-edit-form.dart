import 'package:flutter/material.dart';

import '../../models/author.dart';

class AuthorEditForm extends StatefulWidget {
  final Author oldAuthor;
  final Function(String, String) editAuthor;
  const AuthorEditForm({
    super.key,
    required this.editAuthor,
    required this.oldAuthor,
  });

  @override
  AuthorEditFormState createState() => AuthorEditFormState();
}

class AuthorEditFormState extends State<AuthorEditForm> {
  late TextEditingController nameController;
  late TextEditingController imageUrlController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.oldAuthor.name);
    imageUrlController = TextEditingController(text: widget.oldAuthor.imageUrl);
  }

  _showEditAuthorDialog() {
    setState(() {
      nameController.text = widget.oldAuthor.name;
      imageUrlController.text = widget.oldAuthor.imageUrl;
    });
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Author Profile'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Author Name'),
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
                        widget.editAuthor(
                          nameController.text,
                          imageUrlController.text,
                        );
                        Navigator.pop(context);
                      },
                      child: Text('Edit Author'),
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
    return IconButton(onPressed: _showEditAuthorDialog, icon: Icon(Icons.edit));
  }
}
