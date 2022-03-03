
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/Shared/Components/ItemBuildTask.dart';
import 'package:to_do_app/Shared/Network/bloc/cubit.dart';
import 'package:to_do_app/Shared/Network/bloc/states.dart';
class Tasks extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit ,AppStates>(
      listener: (context ,state){},
      builder: (context ,state){
        AppCubit cubit = AppCubit.get(context);
        return ItemBuildTask(cubit.newtasks ,context ,"news");
      }
    );
  }
}
