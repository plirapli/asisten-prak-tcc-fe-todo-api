import 'dart:async';
import 'package:flutter/material.dart';
import 'package:prak_tcc_fe_mobile/model/todo.dart';
import 'package:prak_tcc_fe_mobile/theme.dart';
import 'package:prak_tcc_fe_mobile/util/todo.dart';

class EditPage extends StatefulWidget {
  final int id;
  const EditPage({super.key, required this.id});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _isi = TextEditingController();
  bool _isDataLoaded = false;
  bool isError = false;
  String msg = "";
  Future? _future;

  Future<void> _editHandler(BuildContext context) async {
    try {
      final Map<String, dynamic> response = await TodoApi.editTodo(
        (widget.id).toString(),
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
      if (!context.mounted) return;
      SnackBar snackBar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(snackBar);
    }
  }

  @override
  void initState() {
    super.initState();
    _future = TodoApi.getTodoById((widget.id).toString());
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
        appBar: AppBar(title: const Text("Edit Todo")),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              const SizedBox(height: 20),
              _content(),
              const SizedBox(height: 20)
            ],
          ),
        ),
      ),
    );
  }

  Widget _content() {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        final height = MediaQuery.of(context).size.height;
        if (snapshot.hasError) {
          return _buildError(snapshot.error.toString());
        } else if (snapshot.hasData) {
          if (!_isDataLoaded) {
            _isDataLoaded = true;
            final bool isError = snapshot.data["status"] == "Error";
            if (isError) return _buildError(snapshot.data["message"]);

            TodoItem todoModel = TodoItem.fromJson(snapshot.data["data"]);
            _title.text = todoModel.title!;
            _isi.text = todoModel.isi!;
          }
          return _form(context);
        }
        return _buildLoading(height * 0.65);
      },
    );
  }

  Widget _buildLoading(double height) {
    return SizedBox(
      height: height,
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildError(String msg) {
    return Container(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        msg,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _form(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _heading(),
        _titleField(),
        _isiField(),
        _editButton(context),
      ],
    );
  }

  Widget _heading() {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Edit your todo",
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
        color: isError ? MyTheme.errorColor["bg"] : Colors.white,
      ),
      child: TextFormField(
        enabled: true,
        controller: _isi,
        onChanged: (value) {
          setState(() {
            if (isError) isError = false;
          });
        },
        maxLines: 18,
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

  Widget _editButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 1),
      child: TextButton(
        onPressed: () => _editHandler(context),
        child: const Text('Save Todo'),
      ),
    );
  }
}
