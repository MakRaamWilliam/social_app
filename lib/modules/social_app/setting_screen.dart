import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/social_app/cubit/cubit.dart';
import 'package:social_app/layout/social_app/cubit/states.dart';
import 'package:social_app/modules/social_app/social_log_in.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:bloc/bloc.dart';

class SocialSetting extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return BlocConsumer<SocialCubit,SocialStates>(
      listener: (context,state){},
      builder: (context,state){

        return  Column(
          children: [
            const Text("Setting"),
            TextButton(
                onPressed: () {
                  CacheHelper.removeData(key: "uid");
                  SocialCubit.getInstance(context).logOutClick();
                  NavgPushToAndFinish(context, SocialLogInScreen());
                },
                child: const Text("Log out")
            ),

          ],
        );
      },
    );

  }


}