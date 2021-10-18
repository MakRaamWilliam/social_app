import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_app/layout/social_app/social_app_layout.dart';
import 'package:social_app/modules/Social_app/register_screen.dart';
import 'package:social_app/shared/components/components.dart';

import 'log_in_cubit/cubit.dart';
import 'log_in_cubit/states.dart';

class SocialLogInScreen extends StatelessWidget{
  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  var formkeys = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context)=> SocialLoginCubit(),

      child: BlocConsumer<SocialLoginCubit,SocialLoginStates>(
        listener: (context,state){
          SocialLoginCubit cubit = SocialLoginCubit.getInstance(context);
          if(state is SocialLoginSuccessState){
              defaultToast(msg: "log in successful ",
                color: Colors.green,
              );
              NavgPushToAndFinish(context, SocialLayout());

            }else if(state is SocialLoginErrorState) {
              defaultToast(
                msg: cubit.errorMsg,
                color: Colors.red,
                length: Toast.LENGTH_LONG,
              );
          }
        },
        builder: (context,state){
          SocialLoginCubit cubit = SocialLoginCubit.getInstance(context);
            return Scaffold(
              body: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [Colors.blueGrey, Colors.lightBlueAccent]),
                ),
                child: ListView(
                  children:<Widget>[
                  Form(
                    key: formkeys,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            verticalText(),
                            textLogin(),
                          ],
                        ),
                        // Image.network(
                        //   "https://d1yjjnpx0p53s8.cloudfront.net/styles/logo-thumbnail/s3/0015/7587/brand.gif?itok=CbbOOGEv",
                        //   width: 200.0,
                        //   height: 150.0,
                        // ),
                        const SizedBox(
                          height: 40.0,
                        ),
                        defaultFormField(
                          type:TextInputType.emailAddress ,
                          controller: emailController,
                          validText:  "Email can not be empty",
                          label: "Email Address" ,
                          prefix: Icons.email,
                          border: false,
                          ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        defaultFormField(
                          controller: passwordController,
                          prefix: Icons.security,
                          border: false,
                          type: TextInputType.visiblePassword,
                          isPassword: cubit.isPasswordSecure,
                          validText: "Password can not be empty",
                          label: "Password",
                          suffixPressed: cubit.ChangePasswrodSecure,
                          suffix:  cubit.isPasswordSecure ?
                          Icons.remove_red_eye:
                          Icons.remove_red_eye_outlined ,
                          onSubmit: (value){
                            if(formkeys.currentState!.validate()) {
                              print("Email: " + emailController.text);
                              print("Password:" + passwordController.text);
                              SocialLoginCubit.getInstance(context).loginClick(
                                  email: emailController.text,
                                  password: passwordController.text
                              );
                            }

                          }
                        ),
                        const SizedBox(
                          height: 40.0,
                        ),
                        Conditional.single(
                          context: context,
                          conditionBuilder: (context)=> state is! SocialLoginLoadingState,
                          widgetBuilder: (context)=>
                           defaultButton(
                            text: "Log In",
                            onPressed: (){
                              if(formkeys.currentState!.validate()) {
                                print("Email: " + emailController.text);
                                print("Password:" + passwordController.text);
                                SocialLoginCubit.getInstance(context).loginClick(
                                    email: emailController.text,
                                    password: passwordController.text
                                );
                             }
                            },
                          ),
                          fallbackBuilder: (context)=> const Center(child: CircularProgressIndicator())
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              const Text(
                                "don't have an account ",

                              ),
                              TextButton(onPressed: (){
                                NavgPushTo(context, RegistrationScreen());
                              },
                                  child: const Text(
                                      "Register Now"
                                  ))

                            ],
                          ),
                        )
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