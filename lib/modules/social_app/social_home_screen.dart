
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:social_app/layout/social_app/cubit/cubit.dart';
import 'package:social_app/layout/social_app/cubit/states.dart';
import 'package:social_app/modules/social_app/social_log_in.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constans.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';

class SocialHomeScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) {

    SocialCubit cubit = SocialCubit.getInstance(context);

    return BlocConsumer<SocialCubit,SocialStates> (
      listener: (context,state)=> {},
      builder: (context, state) {
        return Conditional.single(
          context: context,
          conditionBuilder: (context) => state is SocialSuccessUserDataState,
          fallbackBuilder: (context) =>
              Center(child: const CircularProgressIndicator()),
          widgetBuilder: (context) =>
              Column(
                children: [
                  Conditional.single(
                      context: context,
                      conditionBuilder: (context) =>
                      FirebaseAuth.instance.currentUser!.emailVerified,
                      fallbackBuilder: (context) =>
                          TextButton(
                              onPressed: () {
                                FirebaseAuth.instance.currentUser!
                                    .sendEmailVerification();
                              },
                              child: const Text("verify email")),
                      widgetBuilder: (context) => const Text("it's verified")
                  ),
                  Text(userData.name),
                  Text(userData.phone),
                  Text(userData.email),
                  TextButton(
                      onPressed: () {
                        CacheHelper.removeData(key: "uid");
                        NavgPushToAndFinish(context, SocialLogInScreen());
                      },
                      child: const Text("Log out")
                  ),
                ],
              ),
        );
      }
    );
    }
  }


