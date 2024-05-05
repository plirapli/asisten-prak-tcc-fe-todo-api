import 'package:flutter/material.dart';
import 'package:prak_tcc_fe_mobile/model/todo.dart';
import 'package:prak_tcc_fe_mobile/util/todo.dart';
import 'package:prak_tcc_fe_mobile/view/add.dart';
import 'package:prak_tcc_fe_mobile/view/edit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(children: [
            _heading(context),
            _buildDetailUser(),
            const SizedBox(height: 20)
          ]),
        ),
        floatingActionButton: Container(
          padding: const EdgeInsets.all(10),
          child: FloatingActionButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddPage()),
              );

              if (result != null) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text(result)));
                setState(() {});
                _future = TodoApi.getTodo();
              }
            },
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              side: BorderSide(
                width: 2.5,
                strokeAlign: BorderSide.strokeAlignCenter,
              ),
            ),
            elevation: 3,
            child: const Icon(Icons.add, size: 32),
          ),
        ),
      ),
    );
  }

  Future? _future;

  @override
  void initState() {
    super.initState();
    _future = TodoApi.getTodo();
  }

  String keyword = "";
  List<TodoItem> filteredTodo = [];
  List<TodoItem> todoList = [];

  void _search(String val) {
    keyword = val;
    filteredTodo = todoList
        .where((item) =>
            (item.title!.toLowerCase()).contains(val.toLowerCase()) ||
            (item.isi!.toLowerCase()).contains(val.toLowerCase()))
        .toList();
    setState(() {});
  }

  Widget _heading(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 16),
        color: const Color.fromARGB(255, 246, 246, 246),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "To do list 📝",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            _searchBar(context)
          ],
        ));
  }

  Widget _searchBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: TextFormField(
        enabled: true,
        onChanged: (value) => _search(value),
        decoration: const InputDecoration(
          hintText: 'Search todo',
          prefixIcon: Icon(Icons.search, color: Colors.black54),
          contentPadding: EdgeInsets.all(12),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1.75,
              color: Colors.black26,
              strokeAlign: BorderSide.strokeAlignCenter,
            ),
            borderRadius: BorderRadius.zero,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1.75,
              color: Colors.black,
              strokeAlign: BorderSide.strokeAlignCenter,
            ),
            borderRadius: BorderRadius.zero,
          ),
        ),
      ),
    );
  }

  Widget _buildDetailUser() {
    return Expanded(
      child: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Error");
          } else if (snapshot.hasData) {
            Todos todoModel = Todos.fromJson(snapshot.data);
            // Memasukkan list todo ke dalam todoList biar bisa di-search
            todoList = [...?todoModel.data];
            return _buildSuccess(context, todoModel);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildSuccess(BuildContext context, Todos data) {
    return (keyword != "" && filteredTodo.isEmpty)
        ? Container(
            margin: const EdgeInsets.only(top: 12),
            child: Text.rich(
              TextSpan(
                style: const TextStyle(fontSize: 16),
                children: [
                  const TextSpan(text: "Can't find "),
                  TextSpan(
                    text: keyword,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(text: " on menu."),
                ],
              ),
            ),
          )
        : ListView.builder(
            itemCount: (keyword != "") ? filteredTodo.length : todoList.length,
            itemBuilder: (BuildContext context, int index) {
              return _buildItemUser(
                context,
                (keyword != "") ? filteredTodo[index] : todoList[index],
              );
            },
          );
  }

  Widget _buildItemUser(BuildContext context, TodoItem todo) {
    return Container(
      margin: const EdgeInsets.fromLTRB(1, 16, 1, 0),
      child: Column(
        children: [
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(padding: const EdgeInsets.all(14)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  todo.title!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  todo.isi!,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditPage(id: todo.id!),
                      ),
                    );

                    if (result != null) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(SnackBar(content: Text(result)));
                      setState(() {});
                      _future = TodoApi.getTodo();
                    }
                  },
                  child: const Text("Update"),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () async {
                    final bool? shouldRefresh = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Delete todo?"),
                          content: Text("Do you want to delete ${todo.title}?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text("No"),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.red,
                              ),
                              onPressed: () {
                                TodoApi.deleteTodo((todo.id).toString()).then(
                                  (value) => Navigator.pop(context, true),
                                );
                              },
                              child: const Text("Yes"),
                            ),
                          ],
                          backgroundColor: Colors.white,
                          surfaceTintColor: Colors.transparent,
                          shape: const RoundedRectangleBorder(
                            side: BorderSide(
                              width: 2.5,
                              strokeAlign: BorderSide.strokeAlignCenter,
                            ),
                          ),
                        );
                      },
                    );

                    if (shouldRefresh!) {
                      setState(() {});
                      _future = TodoApi.getTodo();
                    }
                  },
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.red.shade50,
                      foregroundColor: Colors.red),
                  child: const Text("Delete"),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
