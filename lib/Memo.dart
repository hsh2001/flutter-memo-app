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

  Widget _titleWidget() {
    return Container(
      padding: EdgeInsets.all(5),
      child: Text(memo.title),
      decoration: titleBoxDecoration,
    );
  }

  Widget _bodyWidget() {
    return Container(
      child: Text(' ${memo.body}', overflow: TextOverflow.clip),
      decoration: bodyBoxDecoration,
    );
  }

  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: GestureDetector(
        onTap: startEdit,
        child: Row(children: [_titleWidget(), _bodyWidget()]),
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

  List<Widget> _memoWidgets() {
    return List<Widget>.generate(
      memos.length,
      (index) => MemoView(
        memo: memos[index],
        startEdit: () => setEditTarget(memos[index].id),
      ),
    );
  }

  Widget _container({List<Widget> children}) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 32),
          child: Column(children: children),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return memos.length > 0
        ? _container(children: _memoWidgets())
        : Center(child: Text('메모가 없어요.'));
  }
}

class MemoLoader extends StatelessWidget {
  final Function setEditTarget;

  MemoLoader({
    Key key,
    @required this.setEditTarget,
  }) : super(key: key);

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
