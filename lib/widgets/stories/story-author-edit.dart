import 'package:flutter/material.dart';
import 'package:after_ets/models/author.dart';
import 'package:after_ets/models/story.dart';
import 'package:after_ets/services/db_service.dart';
import 'package:isar/isar.dart';

class AddRemoveAuthorsForm extends StatefulWidget {
  final Story story;
  final Function(int, List<Author>) addAuthorToStory;

  const AddRemoveAuthorsForm({
    super.key,
    required this.story,
    required this.addAuthorToStory,
  });

  @override
  AddRemoveAuthorsFormState createState() => AddRemoveAuthorsFormState();
}

class AddRemoveAuthorsFormState extends State<AddRemoveAuthorsForm> {
  List<Author> authorsList = [];
  List<Author> selectedAuthors = [];

  @override
  void initState() {
    super.initState();
    _loadAuthors();
  }

  // Load all available authors and pre-select authors already linked to the story
  void _loadAuthors() async {
    // Log untuk memastikan data yang diambil dari database
    final allAuthors = await DB.instance.getAuthors();
    final storyAuthors = await DB.instance.getAuthorsByStoryId(widget.story.id);

    allAuthors.removeWhere(
      (author) => storyAuthors.any((e) => e.id == author.id),
    );

    setState(() {
      authorsList = allAuthors;
      selectedAuthors = storyAuthors;
    });

  }

  void _addAuthor(Author author) {
    setState(() {
      selectedAuthors.add(author);
      authorsList.removeWhere((a) => a.id == author.id);
    });
  }

  void _removeAuthor(Author author) {
    setState(() {
      selectedAuthors.removeWhere((a) => a.id == author.id);
      authorsList.add(author);
    });
  }

  // Show dialog to manage authors
  void _showAddAuthorDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Manage Authors for ${widget.story.title}'),
          content: StatefulBuilder(
            builder: (context, setDialogState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Dropdown to select authors
                    DropdownButton<Author>(
                      hint: Text("Select Author"),
                      isExpanded: true,
                      value: null, // Tidak mengikat value
                      onChanged: (Author? author) {
                        if (author != null) {
                          _addAuthor(author);
                          setDialogState(
                            () {},
                          ); // Memperbarui dialog UI setelah memilih author
                        }
                      },
                      items:
                          authorsList.map<DropdownMenuItem<Author>>((author) {
                            return DropdownMenuItem<Author>(
                              value: author,
                              child: Text(author.name),
                            );
                          }).toList(),
                    ),
                    SizedBox(height: 10),

                    // Display the selected authors as Chips with delete icon
                    Wrap(
                      children:
                          selectedAuthors
                              .map(
                                (author) => Chip(
                                  label: Text(author.name),
                                  deleteIcon: Icon(Icons.close),
                                  onDeleted: () {
                                    _removeAuthor(author);
                                    setDialogState(
                                      () {},
                                    ); // Memperbarui UI setelah menghapus author
                                  },
                                ),
                              )
                              .toList(),
                    ),
                    SizedBox(height: 20),

                    // Save button
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              widget.addAuthorToStory(
                                widget.story.id,
                                selectedAuthors,
                              );
                              Navigator.pop(
                                context,
                              ); // Tutup dialog setelah simpan
                            },
                            child: Text('Save Authors'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: _showAddAuthorDialog, icon: Icon(Icons.edit));
  }
}
