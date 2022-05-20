import 'package:flutter/material.dart';
import 'todo_list_page.dart';

/// エントリーポイント
void main() {
  runApp(const TodoListApp());
}

/// Todoリストアプリのクラス
///
/// 以下の責務を持つ
/// ・Todoリスト画面を生成する
class TodoListApp extends StatelessWidget {
  /// コンストラクタ
  const TodoListApp({Key? key}) : super(key: key);

  /// 画面を作成する
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // アプリケーションのタイトル
      title: 'Todoリスト',
      // アプリケーションのテーマ
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      // Todoリスト画面を生成しホーム画面とする
      home: const TodoListPage(),
    );
  }
}
