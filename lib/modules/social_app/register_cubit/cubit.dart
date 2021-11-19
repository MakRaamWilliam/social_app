
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/social_app/user_data.dart';
import 'package:social_app/modules/social_app/register_cubit/states.dart';
import 'package:social_app/shared/components/constans.dart';

class SocialRegisterCubit extends Cubit<SocialRegistersStates> {
  SocialRegisterCubit() : super(SocialRegisterInitialState());

  static SocialRegisterCubit getInstance(context) => BlocProvider.of(context);

  bool isPasswordSecure = true;
  String mess="";

  void ChangePasswrodSecure(){
    isPasswordSecure = !isPasswordSecure;
    emit(SocialChangePasswordVisibilityState());
  }

  void RegisterClick({
    required String name,
    required String phone,
    required String email,
    required String password,
   }){
    emit(SocialRegisterLoadingState());
   FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password
        ).then((value) {
           Uid = value.user!.uid;
           print(value.user!.email);
           print(value.user!.uid);
           saveUSerData(uid: value.user!.uid,
               name: name,
               phone: phone,
               email: email);
           FirebaseMessaging.instance.subscribeToTopic(Uid);
           emit(SocialRegisterSuccessState());
   }).catchError((error){
           emit(SocialRegisterErrorState(error.toString()));
           print(error.toString());
         });


    }
  late SocialUserData userData;
  void saveUSerData({
    required String uid,
    required String name,
    required String phone,
    required String email,
  }){
    userData = SocialUserData( name: name, email: email, phone: phone);

    FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .set(userData.getUserData());

  }

}