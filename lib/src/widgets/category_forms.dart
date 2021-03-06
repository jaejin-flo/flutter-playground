// Copyright 2020, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:playground/src/api/api.dart';
import 'package:playground/src/app.dart';

class NewCategoryForm extends StatefulWidget {
  @override
  _NewCategoryFormState createState() => _NewCategoryFormState();
}

class _NewCategoryFormState extends State<NewCategoryForm> {
  Category _category = Category('');

  @override
  Widget build(BuildContext context) {
    var api = Provider.of<AppState>(context).api;
    return EditCategoryForm(
      category: _category,
      onDone: (shouldInsert) {
        if (shouldInsert) {
          api.categories.insert(_category);
        }
        Navigator.of(context).pop();
      },
    );
  }
}

class EditCategoryForm extends StatefulWidget {
  final Category category;
  final ValueChanged<bool> onDone;

  EditCategoryForm({
    @required this.category,
    @required this.onDone,
  });

  @override
  _EditCategoryFormState createState() => _EditCategoryFormState();
}

class _EditCategoryFormState extends State<EditCategoryForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              initialValue: widget.category.name,
              decoration: InputDecoration(
                labelText: 'Name',
              ),
              onChanged: (newValue) {
                widget.category.name = newValue;
              },
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: ElevatedButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    widget.onDone(false);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: ElevatedButton(
                  child: Text('OK'),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      widget.onDone(true);
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
