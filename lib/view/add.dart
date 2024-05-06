import 'dart:async';
import 'package:flutter/material.dart';
import 'package:prak_tcc_fe_mobile/theme.dart';
import 'package:prak_tcc_fe_mobile/util/todo.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _isi = TextEditingController();
  bool isError = false;
  String msg = "";

  Future<void> _addHandler(BuildContext context) async {
    try {
      final Map<String, dynamic> response = await TodoApi.addTodo(
        _title.text,
        _isi.text,
      );
      final status = response["status"];
      msg = response["message"];

      if (status == "Success") {
        if (!context.mounted) return;
        Navigator.pop(context, msg);
      } else {
        throw Exception(msg);
      }
    } catch (e) {
      setState(() => isError = true);
      SnackBar snackBar = SnackBar(content: Text(e.toString()));
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(snackBar);
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _isi.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Add Todo")),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ListView(scrollDirection: Axis.vertical, children: [
            const SizedBox(height: 20),
            _heading(),
            _titleField(),
            _isiField(),
            _addButton(context),
            const SizedBox(height: 20)
          ]),
        ),
      ),
    );
  }

  Widget _heading() {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Add your todo",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text("What are you gonna do today?"),
        ],
      ),
    );
  }

  Widget _titleField() {
    return Container(
      margin: const EdgeInsets.fromLTRB(1, 12, 1, 0),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.75,
          strokeAlign: BorderSide.strokeAlignCenter,
        ),
        color: isError ? MyTheme.errorColor["bg"] : Colors.white,
      ),
      child: TextFormField(
        enabled: true,
        controller: _title,
        onChanged: (value) {
          setState(() {
            if (isError == true) isError = false;
          });
        },
        decoration: const InputDecoration(
          hintText: 'Enter a title',
          contentPadding: EdgeInsets.all(12),
          border: InputBorder.none,
        ),
        style: TextStyle(
          color: isError ? MyTheme.errorColor["normal"] : Colors.black,
        ),
      ),
    );
  }

  Widget _isiField() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 1),
      decoration: BoxDecoration(
          border: Border.all(
            width: 1.75,
            strokeAlign: BorderSide.strokeAlignCenter,
          ),
          color: isError ? MyTheme.errorColor["bg"] : Colors.white),
      child: TextFormField(
        enabled: true,
        controller: _isi,
        onChanged: (value) {
          setState(() {
            if (isError) isError = false;
          });
        },
        maxLines: 16,
        decoration: const InputDecoration(
          hintText: 'Enter a description',
          contentPadding: EdgeInsets.all(12),
          border: InputBorder.none,
        ),
        style: TextStyle(
          color: isError ? MyTheme.errorColor["normal"] : Colors.black,
        ),
      ),
    );
  }

  Widget _addButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 1),
      child: TextButton(
        onPressed: () => _addHandler(context),
        child: const Text('Add Todo'),
      ),
    );
  }
}
