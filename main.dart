import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'Task_database.dart';
import 'Task_database_model.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ToDo管理アプリ',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: const TasksPage(),
    );
  }
}

//tasks_page.dart
class TasksPage extends StatefulWidget {
  const TasksPage({Key? key}) : super(key: key);

  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  List<Task> tasks = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  @override
  void dispose() {
    TaskDatabase.instance.closeDatabase();
    super.dispose();
  }

  Future loadTasks() async {
    setState(() => isLoading = true);
    await TaskDatabase.instance.deleteExpiredTask();
    tasks = await TaskDatabase.instance.readAllTask();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDo管理アプリ'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SizedBox(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (BuildContext context, int index) {
                  final task = tasks[index];
                  return Card(
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(
                                  task.taskname,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Text('期限：'),
                                    Text(DateFormat('yyyy/MM/dd HH:mm')
                                        .format(task.deadline)),
                                  ],
                                ),
                              ],
                            ),
                            IconButton(
                              alignment: Alignment.center,
                              icon: const Icon(
                                Icons.check_circle_outline,
                                color: Colors.green,
                              ),
                              onPressed: () async {
                                await TaskDatabase.instance.completeTask(task.id!);
                              },
                            ),
                          ],
                        ),
                      ),
                      onTap: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                ReadTaskPage(taskId: task.id!),
                          ),
                        );
                        loadTasks();
                      },
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: Container(
          child: const Icon(Icons.add),
          height: 56,
          width: 56,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                Colors.orangeAccent,
                Colors.red,
              ],
            ),
          ),
        ),
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const EditTaskPage()),
          );
          loadTasks();
        },
      ),
    );
  }
}

//task_form_page.dart
class TaskFormPage extends StatelessWidget {
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

  const TaskFormPage({
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

  @override
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
      //sbIdの管理がどうなっているのかわからないので処理は保留
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
//read_task_page.dart
class ReadTaskPage extends StatefulWidget {
  final int taskId;

  const ReadTaskPage({
    Key? key,
    required this.taskId,
  }) : super(key: key);

  @override
  _ReadTaskPageState createState() => _ReadTaskPageState();
}

class _ReadTaskPageState extends State<ReadTaskPage> {
  late Task task;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadTask();
  }

  Future loadTask() async {
    setState(() => isLoading = true);
    task = await TaskDatabase.instance.readTask(widget.taskId);
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.edit,
              color: Colors.white,
            ),
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditTaskPage(
                    task: task,
                  ),
                ),
              );
              loadTask();
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
            onPressed: () async {
              await TaskDatabase.instance.deleteTask(widget.taskId);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            '${task.isPrivate}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Text(
                            task.taskname,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: const Text('期限(完了済みは灰色、未完了は緑)'),
                    color: task.isCompleted ? Colors.grey[300]: Colors.green,
                    height: 20,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                    ),
                  ),
                  Container(
                    child: Text(
                      DateFormat('yyyy/MM/dd HH:mm').format(task.deadline),
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    padding: const EdgeInsets.all(5.0),
                  ),
                  Container(
                    child: const Text('科目'),
                    color: Colors.grey[300],
                    height: 20,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(task.subject),
                  )
                ],
              ),
            ),
    );
  }
}

//edit_task_page.dart
class EditTaskPage extends StatefulWidget {
  final Task? task;

  const EditTaskPage({
    Key? key,
    this.task,
  }) : super(key: key);

  @override
  _EditTaskPageState createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  final _formkey = GlobalKey<FormState>();
  late bool isCompleted;     //完了済みor未完了
  late int isPrivate;        //自作タスクorサーバから
  late String taskname;          //課題名
  late String subject;       //科目名
  late String sbId;         //科目id
  late DateTime deadline;    //締め切り

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
        title: const Text('タスクの編集'),
        actions: [
          buildSaveButton(),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: TaskFormPage(
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

  Widget buildSaveButton() {
    final isFormValid = taskname.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ElevatedButton(
        child: const Text('保存'),
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          primary: isFormValid ? Colors.redAccent : Colors.grey.shade700,
        ),
        onPressed: createOrUpdateTask,
      ),
    );
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
  }
}
