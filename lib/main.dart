import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_task_list/data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

const taskBoxName = 'TaskBox';
void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(PriorityAdapter());
  await Hive.openBox<TaskEntity>(taskBoxName);
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: primaryVariantColor),
  );
  runApp(const MyApp());
}

const Color primaryColor = Color(0xff794cff);
const Color primaryVariantColor = Color(0xff5c0aff);
final secondaryTextColor = Color(0xffAFBED0);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final primaryTextColor = Color(0xff1D2830);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        textTheme: GoogleFonts.poppinsTextTheme(
          TextTheme(
            headline6: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(
            color: secondaryTextColor,
          ),
          border: InputBorder.none,
        ),

        colorScheme: ColorScheme.light(
          primary: primaryColor,
          primaryVariant: primaryVariantColor,
          background: Color(0xfff3f5f8),
          onSurface: primaryTextColor,
          onBackground: primaryTextColor,
          onPrimary: Colors.white,
          secondary: primaryColor,
          onSecondary: Colors.white,
        ),
      ),
      home: const HomeScree(),
    );
  }
}

class HomeScree extends StatelessWidget {
  const HomeScree({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<TaskEntity>(taskBoxName);
    final themeData = Theme.of(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => EditTaskScreen(),
            ));
          },
          label: Row(
            children: const [
              Text('Add New Task'),
              SizedBox(
                width: 4,
              ),
              Icon(CupertinoIcons.add_circled)
            ],
          )),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 110,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    themeData.colorScheme.primary,
                    themeData.colorScheme.primaryVariant
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'To Do List',
                          style: themeData.textTheme.headline6!
                              .apply(color: themeData.colorScheme.onPrimary),
                        ),
                        Icon(
                          CupertinoIcons.share,
                          color: themeData.colorScheme.onPrimary,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                      height: 38,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(19),
                        color: themeData.colorScheme.onPrimary,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(CupertinoIcons.search),
                          label: Text('Search Tasks'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ValueListenableBuilder<Box<TaskEntity>>(
                valueListenable: box.listenable(),
                builder: (context, box, child) {
                  return ListView.builder(
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 100),
                      itemCount: box.values.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Today',
                                      style: themeData.textTheme.headline6!
                                          .apply(fontSizeFactor: 0.8)),
                                  Container(
                                    margin: const EdgeInsets.only(top: 4),
                                    width: 70,
                                    height: 3,
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(1.5),
                                    ),
                                  )
                                ],
                              ),
                              MaterialButton(
                                color: const Color(0xffEAEFF5),
                                textColor: secondaryTextColor,
                                elevation: 0,
                                onPressed: () {},
                                child: Row(
                                  children: const [
                                    Text('Delete All'),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Icon(
                                      CupertinoIcons.delete_solid,
                                      size: 16,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          );
                        } else {
                          final TaskEntity task =
                              box.values.toList()[index - 1];
                          return taskItem(task: task);
                        }
                      });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class taskItem extends StatefulWidget {
  const taskItem({
    Key? key,
    required this.task,
  }) : super(key: key);

  final TaskEntity task;

  @override
  State<taskItem> createState() => _taskItemState();
}

class _taskItemState extends State<taskItem> {
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return InkWell(
      onTap: () {
        setState(() {
          widget.task.isCompleted = !widget.task.isCompleted;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.only(left: 16, right: 16),
        height: 84,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: themeData.colorScheme.surface,
          // boxShadow: [
          //   BoxShadow(
          //     blurRadius: 20,
          //     color: Colors.black.withOpacity(0.2),
          //   )
          // ]
        ),
        child: Row(
          children: [
            MyCheckBox(value: widget.task.isCompleted),
            SizedBox(
              width: 16,
            ),
            Expanded(
              child: Text(
                widget.task.name,
                maxLines: 1,
                overflow: TextOverflow.fade,
                style: TextStyle(
                    fontSize: 24,
                    decoration: widget.task.isCompleted
                        ? TextDecoration.lineThrough
                        : null),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyCheckBox extends StatelessWidget {
  final bool value;
  const MyCheckBox({Key? key, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border:
              !value ? Border.all(color: secondaryTextColor, width: 2) : null,
          color: value ? primaryColor : null),
      child: value
          ? Icon(
              CupertinoIcons.check_mark,
              color: themeData.colorScheme.onPrimary,
              size: 14,
            )
          : null,
    );
  }
}

class EditTaskScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  EditTaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Task...'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            final task = TaskEntity();
            task.name = _controller.text;
            task.priority = Priority.normal;
            if (task.isInBox) {
              task.save();
            } else {
              final Box<TaskEntity> box = Hive.box(taskBoxName);
              box.add(task);
            }
            Navigator.of(context).pop();
          },
          label: const Text('Save')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration:
                  InputDecoration(label: Text('Add a task for today...')),
            )
          ],
        ),
      ),
    );
  }
}
