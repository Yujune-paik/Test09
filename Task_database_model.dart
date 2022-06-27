/*******************************************************************
***  File Name		: Task_database_model.dart
***  Version		: V1.1
***  Designer		: 千手　香穂
***  Date			: 2022.06.14
***  Purpose       	: データベースのモデルを定義する
***
*******************************************************************/
/*
*** Revision :
*** V1.0 : 千手香穂, 2022/06/14
*** V1.1 : 千手香穂, 2022/06/14 sbIdを追加
*/

const String tableTasks = 'tasks';

//カラムの名前定義
class TaskFields {
    static final List<String> values = [
        id,
        isCompleted,
        isPrivate,
        taskname,
        subject,
        sbId,
        deadline
    ];
    static const String id = '_id';
    static const String isCompleted = 'isCompleted';
    static const String isPrivate = 'isPrivate';
    static const String taskname = 'taskname';
    static const String subject = 'subject';
    static const String sbId = 'sbId';
    static const String deadline = 'deadline';
}

//データベースの構造定義
class Task {
    final int? id;              //自動で付与される課題ID
    final bool isCompleted;     //完了済みor未完了
    final int isPrivate;        //自作タスクorサーバから
    final String taskname;          //課題名
    final String subject;       //科目名
    final String sbId;         //科目id
    final DateTime deadline;    //締め切り

    const Task({
        this.id,
        required this.isCompleted,
        required this.isPrivate,
        required this.taskname,
        required this.subject,
        required this.sbId,
        required this.deadline,
    });
    
    Task copy({
        int? id,
        bool? isCompleted,
        int? isPrivate,
        String? taskname,
        String? subject,
        String? sbId,
        DateTime? deadline,
    }) =>
        Task(
            id: id ?? this.id,
            isCompleted: isCompleted ?? this.isCompleted,
            isPrivate: isPrivate ?? this.isPrivate,
            taskname: taskname ?? this.taskname,
            subject: subject ?? this.subject,
            sbId: sbId ?? this.sbId,
            deadline: deadline ?? this.deadline,
        );

    static Task fromJson(Map<String, Object?> json) => Task(
        id: json[TaskFields.id] as int?,
        isCompleted: json[TaskFields.isCompleted] == 1,
        isPrivate: json[TaskFields.isPrivate] as int,
        taskname: json[TaskFields.taskname] as String,
        subject: json[TaskFields.subject] as String,
        sbId: json[TaskFields.sbId] as String,
        deadline: DateTime.parse(json[TaskFields.deadline] as String),
    );

    Map<String, Object?> toJson() => {
        TaskFields.id: id,
        TaskFields.taskname: taskname,
        TaskFields.subject: subject,
        TaskFields.sbId: sbId,
        TaskFields.isCompleted: isCompleted ? 1 : 0,
        TaskFields.isPrivate: isPrivate,
        TaskFields.deadline: deadline.toIso8601String(),
    };
}
