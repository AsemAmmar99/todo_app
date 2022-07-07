import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:todo_app/presentation/widgets/default_text.dart';

import '../../business_logic/cubit/cubit.dart';
import '../styles/colors.dart';

class DoneTaskItem extends StatelessWidget {
  DoneTaskItem({Key? key, required this.model}) : super(key: key);

  Map model;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(model['id'].toString()),
      child: Padding(

        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),

        child: Row(

          children: [

            CircleAvatar(

              radius: 35.0,
              backgroundColor: darkBlue,

              child: DefaultText(
                text: '${model['time']}',
                fontSize: 12.sp,
                color: lightBlue,
              ),
            ),

            Expanded(
              child: Column(

                mainAxisSize: MainAxisSize.min,

                children: [
                  Flexible(
                    child: DefaultText(
                      text: '${model['title']}',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Flexible(
                    child: DefaultText(
                      text: '${model['date']}',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: gray!,
                    ),
                  ),
                ],
              ),
            ),

            IconButton(onPressed: (){

              AppCubit.get(context).updateData(

                status: 'archived',

                id: model['id'],

              );},

              icon: const Icon(

                Icons.archive,

                color: black,

              ),

            ),

          ],

        ),

      ),
      onDismissed: (direction){
        AppCubit.get(context).deleteData(id: model['id'],);
      },
    );
  }
}
