import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'todo_input_page.dart';
import 'todo_list_store.dart';
import 'todo.dart';

/// Todoリスト画面のクラス
///
/// 以下の責務を持つ
/// ・Todoリスト画面の状態を生成する
class TodoListPage extends StatefulWidget {
  /// コンストラクタ
  const TodoListPage({Key? key}) : super(key: key);

  /// Todoリスト画面の状態を生成する
  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

/// Todoリスト画面の状態クラス
///
/// 以下の責務を持つ
/// ・Todoリストを表示する
/// ・Todoの追加/編集画面へ遷移する
/// ・Todoの削除を行う
class _TodoListPageState extends State<TodoListPage> {
  /// ストア
  final TodoListStore _store = TodoListStore();

  /// Todoリスト入力画面に遷移する
  void _pushTodoInputPage([Todo? todo]) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return TodoInputPage(todo: todo);
        },
      ),
    );

    // Todoの追加/更新を行う場合があるため、画面を更新する
    setState(() {});
  }

  /// 初期処理を行う
  @override
  void initState() {
    super.initState();

    Future(
      () async {
        // ストアからTodoリストデータをロードし、画面を更新する
        setState(() => _store.load());
      },
    );
  }

  /// 画面を作成する
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // アプリケーションバーに表示するタイトル
        title: const Text('Todoリスト'),
      ),
      body: ListView.builder(
        // Todoの件数をリストの件数とする
        itemCount: _store.count(),
        itemBuilder: (context, index) {
          // インデックスに対応するTodoを取得する
          var item = _store.findByIndex(index);
          return Slidable(
            // 右方向にリストアイテムをスライドした場合のアクション
            startActionPane: ActionPane(
              motion: const ScrollMotion(),
              extentRatio: 0.25,
              children: [
                SlidableAction(
                  onPressed: (context) {
                    // Todo編集画面に遷移する
                    _pushTodoInputPage(item);
                  },
                  backgroundColor: Colors.yellow,
                  icon: Icons.edit,
                  label: '編集',
                ),
              ],
            ),
            // 左方向にリストアイテムをスライドした場合のアクション
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              extentRatio: 0.25,
              children: [
                SlidableAction(
                  onPressed: (context) {
                    // Todoを削除し、画面を更新する
                    setState(() => {_store.delete(item)});
                  },
                  backgroundColor: Colors.red,
                  icon: Icons.edit,
                  label: '削除',
                ),
              ],
            ),
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey),
                ),
              ),
              child: ListTile(
                // ID
                leading: Text(item.id.toString()),
                // タイトル
                title: Text(item.title),
                // 完了か
                trailing: Checkbox(
                  // チェックボックスの状態
                  value: item.done,
                  onChanged: (bool? value) {
                    // Todo(完了か)を更新し、画面を更新する
                    setState(() => _store.update(item, value!));
                  },
                ),
              ),
            ),
          );
        },
      ),
      // Todo追加画面に遷移するボタン
      floatingActionButton: FloatingActionButton(
        // Todo追加画面に遷移する
        onPressed: _pushTodoInputPage,
        child: const Icon(Icons.add),
      ),
    );
  }
}
