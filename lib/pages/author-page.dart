import 'package:flutter/material.dart';
import 'package:after_ets/services/db_service.dart';
import 'package:after_ets/widgets/authors/author-add-form.dart';
import 'package:after_ets/widgets/authors/author-card.dart';
import 'package:after_ets/models/author.dart';

class AuthorPage extends StatelessWidget {
  AuthorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            'https://wallpapers.com/images/high/aesthetic-white-background-dlajdv5qxtbwqbs3.webp',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 64,
          backgroundColor: Colors.yellow[300],
          title: const Text(
            'StoryBase Authors',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 32,
              color: Colors.blue,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.blue),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(children: [Authors(), SizedBox(height: 20)]),
        ),
        floatingActionButton: AuthorAddForm(
          addAuthor: (String name, String imageUrl) {
            DB.instance.addAuthor(name, imageUrl);
          },
        ),
      ),
    );
  }
}

class Authors extends StatelessWidget {
  Authors({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Author>>(
      stream: DB.instance.getAuthorsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No author found'));
        } else {
          List<Author> authors = snapshot.data!;

          return ListView.separated(
            // padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            shrinkWrap: true,
            itemCount: authors.length,
            itemBuilder: (context, index) {
              return AuthorCard(
                author: authors[index],
                deleteAuthor:
                    (int id) => DB.instance.deleteAuthor(authors[index].id),
                editAuthor:
                    (String name, String url) =>
                        DB.instance.updateAuthor(authors[index].id, name, url),
              );
            },
            separatorBuilder: (context, index) {
              // Divider between each AuthorCard
              return Divider(
                color: Colors.grey, // Color of the divider
                thickness: 1, // Thickness of the divider line
              );
            },
          );
        }
      },
    );
  }
}
