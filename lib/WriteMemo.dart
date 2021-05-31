import 'package:flutter/material.dart';

import 'db.dart';

class ButtonDesign extends StatelessWidget {
  final String text;
  final Color color;

  ButtonDesign({
    Key key,
    @required this.text,
    @required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
      padding: EdgeInsets.all(25),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(color: color),
    );
  }
}

class SaveButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ButtonDesign(
      text: '저장',
      color: Colors.blue[300],
    );
  }
}

class CancleButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ButtonDesign(
      text: '취소',
      color: Colors.grey,
    );
  }
}

class WriteMemoButtons extends StatelessWidget {
  final Function saveMemo;
  final Function close;

  WriteMemoButtons({
    Key key,
    @required this.saveMemo,
    @required this.close,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: saveMemo,
          child: SaveButton(),
        ),
        GestureDetector(
          onTap: close,
          child: CancleButton(),
        ),
      ],
    );
  }
}

class WriteMemoForm extends StatelessWidget {
  final Function setTitle;
  final Function setBody;

  WriteMemoForm({
    Key key,
    @required this.setTitle,
    @required this.setBody,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          decoration: InputDecoration(hintText: '제목'),
          onChanged: setTitle,
        ),
        TextFormField(
          decoration: InputDecoration(hintText: '내용'),
          onChanged: setBody,
          minLines: 3,
          maxLines: 20,
        ),
      ],
    );
  }
}

class WriteMemo extends StatefulWidget {
  final Function close;

  WriteMemo({
    Key key,
    @required this.close,
  }) : super(key: key);

  @override
  _WriteMemoState createState() => _WriteMemoState();
}

class _WriteMemoState extends State<WriteMemo> {
  String title = '';
  String body = '';

  Future<void> saveMemo() async {
    ScaffoldMessenger.of(context).clearSnackBars();

    if (title.length == 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('제목을 작성해주세요.'),
      ));

      return;
    }

    if (body.length == 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('내용을 작성해주세요.'),
      ));

      return;
    }

    await MemoDB().addMemo(Memo(title: title, body: body));
    widget.close();
  }

  void setTitle(value) => setState(() => title = value);
  void setBody(value) => setState(() => body = value);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WriteMemoForm(setBody: setBody, setTitle: setTitle),
        WriteMemoButtons(close: widget.close, saveMemo: saveMemo)
      ],
    );
  }
}
