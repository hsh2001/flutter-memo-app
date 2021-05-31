import 'package:flutter/material.dart';

import 'db.dart';

class Button extends StatelessWidget {
  final Color color;
  final String text;
  final Function onTap;

  Button({
    @required this.color,
    @required this.text,
    @required this.onTap,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: color,
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 60),
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Text(text),
      ),
    );
  }
}

class Buttons extends StatelessWidget {
  final Function submit;
  final Function close;
  final Function delete;

  Buttons({
    @required this.submit,
    @required this.close,
    @required this.delete,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Button(onTap: submit, text: '수정', color: Colors.blueAccent),
      Button(onTap: delete, text: '삭제', color: Colors.red),
      Button(onTap: close, text: '취소', color: Colors.grey),
    ]);
  }
}

class EditMemo extends StatefulWidget {
  final int target;
  final Function close;

  EditMemo({
    Key key,
    @required this.target,
    @required this.close,
  }) : super(key: key);

  @override
  _EditMemoState createState() => _EditMemoState();
}

class _EditMemoState extends State<EditMemo> {
  String title;
  String body;

  Future<void> submit() async {
    await MemoDB().edit(widget.target, Memo(body: body, title: title));
    widget.close();
  }

  Future<void> delete() async {
    await MemoDB().delete(widget.target);
    widget.close();
  }

  Future<void> confirmAndDelete() async {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('잠시만요!'),
          content: Text('정말로 메모를 삭제하시겠습니까?'),
          actions: <Widget>[
            TextButton(
                child: Text('아니오'),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            TextButton(
                child: Text('네'),
                onPressed: () {
                  delete();
                  Navigator.of(context).pop();
                }),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: MemoDB().getOne(widget.target),
      builder: (context, shapshot) {
        final data = shapshot.data as Memo;

        if (data == null) {
          return Container();
        }

        title = data.title;
        body = data.body;

        return Column(children: [
          TextFormField(
            decoration: InputDecoration(hintText: '제목'),
            onChanged: (newTitle) => title = newTitle,
            initialValue: title,
          ),
          TextFormField(
            decoration: InputDecoration(hintText: '내용'),
            onChanged: (newBody) => body = newBody,
            initialValue: body,
            minLines: 3,
            maxLines: 20,
          ),
          Buttons(submit: submit, delete: confirmAndDelete, close: widget.close)
        ]);
      },
    );
  }
}
