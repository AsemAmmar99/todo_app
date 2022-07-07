import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../styles/colors.dart';
import '../widgets/default_text.dart';
import 'archived_task_item.dart';
import 'done_task_item.dart';
import 'new_task_item.dart';

class TaskBuilder extends StatelessWidget {
  TaskBuilder({Key? key, required this.taskType, required this.noTasks, required this.tasks}) : super(key: key);

  List<Map> tasks;
  String noTasks;
  String taskType;


  @override
  Widget build(BuildContext context) {
    return ConditionalBuilder(
      condition: tasks.isNotEmpty,
      builder: (context) =>  ListView.separated(
        itemBuilder: (context, index) {
          if(taskType == 'new') {
            return NewTaskItem(model: tasks[index]);
          }else if(taskType == 'done') {
            return DoneTaskItem(model: tasks[index],);
          }else {
            return ArchivedTaskItem(model: tasks[index],);
          }
        },
        separatorBuilder: (context, index) => Row(
          children: [
            Expanded(child: Divider(height: 1.h, color: Colors.black45)),
          ],
        ),
        itemCount: tasks.length,
      ),
      fallback: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.menu,
              size: 75.0,
              color: darkBlue,
            ),
            Flexible(
              child: DefaultText(
                text: noTasks,
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
                color: darkBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
