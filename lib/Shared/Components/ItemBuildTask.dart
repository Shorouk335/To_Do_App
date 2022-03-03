
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/Shared/Network/bloc/cubit.dart';

Widget ItemBuildTask(List<Map> model, context , String type) {
 return ConditionalBuilder(
   condition: model.isEmpty,
    builder: (context)=>Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.menu,
            color: Colors.blue,
            size: 80,
          ),
          Text(
            "No Tasks Yet ,Please Enter Tasks",
            style: TextStyle(
              color: Colors.black54,
              fontSize: 15.0,
            ),
          ),
        ],
      ),
    ),
    fallback:(context)=> ListView.separated(
     itemBuilder: (context, index) {
   return Dismissible(
     key: ValueKey(model[index]['id'].toString()),
     onDismissed: (direction) {
       AppCubit.get(context).DeleteFromDataBase(id: model[index]['id']);
      if (type == "news")
        AppCubit.get(context).newtasks.removeAt(index);
      else if (type == "done")
        AppCubit.get(context).Donetasks.removeAt(index);
      else
        AppCubit.get(context).Archivedtasks.removeAt(index);
     },
     child: Padding(
       padding: const EdgeInsets.all(8.0),
       child: Row(
         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
         children: [
           CircleAvatar(
             radius: 35,
             child: Text("${model[index]["time"]}"),
           ),
           SizedBox(
             width: 20,
           ),
           Expanded(
             child: Column(
               children: [
                 Text(
                   "${model[index]["title"]}",
                   style: TextStyle(
                     fontSize: 18,
                   ),
                 ),
                 Text(
                   "${model[index]["date"]}",
                   style: TextStyle(
                     color: Colors.grey,
                   ),
                 ),
               ],
             ),
           ),
           (model == AppCubit.get(context).newtasks)
               ? (Row(
             children: [
               SizedBox(
                 width: 20,
               ),
               IconButton(
                   onPressed: () {
                     AppCubit.get(context).UpDateDataBase(
                         status: "Done",
                         id: AppCubit.get(context).newtasks[index]
                         ["id"]);
                   },
                   icon: Icon(
                     Icons.check_box,
                     color: Colors.green,
                     size: 25.0,
                   )),
               IconButton(
                   onPressed: () {
                     AppCubit.get(context).UpDateDataBase(
                         status: "Archived",
                         id: AppCubit.get(context).newtasks[index]
                         ["id"]);
                   },
                   icon: Icon(
                     Icons.archive_outlined,
                     color: Colors.black45,
                     size: 25.0,
                   )),
             ],
           ))
               : (SizedBox()),
         ],
       ),
     ),
   );
 },
  separatorBuilder: (context, index) {
  return SizedBox(
  width: double.infinity,
  child: Divider(
  thickness: 1,
  color: Colors.grey,
  ),
  );
  },
  itemCount: model.length,
  ),

  );
}
