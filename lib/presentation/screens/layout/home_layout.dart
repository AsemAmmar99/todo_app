import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:todo_app/presentation/widgets/default_text.dart';
import '../../../business_logic/cubit/cubit.dart';
import '../../../business_logic/cubit/states.dart';
import '../../styles/colors.dart';
import '../../widgets/default_form_field.dart';

class HomeLayout extends StatelessWidget {

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {
          if(state is AppInsertDBState){
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, AppStates state) {

          AppCubit cubit = AppCubit.get(context);

          return Scaffold(
            backgroundColor: lightBlue,
            key: scaffoldKey,
            appBar: AppBar(
                backgroundColor: darkBlue,
                title: Center(
                  child: DefaultText(
                    text: cubit.titles[cubit.currentIndex],
                    color: lightBlue,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                )
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetDBLoadingState,
              builder: (BuildContext context) => cubit.screens[cubit.currentIndex],
              fallback: (context) => const Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: darkBlue,
              onPressed: (){
                if(cubit.isBottomSheetShown){
                  if(formKey.currentState!.validate()) {
                    cubit.insertToDatabase(title: titleController.text, time: timeController.text, date: dateController.text,);
                  }
                }else {
                  scaffoldKey.currentState!.showBottomSheet((context) =>
                      Container(
                        color: darkBlue,
                        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DefaultFormField(
                                controller: titleController,
                                keyboardType: TextInputType.text,
                                validator: (value){
                                  if(value!.isEmpty){
                                    return 'Title must not be empty';
                                  }
                                  return null;
                                },
                                labelText: 'Task Title',
                                textColor: white,
                                prefixIcon: const Icon(Icons.title_outlined, color: lightBlue,),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 2.h),
                                child: DefaultFormField(
                                  controller: timeController,
                                  onTap: (){
                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    ).then((value) {
                                      timeController.text = value!.format(context).toString();
                                    });
                                  },
                                  validator: (value){
                                    if(value!.isEmpty){
                                      return 'Time must not be empty';
                                    }
                                    return null;
                                  },
                                  labelText: 'Task Time',
                                  textColor: white,
                                  prefixIcon: const Icon(Icons.timer, color: lightBlue,),
                                  keyboardType: TextInputType.datetime,
                                ),
                              ),
                              DefaultFormField(
                                controller: dateController,
                                keyboardType: TextInputType.datetime,
                                onTap: (){
                                  showDatePicker(context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.parse('2024-01-07'),
                                  ).then((value) {
                                    dateController.text = DateFormat.yMMMd().format(value!).toString();
                                  });
                                },
                                validator: (value){
                                  if(value!.isEmpty){
                                    return 'Date must not be empty';
                                  }
                                  return null;
                                },
                                labelText: 'Task Date',
                                textColor: white,
                                prefixIcon: const Icon(Icons.date_range_outlined, color: lightBlue,),
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
              child: Icon(cubit.fabIcon, color: lightBlue,),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              onTap: (index){
                cubit.changeIndex(index);
              },
              type: BottomNavigationBarType.fixed,
              backgroundColor: darkBlue,
              selectedItemColor: blue,
              unselectedItemColor: lightBlue,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.menu,
                  ),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.check_circle_outline,
                  ),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.archive_outlined,
                  ),
                  label: 'Archived',
                ),
              ],
            ),
          );
        },
      );
  }
}
