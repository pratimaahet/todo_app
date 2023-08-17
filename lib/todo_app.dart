import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo_app/create_todo.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/edit_todo.dart';
import 'package:todo_app/todo_service.dart';

class TodoApp extends StatefulWidget {
  const TodoApp({super.key});

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  bool isLoading = true;
  List items = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Todo App')),
      body: Visibility(
        visible: isLoading,
        child: Center(child: CircularProgressIndicator()),
        replacement: RefreshIndicator(
          onRefresh: fetchData,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(
                child: Text(
              "No Todo items",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
            )),
            child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index] as Map;
                  final id = item['_id'] as String;
                  return Card(
                    margin: EdgeInsets.all(10),
                    child: ListTile(
                      leading: CircleAvatar(child: Text('${index + 1}')),
                      title: Text(item['title']),
                      subtitle: Text(item['description']),
                      trailing: PopupMenuButton(onSelected: (value) {
                        if (value == 'edit') {
                          navigateToEditPage(item);
                        } else if (value == 'delete') {
                          deleteById(id);
                          fetchData();
                        }
                      }, itemBuilder: (context) {
                        return [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Text(
                              'Edit',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text(
                              'delete',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ];
                      }),
                    ),
                  );
                }),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CreateTodo()));
        },
        label: Text("Add Todo"),
      ),
    );
  }

  void navigateToEditPage(Map item) {
    final route = MaterialPageRoute(
      builder: (context) => EditTodo(todo: item),
    );
    Navigator.push(context, route);
  }

  Future<void> deleteById(String id) async {
    final isSuccess = await TodoService.deleteById(id);
    if (isSuccess) {
      final filtered = items
          .where(
            (element) => element['_id'] != id,
          )
          .toList();
      setState(() {
        items = filtered;
      });
      print('success');
    }
  }

  Future<void> fetchData() async {
    final result = await TodoService.fetchData();
    if (result != null) {
      setState(() {
        items = result;
      });
    } else {
      // show 
      
    }
    setState(() {
      isLoading = false;
    });
  }
}
