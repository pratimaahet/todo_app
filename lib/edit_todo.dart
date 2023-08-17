import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/todo_app.dart';

class EditTodo extends StatefulWidget {
  final Map todo;
  const EditTodo({super.key, required this.todo});

  @override
  State<EditTodo> createState() => _EditTodoState();
}

class _EditTodoState extends State<EditTodo> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  final String id = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final title = widget.todo['title'];
    final description = widget.todo['description'];
    titleController.text = title;
    descController.text = description;
    // final id = widget.todo['_id'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Todo")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              hintText: 'Title',
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: descController,
            decoration: InputDecoration(
              hintText: 'Description',
            ),
            minLines: 5,
            maxLines: 8,
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            style: ButtonStyle(),
            onPressed: () {
              UpdateData();
            },
            child: Text('Submit'),
          ),
        ]),
      ),
    );
  }

  Future<void> UpdateData() async {
    // Get Data from form
    final todo = widget.todo;
    final id = todo['_id'];
    final title = titleController.text;
    final description = descController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };

// submit updated data to server
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.put(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );

    //show sucess and failed message
    if (response.statusCode == 200) {
      showSuccessMessage();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => TodoApp()));
    } else {
      showFailedMessage();
    }
  }

  void showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Todo Updated Successfully',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
    );
  }

  void showFailedMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Todo Failed',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
}
