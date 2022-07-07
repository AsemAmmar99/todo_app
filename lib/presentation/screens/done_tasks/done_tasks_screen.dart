import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../business_logic/cubit/cubit.dart';
import '../../../../business_logic/cubit/states.dart';
import '../../views/task_builder.dart';

class DoneTasksScreen extends StatelessWidget {
  const DoneTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state){},
      builder: (context, state){

        var tasks = AppCubit.get(context).doneTasks;

        return TaskBuilder(tasks: tasks, noTasks: 'No Done Tasks Yet..', taskType: 'done');
      },
    );
  }
}
