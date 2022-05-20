import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'todo.dart';

class TodoListStore {
  /// 保存時のキー
  final String _saveKey = "Todo";

  /// Todoリスト
  List<Todo> _list = [];

  /// ストアのインスタンス
  static final TodoListStore _instance = TodoListStore._internal();

  /// プライベートコンストラクタ
  TodoListStore._internal();

  /// ファクトリーコンストラクタ
  /// (インスタンスを生成しないコンストラクタのため、自分でインスタンスを生成する)
  factory TodoListStore() {
    return _instance;
  }

  /// Todoの件数を取得する
  int count() {
    return _list.length;
  }

  /// 指定したインデックスのTodoを取得する
  Todo findByIndex(int index) {
    return _list[index];
  }

  /// "yyyy/MM/dd HH:mm"形式で日時を取得する
  String getDateTime() {
    var format = DateFormat("yyyy/MM/dd HH:mm");
    var dateTime = format.format(DateTime.now());
    return dateTime;
  }

  /// Todoを追加する
  void add(bool done, String title, String detail) {
    var id = count() == 0 ? 1 : _list.last.id + 1;
    var dateTime = getDateTime();
    var todo = Todo(id, title, detail, done, dateTime, dateTime);
    _list.add(todo);
    save();
  }

  /// Todoを更新する
  void update(Todo todo, bool done, [String? title, String? detail]) {
    todo.done = done;
    if (title != null) {
      todo.title = title;
    }
    if (detail != null) {
      todo.detail = detail;
    }
    todo.updateDate = getDateTime();
    save();
  }

  /// Todoを削除する
  void delete(Todo todo) {
    _list.remove(todo);
    save();
  }

  /// Todoを保存する
  void save() async {
    var prefs = await SharedPreferences.getInstance();
    // SharedPreferencesはプリミティブ型とString型リストしか扱えないため、以下の変換を行っている
    // TodoList形式 → Map形式 → JSON形式 → StrigList形式
    var saveTargetList = _list.map((a) => json.encode(a.toJson())).toList();
    prefs.setStringList(_saveKey, saveTargetList);
  }

  /// Todoを読込する
  void load() async {
    var prefs = await SharedPreferences.getInstance();
    // SharedPreferencesはプリミティブ型とString型リストしか扱えないため、以下の変換を行っている
    // StrigList形式 → JSON形式 → Map形式 → TodoList形式
    var loadTargetList = prefs.getStringList(_saveKey) ?? [];
    _list = loadTargetList.map((a) => Todo.fromJson(json.decode(a))).toList();
  }
}
