import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:social_app/modules/social_app/register_cubit/cubit.dart';
import 'package:social_app/modules/social_app/register_cubit/states.dart';
import 'package:social_app/modules/social_app/social_log_in.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constans.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';

class RegistrationScreen extends StatelessWidget{

  var emailController = TextEditingController();
  var passwordController1 = TextEditingController();
  var passwordController2 = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();

  var formkeys = GlobalKey<FormState>();

  bool isPasswordSecure = true;

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context)=> SocialRegisterCubit(),

      child: BlocConsumer<SocialRegisterCubit,SocialRegistersStates>(
        listener: (context,state){
          SocialRegisterCubit cubit = SocialRegisterCubit.getInstance(context);
          if(state is SocialRegisterSuccessState){
             defaultToast(msg: "successful",
               color:  Colors.green,
             );
             CacheHelper.putString(key: "uid",value: Uid );
             NavgPushTo(context, SocialLogInScreen());
          }else if(state is SocialRegisterErrorState){
              defaultToast(
                msg: cubit.mess,
                color: Colors.red,
              );
          }
        },
        builder: (context,state){
          SocialRegisterCubit cubit = SocialRegisterCubit.getInstance(context);
          return Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Colors.blueGrey, Colors.lightBlueAccent]),
              ),
              child: ListView(
                children: <Widget>[
                Form(
                  key: formkeys,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          singUpText(),
                          verticalNew(),
                        ],
                      ),
                      defaultFormField(
                        controller: nameController,
                        type: TextInputType.text,
                        label: "Name",
                        validText: "name can not be empty",
                        prefix: Icons.edit,
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),

                      defaultFormField(
                        controller: phoneController,
                        type: TextInputType.phone,
                        label: "Phone",
                        validText: "phone can not be empty",
                        prefix: Icons.phone,
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      defaultFormField(
                        controller: emailController,
                        type: TextInputType.emailAddress,
                        label: "Email Address",
                        validText: "Email can not be empty",
                        prefix: Icons.email,
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      defaultFormField(
                        controller: passwordController1,
                        type: TextInputType.visiblePassword,
                        label: "Password",
                        validText: "Password can not be empty",
                        prefix: Icons.security,
                        suffixPressed: cubit.ChangePasswrodSecure,
                        suffix: cubit.isPasswordSecure ?
                        Icons.remove_red_eye:
                        Icons.remove_red_eye_outlined ,
                        isPassword: cubit.isPasswordSecure,
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      defaultFormField(
                        controller: passwordController2,
                        type: TextInputType.visiblePassword,
                        label: "Confirm Password",
                        validText: "Password can not be empty",
                        prefix: Icons.security,
                        suffixPressed: cubit.ChangePasswrodSecure,
                        suffix: cubit.isPasswordSecure ?
                        Icons.remove_red_eye:
                        Icons.remove_red_eye_outlined ,
                        isPassword: cubit.isPasswordSecure,
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Conditional.single(
                          context: context,
                          conditionBuilder: (context)=> state is! SocialRegisterLoadingState,
                          widgetBuilder: (context)=>
                              defaultButton(
                                text: "Register",
                                onPressed: (){
                                  if(formkeys.currentState!.validate() &&
                                      passwordController1.text == passwordController2.text ) {
                                    print("Email: " + emailController.text);
                                    print("Password:" + passwordController1.text);
                                    cubit.RegisterClick(
                                         name: nameController.text,
                                         phone: phoneController.text,
                                         email: emailController.text,
                                         password: passwordController1.text
                                    );
                                  }
                                },
                              ),
                          fallbackBuilder: (context)=> const Center(child: CircularProgressIndicator())
                      ),
                    ],
                  ),
                ),
              ]
              ),
            ),
          );
        },
      ),
    );
  }

}