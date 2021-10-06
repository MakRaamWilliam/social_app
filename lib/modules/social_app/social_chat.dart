import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:social_app/layout/social_app/cubit/cubit.dart';
import 'package:social_app/layout/social_app/cubit/states.dart';
import 'package:social_app/layout/social_app/social_app_layout.dart';
import 'package:social_app/models/social_app/user_data.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constans.dart';

import 'chat_body.dart';

class SocialChat extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          SocialCubit cubit = SocialCubit.getInstance(context);
          return Scaffold(
            appBar: AppBar(
              title: const Text("Chats"),
            ),
            body: Conditional.single(
              context: context,
              conditionBuilder:(context)=> state is SocialSuccessAllUserDataState,
              widgetBuilder:(context)=> ListView.separated(
                  itemBuilder:(context,index) =>  itemBuilder(
                    context: context,users: cubit.users,
                      index: index,usersId: cubit.usersId,
                  ),
                  separatorBuilder: (context,index) => myDivider(),
                  itemCount: cubit.users.length,
              ),
              fallbackBuilder: (context)=> Center(child: const CircularProgressIndicator())
            ),
          );
        }
    );
  }
  Widget itemBuilder({
  required context,
  required List<SocialUserData> users,
  required List<String> usersId,

    required int index,
}){

    return  InkWell(
      onTap: (){
        NavgPushTo(context, ChatBody(
            user: users[index], userId: usersId[index],),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 35.0,
              backgroundImage: NetworkImage(
                  users[index].image??ProfImg
              ),
            ),
            const SizedBox(
              width: 15.0,
            ),
            Expanded(
              child:  Text(
                users[index].name,
                style: Theme.of(context).textTheme.bodyText1
              ),
            ),
          ],
        ),
      ),
    );

  }
}