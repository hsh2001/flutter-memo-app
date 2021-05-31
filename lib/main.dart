import 'package:flutter/material.dart';

import 'EditMemo.dart';
import 'Memo.dart';
import 'WriteMemo.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isWriteMode = false;
  int editTarget = 0;

  void startWriteMode() {
    setState(() => isWriteMode = true);
  }

  void endWriteMode() {
    setState(() => isWriteMode = false);
  }

  void setEditTarget(int id) {
    setState(() => editTarget = id);
  }

  void endEditMode() {
    setState(() => editTarget = 0);
  }

  void startListMode() {
    endEditMode();
    endWriteMode();
  }

  @override
  Widget build(BuildContext context) {
    Widget body;

    if (isWriteMode) {
      body = WriteMemo(close: endWriteMode);
    } else if (editTarget != 0) {
      body = EditMemo(target: editTarget, close: endEditMode);
    } else {
      body = MemoLoader(setEditTarget: setEditTarget);
    }

    return MaterialApp(
      title: 'Hello flutter',
      theme: ThemeData(primaryColor: Colors.blue),
      home: Scaffold(
        appBar: AppBar(
          title: GestureDetector(
            child: const Text('메모장'),
            onTap: startListMode,
          ),
        ),
        body: body,
        floatingActionButton: isWriteMode
            ? null
            : FloatingActionButton(
                onPressed: startWriteMode,
                child: const Icon(Icons.add),
              ),
      ),
    );
  }
}
