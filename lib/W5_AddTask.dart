import 'package:flutter/material.dart';
import 'W2-1_MyHomePage.dart';

import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'Task_database.dart';
import 'Task_database_model.dart';

/*
class W5_AddTask extends StatefulWidget {
  final Task? task;
  final bool? isCompleted;     //完了済みor未完了
  final int? isPrivate;        //自作タスクorサーバから
  final String? taskname;          //課題名
  final String? subject;       //科目名
  final String? sbId;         //科目id
  final DateTime? deadline;    //締め切り
  final ValueChanged<bool> onChangedIsCompleted;
  final ValueChanged<int> onChangedIsPrivate;
  final ValueChanged<String> onChangedTaskName;
  final ValueChanged<String> onChangedSubject;
  final ValueChanged<String> onChangedSbId;
  final ValueChanged<DateTime> onChangedDeadline;

  const W5_AddTask({
    Key? key,
    this.task,
    this.isCompleted = false,
    this.isPrivate = -1,
    this.taskname,
    this.subject ,
    this.sbId = 'temp',
    this.deadline,
    required this.onChangedIsCompleted,
    required this.onChangedIsPrivate,
    required this.onChangedTaskName,
    required this.onChangedSubject,
    required this.onChangedSbId,
    required this.onChangedDeadline,
}): super(key: key);

  @override
  _W5_AddTaskState createState() => _W5_AddTaskState();
}

class _W5_AddTaskState extends State<W5_AddTask>{
  final _formkey = GlobalKey<FormState>();
  late bool isCompleted;     //完了済みor未完了
  late int isPrivate;        //自作タスクorサーバから
  late String taskname;          //課題名
  late String subject;       //科目名
  late String sbId;         //科目id
  late DateTime deadline;

  @override
  void initState() {
    super.initState();
    isCompleted = widget.task?.isCompleted ?? false;
    isPrivate = widget.task?.isPrivate ?? -1;
    taskname = widget.task?.taskname ?? '';
    subject = widget.task?.subject ?? 'subject_name';
    sbId = widget.task?.sbId ?? 'subject_id';
    deadline = widget.task?.deadline ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('課題を追加',
          style: TextStyle(
          color: Colors.black,
        ),
        ),
        leading: TextButton(
          child: Text(
            '☓',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          onPressed: () => Navigator.of(context
          ).pop(),
        ),
        bottom: PreferredSize(
          child: Container(
            height: 5,
            color: Colors.green,
          ),
          preferredSize: Size.fromHeight(5),
        ),
      ),

      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: W5_AddTask(
            isCompleted: isCompleted,
            isPrivate: isPrivate,
            taskname: taskname,
            subject: subject,
            sbId: sbId,
            deadline: deadline,
            onChangedIsCompleted: (isCompleted) =>
                setState(() => this.isCompleted = isCompleted),
            onChangedIsPrivate: (isPrivate) =>
                setState(() => this.isPrivate = isPrivate),
            onChangedTaskName: (taskname) => setState(() => this.taskname = taskname),
            onChangedSubject: (subject) =>
                setState(() => this.subject = subject),
            onChangedSbId: (sbId) => setState(() => this.sbId = sbId),
            onChangedDeadline: (deadline) =>
                setState(() => this.deadline = deadline),
          ),
        ),
      ),
    );
  }
}
void createOrUpdateTask() async {
  final isValid = _formkey.currentState!.validate();

  if (isValid) {
    final isUpdate = (widget.task != null);
    if (isUpdate) {
      await updateTask();
    } else {
      await createTask();
    }
    Navigator.of(context).pop();
  }
}

Future updateTask() async {
  final task = widget.task!.copy(
    isCompleted: isCompleted,
    isPrivate: isPrivate,
    taskname: taskname,
    subject: subject,
    sbId: sbId,
    deadline: deadline,
  );

  await TaskDatabase.instance.editTask(task);
}

Future createTask() async {
  final task = Task(
    isCompleted: isCompleted,
    isPrivate: isPrivate,
    taskname: taskname,
    subject: subject,
    sbId: sbId,
    deadline: deadline,
  );
  await TaskDatabase.instance.addTask(task);
}*/

//task_form_page.dart

@override
class W5_AddTask extends StatelessWidget{
  final bool? isCompleted;     //完了済みor未完了
  final int? isPrivate;        //自作タスクorサーバから
  final String? taskname;          //課題名
  final String? subject;       //科目名
  final String? sbId;         //科目id
  final DateTime? deadline;    //締め切り
  final ValueChanged<bool> onChangedIsCompleted;
  final ValueChanged<int> onChangedIsPrivate;
  final ValueChanged<String> onChangedTaskName;
  final ValueChanged<String> onChangedSubject;
  final ValueChanged<String> onChangedSbId;
  final ValueChanged<DateTime> onChangedDeadline;

  const W5_AddTask({
    Key? key,
    this.isCompleted = false,
    this.isPrivate = -1,
    this.taskname,
    this.subject ,
    this.sbId = 'temp',
    this.deadline,
    required this.onChangedIsCompleted,
    required this.onChangedIsPrivate,
    required this.onChangedTaskName,
    required this.onChangedSubject,
    required this.onChangedSbId,
    required this.onChangedDeadline,
}) : super(key: key);

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          buildTask(),
          buildSubject(),
          buildDeadline(context),
        ],
      ),
    );
  }
  Widget buildTask() {
    return TextFormField(
      maxLines: 1,
      initialValue: taskname,
      decoration: const InputDecoration(
        hintText: 'タスク名を入力しください',
      ),
      validator: (taskname) => taskname != null && taskname.isEmpty ? 'タスク名は入力必須です' : null,
      onChanged: onChangedTaskName,
    );
  }
  Widget buildSubject() {
    return TextFormField(
      maxLines: 1,
      initialValue: subject,
      decoration: const InputDecoration(
        hintText: '科目名を入力しください',
      ),
      validator: (subject) => subject != null && subject.isEmpty ? '科目名は入力必須です' : null,
      onChanged: onChangedTaskName,
    );
  }
  Widget buildDeadline(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const Text('期限'),
        Expanded(
          child: TextButton(
            child: Text(DateFormat('yyyy/MM/dd HH:mm').format(deadline!)),
            onPressed: () {
              showDeadlinePicker(context);
            },
          ),
        ),
      ],
    );
  }
  void showDeadlinePicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height / 3,
          child: CupertinoDatePicker(
            initialDateTime: deadline,
            mode: CupertinoDatePickerMode.dateAndTime,
            minimumDate: DateTime.now().add(const Duration(days: 365) * -1),
            maximumDate: DateTime.now().add(const Duration(days: 365)),
            use24hFormat: true,
            onDateTimeChanged: onChangedDeadline,
          ),
        );
      },
    );
  }
}