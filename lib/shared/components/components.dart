import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/shared/cubit/cubit.dart';

Widget defaultButton({
  required double width,
  required Color background,
  required void Function() function,
  required String text,
}) => Container(
  width: width,
  color: background,
  child: MaterialButton(onPressed: function,
    child: Text(
      text.toUpperCase(),
      style: const TextStyle(
        color: Colors.white,
      ),
    ),),
);

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  void Function(String)? onSubmit,
  void Function(String)? onChange,
  void Function()? onTap,
  bool isPassword = false,
  required String? Function(String?) validate,
  required String label,
  required IconData prefix,
  IconData? suffix,
  void Function()? suffixPressed,
  bool isClickable = true,
}) => TextFormField(
  controller: controller,
  keyboardType: type,
  onFieldSubmitted: onSubmit,
  onChanged: onChange,
  onTap: onTap,
  enabled: isClickable,
  validator: validate,
  obscureText: isPassword,
  decoration: InputDecoration(
    labelText: label,
    prefixIcon: Icon(prefix,),
    suffixIcon: suffix != null ? IconButton(
        onPressed: suffixPressed,
    icon: Icon(suffix,)) : null,
    border: const OutlineInputBorder(),
  ),
);

Widget taskItem(Map model, context) => Dismissible(
  key: Key(model['id'].toString()),
  child: Padding(
  
    padding: const EdgeInsets.all(15.0),
  
    child: Row(
  
      children: [
  
        CircleAvatar(
  
          radius: 35.0,
  
          backgroundColor: Colors.indigo[900],
  
          child: Text(
  
            '${model['time']}',
  
            style: const TextStyle(
  
              fontSize: 14.0,
  
            ),
  
          ),
  
        ),
  
        const SizedBox(
  
          width: 15.0,
  
        ),
  
        Expanded(
  
          child: Column(
  
            mainAxisSize: MainAxisSize.min,
  
            children: [
  
              Text(
  
                '${model['title']}',
  
                style: const TextStyle(
  
                  fontSize: 16.0,
  
                  fontWeight: FontWeight.bold,
  
                ),
  
              ),
  
              const SizedBox(
  
                width: 10.0,
  
              ),
  
              Text(
  
                '${model['date']}',
  
                style: TextStyle(
  
                    fontSize: 14.0,
  
                    fontWeight: FontWeight.bold,
  
                    color: Colors.grey[600]
  
                ),
  
              ),
  
  
  
            ],
  
          ),
  
        ),
  
        const SizedBox(
  
          width: 15.0,
  
        ),
  
        IconButton(onPressed: (){
  
          AppCubit.get(context).updateData(
  
            status: 'done',
  
            id: model['id'],
  
          );},
  
          icon: Icon(
  
            Icons.check_circle,
  
            color: Colors.indigo[900],
  
          ),
  
        ),
  
        IconButton(onPressed: (){
  
          AppCubit.get(context).updateData(
  
            status: 'archived',
  
            id: model['id'],
  
          );},
  
          icon: const Icon(
  
            Icons.archive,
  
            color: Colors.blue,
  
          ),
  
        ),
  
      ],
  
    ),
  
  ),
  onDismissed: (direction){
    AppCubit.get(context).deleteData(id: model['id'],);
  },
);

Widget taskBuilder({
  required List<Map> tasks,
  required String no,
}) => ConditionalBuilder(
  condition: tasks.isNotEmpty,
  builder: (context) =>  ListView.separated(
    itemBuilder: (context, index) => taskItem(tasks[index], context),
    separatorBuilder: (context, index) => Container(
      width: double.infinity,
      height: 1.0,
      color: Colors.grey[300],
    ),
    itemCount: tasks.length,
  ),
  fallback: (context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.menu,
          size: 75.0,
          color: Colors.indigo[800],
        ),
        Text(
          no,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15.0,
            color: Colors.indigo[800],
          ),
        ),
      ],
    ),
  ),
);