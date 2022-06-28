/*******************************************************************
 ***  File Name		: Task_database_model.dart
 ***  Version		: V1.0
 ***  Designer		: 千手　香穂
 ***  Date			: 2022.06.14
 ***  Purpose       	: データベースのモデルを定義する
 ***
 *******************************************************************/
/*
*** Revision :
*** V1.0 : 千手香穂, 2022/06/14
*** V1.1 : 千手香穂, 2022/06/14 sb_idを追加
*/

final String tableTasks = 'tasks';

//カラムの名前定義
class TaskFields {
  static final List<String> values = [
    id, isCompleted, isPrivate, task, subject, sb_id, time
  ];
  static final String id = '_id';
  static final String isCompleted = 'isCompleted';
  static final String isPrivate = 'isPrivate';
  static final String task = 'task';
  static final String subject = 'subject';
  static final String sb_id = 'sb_id';
  static final String time = 'time';
}

//データベースの構造定義
class Task {
  final int? id;              //自動で付与される課題ID
  final bool isCompleted;     //完了済みor未完了
  final int isPrivate;        //自作タスクorサーバから
  final String task;          //課題名
  final String subject;       //科目名
  final String sb_id;       //科目id
  final DateTime deadline;    //締め切り

  const Task({
    this.id,
    required this.isCompleted,
    required this.isPrivate,
    required this.task,
    required this.subject,
    required this.sb_id,
    required this.deadline,
  });

  Task copy({
    int? id,
    bool? isCompleted,
    int? isPrivate,
    String? task,
    String? subject,
    String? sb_id,
    DateTime? deadline,
  }) =>
      Task(
        id: id ?? this.id,
        isCompleted: isCompleted ?? this.isCompleted,
        isPrivate: isPrivate ?? this.isPrivate,
        task: task ?? this.task,
        subject: subject ?? this.subject,
        sb_id: sb_id ?? this.sb_id,
        deadline: deadline ?? this.deadline,
      );

  static Task fromJson(Map<String, Object?> json) => Task(
    id: json[TaskFields.id] as int?,
    isCompleted: json[TaskFields.isCompleted] == 1,
    isPrivate: json[TaskFields.isPrivate] as int,
    task: json[TaskFields.task] as String,
    subject: json[TaskFields.subject] as String,
    sb_id: json[TaskFields.sb_id] as String,
    deadline: DateTime.parse(json[TaskFields.time] as String),
  );

  Map<String, Object?> toJson() => {
    TaskFields.id: id,
    TaskFields.task: task,
    TaskFields.subject: subject,
    TaskFields.sb_id: sb_id,
    TaskFields.isCompleted: isCompleted ? 1 : 0,
    TaskFields.isPrivate: isPrivate,
    TaskFields.time: deadline.toIso8601String(),
  };
}