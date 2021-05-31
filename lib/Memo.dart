import 'package:flutter/material.dart';

import 'db.dart';

class MemoView extends StatelessWidget {
  static final titleBoxDecoration = BoxDecoration(
    color: Colors.amber[100],
  );

  static final bodyBoxDecoration = BoxDecoration();

  final Memo memo;
  final Function startEdit;

  MemoView({
    Key key,
    @required this.memo,
    @required this.startEdit,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: GestureDetector(
        onTap: startEdit,
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(5),
              child: Text(memo.title),
              decoration: titleBoxDecoration,
            ),
            Container(
              child: Text(' ${memo.body}', overflow: TextOverflow.clip),
              decoration: bodyBoxDecoration,
            ),
          ],
        ),
      ),
    );
  }
}

class MemoList extends StatelessWidget {
  final List<Memo> memos;
  final Function setEditTarget;

  MemoList({
    Key key,
    @required this.memos,
    @required this.setEditTarget,
  }) : super(key: key);

  Widget build(BuildContext context) {
    if (memos.length == 0) {
      return Center(
        child: Text('메모가 없어요.'),
      );
    }

    return SingleChildScrollView(
      child: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 32),
          child: Column(
            children: List<Widget>.generate(
              memos.length,
              (index) => MemoView(
                memo: memos[index],
                startEdit: () => setEditTarget(memos[index].id),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MemoLoader extends StatelessWidget {
  final Function setEditTarget;

  MemoLoader({Key key, @required this.setEditTarget}) : super(key: key);

  Widget build(BuildContext context) {
    return FutureBuilder(
      future: MemoDB().getMemos(),
      builder: (BuildContext context, AsyncSnapshot<List<Memo>> snapshot) {
        final data = snapshot.data;
        if (data == null || data.isEmpty) {
          return MemoList(memos: [], setEditTarget: () => {});
        } else {
          return MemoList(memos: data, setEditTarget: setEditTarget);
        }
      },
    );
  }
}
