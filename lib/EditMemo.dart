import 'package:flutter/material.dart';

import 'db.dart';

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
      GestureDetector(onTap: submit, child: Text('수정')),
      GestureDetector(onTap: delete, child: Text('삭제')),
      GestureDetector(onTap: close, child: Text('취소')),
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
          Buttons(submit: submit, delete: delete, close: widget.close)
        ]);
      },
    );
  }
}
