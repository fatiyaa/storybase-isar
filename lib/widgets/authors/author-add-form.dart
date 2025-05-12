import 'package:flutter/material.dart';

class AuthorAddForm extends StatefulWidget {
  final Function(String, String) addAuthor;
  const AuthorAddForm({super.key, required this.addAuthor});

  @override
  AuthorAddFormState createState() => AuthorAddFormState();
}

class AuthorAddFormState extends State<AuthorAddForm> {
  String name = '';
  String imageUrl = '';

  _showAddAuthorDialog() {
    setState(() {
      name = '';
      imageUrl = '';
    });
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('New Author'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) => setState(() => name = value),
                decoration: InputDecoration(labelText: 'Author Name'),
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
                        widget.addAuthor(name, imageUrl);
                        Navigator.pop(context);
                      },
                      child: Text('Add Author'),
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
    return FloatingActionButton(
      backgroundColor: Colors.yellow[300],
      onPressed: _showAddAuthorDialog,
      child: Icon(Icons.add),
    );
  }
}
