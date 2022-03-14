import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_task_list/data/data.dart';
import 'package:flutter_app_task_list/main.dart';
import 'package:flutter_app_task_list/screens/edit/edit.dart';
import 'package:flutter_app_task_list/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeScree extends StatelessWidget {
  HomeScree({Key? key}) : super(key: key);
  final TextEditingController controller = TextEditingController();
  final ValueNotifier<String> searchKeywordNotifier = ValueNotifier('');

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<TaskEntity>(taskBoxName);
    final themeData = Theme.of(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => EditTaskScreen(
                task: TaskEntity(),
              ),
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
                        controller: controller,
                        onChanged: (value) {
                          searchKeywordNotifier.value = controller.text;
                        },
                        decoration: const InputDecoration(
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
              child: ValueListenableBuilder<String>(
                valueListenable: searchKeywordNotifier,
                builder: (context, value, child) {
                  return ValueListenableBuilder<Box<TaskEntity>>(
                    valueListenable: box.listenable(),
                    builder: (context, box, child) {
                      final List<TaskEntity> items;
                      if (controller.text.isEmpty) {
                        items = box.values.toList();
                      } else {
                        items = box.values
                            .where(
                                (task) => task.name.contains(controller.text))
                            .toList();
                      }

                      if (items.isNotEmpty) {
                        return ListView.builder(
                            padding: EdgeInsets.fromLTRB(16, 16, 16, 100),
                            itemCount: items.length + 1,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Today',
                                            style: themeData
                                                .textTheme.headline6!
                                                .apply(fontSizeFactor: 0.8)),
                                        Container(
                                          margin: const EdgeInsets.only(top: 4),
                                          width: 70,
                                          height: 3,
                                          decoration: BoxDecoration(
                                            color: primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(1.5),
                                          ),
                                        )
                                      ],
                                    ),
                                    MaterialButton(
                                      color: const Color(0xffEAEFF5),
                                      textColor: secondaryTextColor,
                                      elevation: 0,
                                      onPressed: () {
                                        box.clear();
                                      },
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
                                final TaskEntity task = items[index - 1];
                                return taskItem(task: task);
                              }
                            });
                      } else {
                        return const EmptyState();
                      }
                    },
                  );
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
  static const double height = 74;
  static const double borderRadius = 8;
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
    final Color priorityColor;

    switch (widget.task.priority) {
      case Priority.low:
        // TODO: Handle this case.
        priorityColor = lowPriority;
        break;
      case Priority.normal:
        // TODO: Handle this case.
        priorityColor = normalPriority;
        break;
      case Priority.high:
        // TODO: Handle this case.
        priorityColor = highPriority;
        break;
    }
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => EditTaskScreen(task: widget.task),
          ),
        );
        // setState(() {
        //   widget.task.isCompleted = !widget.task.isCompleted;
        // });
      },
      onLongPress: () {
        widget.task.delete();
      },
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.only(left: 16),
        height: taskItem.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(taskItem.borderRadius),
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
            MyCheckBox(
                value: widget.task.isCompleted,
                onTap: () {
                  setState(() {
                    widget.task.isCompleted = !widget.task.isCompleted;
                  });
                }),
            SizedBox(
              width: 16,
            ),
            Expanded(
              child: Text(
                widget.task.name,
                maxLines: 1,
                overflow: TextOverflow.fade,
                style: TextStyle(
                    decoration: widget.task.isCompleted
                        ? TextDecoration.lineThrough
                        : null),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Container(
              width: 5,
              height: taskItem.height,
              decoration: BoxDecoration(
                color: priorityColor,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(taskItem.borderRadius),
                  bottomRight: Radius.circular(taskItem.borderRadius),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
