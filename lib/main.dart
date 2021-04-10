// Copyright 2020, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'src/app.dart';

class Album {
  final int userId;
  final int id;
  final String title;

  Album({@required this.userId, @required this.id, @required this.title});

  factory Album.fromJson(dynamic json) {
    return Album(
      userId: json['userId'] as int,
      id: json['id'] as int,
      title: json['title'] as String,
    );
  }
}

void main() {
  // runApp(DashboardApp.mock());
  runApp(MyApp());
}

// #docregion MyApp
class MyApp extends StatelessWidget {
  // #docregion build
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      home: RandomWords(),
      theme: ThemeData(
        primaryColor: Colors.black,
      ),
    );
  }
// #enddocregion build
}
// #enddocregion MyApp

Future getProjectDetails() async {
  List<Album> myModels;

  var response =
      await http.get(Uri.https('jsonplaceholder.typicode.com', 'albums'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.

    myModels=(json.decode(response.body) as List).map((dynamic i) => Album.fromJson(i)).toList();
    // return Album.fromJson(jsonDecode(response.body));

    return myModels;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

// #docregion RWS-var
class _RandomWordsState extends State<RandomWords> {
  final _saved = <String>[];
  final _biggerFont = TextStyle(fontSize: 18.0);

  // #docregion _buildSuggestions
  Widget _buildSuggestions() {

    return FutureBuilder<dynamic>(
      future: getProjectDetails(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            padding: EdgeInsets.all(16.0),
            itemCount: 100,
            itemBuilder: (context, i) {
              dynamic project = snapshot.data[i];
              // return Column(
              //   children: <Widget>[
              //     ListTile(
              //       leading: Icon(Icons.map),
              //       title: Text(project.title as String),
              //     ),
              //   ],
              // );
              return _buildRow(project.title as String);
            },
          );
        }
        return Container();
      },
    );

  }


  // #docregion _buildRow
  Widget _buildRow(String pair) {
    final alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        // pair.asPascalCase,
        pair,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  // #enddocregion _buildRow

  // #docregion RWS-build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: [
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  void _pushSaved() {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (BuildContext context) {
      final tiles = _saved.map(
        (String pair) {
          return ListTile(
            title: Text(
              // pair.asPascalCase,
              pair,
              style: _biggerFont,
            ),
          );
        },
      );
      final divided = ListTile.divideTiles(
        context: context,
        tiles: tiles,
      ).toList();

      return Scaffold(
        appBar: AppBar(
          title: Text('Saved Suggestions'),
        ),
        body: ListView(children: divided),
      );
    }));
  }
// #enddocregion RWS-build
// #docregion RWS-var
}
// #enddocregion RWS-var

class RandomWords extends StatefulWidget {
  @override
  State<RandomWords> createState() => _RandomWordsState();
}
