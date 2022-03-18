import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_task_list/data/data.dart';
import 'package:flutter_app_task_list/data/repo/repository.dart';
import 'package:flutter_app_task_list/main.dart';
import 'package:flutter_app_task_list/screens/edit/cubit/edittask_cubit.dart';
import 'package:flutter_app_task_list/screens/edit/edit.dart';
import 'package:flutter_app_task_list/screens/home/bloc/tasklist_bloc.dart';
import 'package:flutter_app_task_list/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  final TextEditingController controller = TextEditingController();
  final ValueNotifier<String> searchKeywordNotifier = ValueNotifier('');

  @override
  Widget build(BuildContext context) {
    // final box = Hive.box<TaskEntity>(taskBoxName);

    final themeData = Theme.of(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => BlocProvider<EdittaskCubit>(
                create: (context) => EdittaskCubit(
                    TaskEntity(), context.read<Repository<TaskEntity>>()),
                child: EditTaskScreen(),
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
      body: BlocProvider<TasklistBloc>(
        create: (context) =>
            TasklistBloc(context.read<Repository<TaskEntity>>()),
        child: SafeArea(
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
                        child: Builder(builder: (context) {
                          return TextField(
                            onChanged: (value) {
                              context
                                  .read<TasklistBloc>()
                                  .add(TaskListSearch(value));
                              // searchKeywordNotifier.value = controller.text;
                            },
                            controller: controller,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(CupertinoIcons.search),
                              label: Text('Search Tasks...'),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(child: Consumer<Repository<TaskEntity>>(
                      builder: (context, model, child) {
                context.read<TasklistBloc>().add(TaskListStarted());
                return BlocBuilder<TasklistBloc, TasklistState>(
                  builder: (context, state) {
                    if (state is TaskListSuccess) {
                      return TaskList(items: state.items, themeData: themeData);
                    } else if (state is TaskListEmpty) {
                      return const EmptyState();
                    } else if (state is TaskListLoading ||
                        state is TasklistInitial) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is TaskListError) {
                      return Center(
                        child: Text(state.errorMessage),
                      );
                    } else {
                      throw Exception('state is not valid');
                    }
                  },
                );
              })
                  // ValueListenableBuilder<String>(
                  //   valueListenable: searchKeywordNotifier,
                  //   builder: (context, value, child) {
                  // final repository =
                  //     Provider.of<Repository<TaskEntity>>(context);

                  // return Consumer<Repository<TaskEntity>>(
                  //     builder: (context, repository, child) {
                  //   return FutureBuilder<List<TaskEntity>>(
                  //     future: repository.getAll(searchKeyword: controller.text),
                  //     builder: (context, snapshot) {
                  //       if (snapshot.hasData) {
                  //         if (snapshot.data!.isNotEmpty) {
                  //           return TaskList(
                  //               items: snapshot.data!, themeData: themeData);
                  //         } else {
                  //           return const EmptyState();
                  //         }
                  //       } else {
                  //         return const CircularProgressIndicator();
                  //       }
                  //     },
                  //   );
                  // });

                  // if (controller.text.isEmpty) {
                  // final Repository<TaskEntity>  items = repository.getAll(searchKeyword: controller.text);
                  // } else {
                  //   items = box.values
                  //       .where((task) => task.name.contains(controller.text))
                  //       .toList();
                  // }

                  // if (items.isNotEmpty) {
                  //   return TaskList(items: items, themeData: themeData);
                  // } else {
                  //   return const EmptyState();
                  // }
                  //   },
                  // ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

class TaskList extends StatelessWidget {
  const TaskList({
    Key? key,
    required this.items,
    required this.themeData,
  }) : super(key: key);

  final List<TaskEntity> items;
  final ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        itemCount: items.length + 1,
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
                  onPressed: () {
                    context.read<TasklistBloc>().add(TaskListDeleteAll());

                    // final taskrepository = Provider.of<Repository<TaskEntity>>(
                    //     context,
                    //     listen: false
                    //     );
                    // taskrepository.deleteAll();
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
            builder: (context) => BlocProvider<EdittaskCubit>(
              create: (context) => EdittaskCubit(
                  widget.task, context.read<Repository<TaskEntity>>()),
              child: EditTaskScreen(),
            ),
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
            const SizedBox(
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
            const SizedBox(
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
