import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_app/shared/bloc_observer.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constans.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:social_app/shared/network/remote/social_dio_helper.dart';
import 'package:social_app/shared/styles/themes.dart';

import 'layout/social_app/cubit/cubit.dart';
import 'layout/social_app/social_app_layout.dart';
import 'modules/social_app/social_log_in.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // var token = await FirebaseMessaging.instance.getToken();
  // print("token");
  // print(token);

  //foreground
  FirebaseMessaging.onMessage.listen((event) {
    defaultToast(
        msg: event.notification!.title??"message",
        length: Toast.LENGTH_LONG,
        color: Colors.deepOrange);
  });

  //when click
  // FirebaseMessaging.onMessageOpenedApp.listen((event) {
  //   print(event.data.toString());
  //   defaultToast(msg: "on Open Message");
  // });
  //when back ground
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);


  SocialDioHelper.init();
  await CacheHelper.init();
  Bloc.observer = MyBlocObserver();

  runApp(
      MyApp(),
  );
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return
      MultiBlocProvider(
        providers: [BlocProvider(create: (context) => AppCubit()),
          BlocProvider(create: (context) => SocialCubit()..getUSerData(),),
        ],
        child: BlocConsumer< AppCubit, AppStates>(
            listener: (context,state) {},
            builder: (context, state) {
              late Widget widget;
              String?  uid = CacheHelper.getString(key: "uid");
              if(uid == null ){
                widget = SocialLogInScreen();
              }else{
                Uid = uid;
                widget = SocialLayout();
              }

              return  MaterialApp(
                  debugShowCheckedModeBanner: false,
                home: Directionality
                  (
                    textDirection: TextDirection.ltr,
                    child: widget
                ),
                theme: lightTheme,
                darkTheme: darkTheme,
                themeMode: ThemeMode.dark,
                // dark ? ThemeMode.dark : ThemeMode.light ,
              );
            }
        ),
      );

  }

}
