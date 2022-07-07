import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todo_app/modules/done_tasks/done_tasks_screen.dart';
import 'package:todo_app/modules/new_tasks/new_tasks_screen.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/components/constants.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {
          if(state is AppInsertDBState){
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, AppStates state) {

          AppCubit cubit = AppCubit.get(context);

          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
                backgroundColor: Colors.indigo[900],
                title: Text(
                  cubit.titles[cubit.currentIndex],
                )
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetDBLoadingState,
              builder: (BuildContext context) => cubit.screens[cubit.currentIndex],
              fallback: (context) => const Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.indigo[800],
              onPressed: (){
                if(cubit.isBottomSheetShown){
                  if(formKey.currentState!.validate()) {
                    cubit.insertToDatabase(title: titleController.text, time: timeController.text, date: dateController.text,);
                    // insertToDatabase(date: dateController.text,
                    //   title: titleController.text,
                    //   time: timeController.text,
                    // ).then((value) {
                    //   getDataFromDatabase(database).then((value) {
                    //     Navigator.pop(context);
                    //     // setState(() {
                    //     //   isBottomSheetShown = false;
                    //     //   fabIcon = Icons.edit;
                    //     //   tasks = value;
                    //     // });
                    //   });
                    // });
                  }
                }else {
                  scaffoldKey.currentState!.showBottomSheet((context) =>
                      Container(
                        color: Colors.indigo[900],
                        padding: const EdgeInsets.all(15.0),
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              defaultFormField(
                                controller: titleController,
                                type: TextInputType.text,
                                validate: (String? value){
                                  if(value!.isEmpty){
                                    return 'Title must not be empty';
                                  }
                                  return null;
                                },
                                label: 'Task Title',
                                prefix: Icons.title_outlined,
                              ),
                              const SizedBox(height: 10.0,),
                              defaultFormField(
                                controller: timeController,
                                type: TextInputType.datetime,
                                onTap: (){
                                  showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  ).then((value) {
                                    timeController.text = value!.format(context).toString();
                                  });
                                },
                                validate: (String? value){
                                  if(value!.isEmpty){
                                    return 'Time must not be empty';
                                  }
                                  return null;
                                },
                                label: 'Task Time',
                                prefix: Icons.timer,
                              ),
                              const SizedBox(height: 10.0,),
                              defaultFormField(
                                controller: dateController,
                                type: TextInputType.datetime,
                                onTap: (){
                                  showDatePicker(context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.parse('2024-01-07'),
                                  ).then((value) {
                                    dateController.text = DateFormat.yMMMd().format(value!).toString();
                                  });
                                },
                                validate: (String? value){
                                  if(value!.isEmpty){
                                    return 'Date must not be empty';
                                  }
                                  return null;
                                },
                                label: 'Task Date',
                                prefix: Icons.date_range_outlined,
                              ),
                            ],
                          ),
                        ),
                      ),
                    elevation: 20.0,
                  ).closed.then((value) {
                    cubit.changeBSState(isShow: false, icon: Icons.edit,);
                  });
                  cubit.changeBSState(isShow: true, icon: Icons.add,);
                }
              },
              child: Icon(cubit.fabIcon,),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              onTap: (index){
                cubit.changeIndex(index);
              },
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.indigo[800],
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.check_circle_outline,
                    color: Colors.white,
                  ),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.archive_outlined,
                    color: Colors.white,
                  ),
                  label: 'Archived',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
