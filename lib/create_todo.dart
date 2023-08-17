import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/todo_app.dart';

class CreateTodo extends StatefulWidget {
  const CreateTodo({super.key});

  @override
  State<CreateTodo> createState() => _CreateTodoState();
}

class _CreateTodoState extends State<CreateTodo> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Todo")),
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
              submitData();
            },
            child: Text('Submit'),
          ),
        ]),
      ),
    );
  }

  Future<void> submitData() async {
    // Get Data from form
    final title = titleController.text;
    final description = descController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };

// submit data to server
    const url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );

    //show sucess and failed message
    if (response.statusCode == 201) {
      titleController.text = '';
      descController.text = '';
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
          'Todo Created Successfully',
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
