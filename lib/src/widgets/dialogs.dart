// Copyright 2020, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:playground/src/api/api.dart';
import 'package:playground/src/widgets/category_forms.dart';

import '../app.dart';
import 'edit_entry.dart';

class NewCategoryDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('New Category'),
      children: <Widget>[
        NewCategoryForm(),
      ],
    );
  }
}

class EditCategoryDialog extends StatelessWidget {
  final Category category;

  EditCategoryDialog({
    @required this.category,
  });

  @override
  Widget build(BuildContext context) {
    var api = Provider.of<AppState>(context).api;

    return SimpleDialog(
      title: Text('Edit Category'),
      children: [
        EditCategoryForm(
          category: category,
          onDone: (shouldUpdate) {
            if (shouldUpdate) {
              api.categories.update(category, category.id);
            }
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class NewEntryDialog extends StatefulWidget {
  @override
  _NewEntryDialogState createState() => _NewEntryDialogState();
}

class _NewEntryDialogState extends State<NewEntryDialog> {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('New Entry'),
      children: [
        NewEntryForm(),
      ],
    );
  }
}

class EditEntryDialog extends StatelessWidget {
  final Category category;
  final Entry entry;

  EditEntryDialog({
    this.category,
    this.entry,
  });

  @override
  Widget build(BuildContext context) {
    var api = Provider.of<AppState>(context).api;

    return SimpleDialog(
      title: Text('Edit Entry'),
      children: [
        EditEntryForm(
          entry: entry,
          onDone: (shouldUpdate) {
            if (shouldUpdate) {
              api.entries.update(category.id, entry.id, entry);
            }
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
