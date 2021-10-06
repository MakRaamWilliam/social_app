import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
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

class EditProfile extends StatelessWidget{

  late SocialUserData userData;
  EditProfile({
    required this.userData
});

  @override
  Widget build(BuildContext context) {

    var nameController = TextEditingController();
    var bioController = TextEditingController();
    var formkeys = GlobalKey<FormState>();

    nameController.text = userData.name;
    bioController.text = userData.bio??"Bio";

    return BlocConsumer<SocialCubit,SocialStates>(
      listener: (context,state){
        if(state is SocialUpdateProfileSuccess){
          defaultToast(msg: "Update Success",color: Colors.green);
        }
      },
      builder: (context,state){
        SocialCubit cubit = SocialCubit.getInstance(context);

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: (){
                cubit.profileImage = null;
                NavgPushToAndFinish(context, SocialLayout());
              },
            ),
            title: const Text("Editing Profile"),
            actions: [
              TextButton(
                  onPressed: (){
                    if(formkeys.currentState!.validate() ) {
                      cubit.updateProfileData(
                          name: nameController.text,
                          bio: bioController.text
                      );
                    }
                  },
                  child: const Text("Update")
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Form(
                key: formkeys,
                child: Column(
                  children: [
                    Container(
                      height: 190.0,
                      child: Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              Align(
                                child: Container(
                                  height: 150.0,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(
                                        4.0,
                                      ),
                                      topRight: Radius.circular(
                                        4.0,
                                      ),
                                    ),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        CoverImg,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                alignment: AlignmentDirectional.topCenter,
                              ),
                              CircleAvatar(
                                radius: 20.0,
                                child: IconButton(
                                  onPressed: (){},
                                  icon: const Icon(Icons.camera_alt_outlined),
                                ),
                              ),

                            ],
                          ),
                          Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              CircleAvatar(
                                radius: 60.0,
                                backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                                child: Conditional.single(
                                  context: context,
                                  conditionBuilder: (context)=> cubit.profileImage != null,
                                  widgetBuilder: (context)=> CircleAvatar(
                                      radius: 60.0,
                                      backgroundImage: FileImage((cubit.profileImage!))

                                  ),
                                  fallbackBuilder: (context)=>
                                      CircleAvatar(
                                      radius: 60.0,
                                      backgroundImage:  NetworkImage(
                                        userData.image??ProfImg,
                                      ),

                                  ),
                                ),
                              ),
                              CircleAvatar(
                                child: IconButton(
                                  onPressed: (){
                                    cubit.ChangeProfileImage();
                                  },
                                  icon: Icon(Icons.camera_alt_outlined),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10,),
                    defaultFormField(
                        controller: nameController,
                        type: TextInputType.text,
                        validText: "name can not be empty",
                        label: "name",
                      prefix: (Icons.supervised_user_circle),
                    ),
                    const SizedBox(height: 10,),
                    defaultFormField(
                        controller: bioController,
                        type: TextInputType.text,
                        validText: "Bio can not be empty",
                        label: "Bio",
                      prefix: Icons.text_format_outlined,
                    ),

                  ],
                ),
              ),
            ),
          ),
        );
      },
    );


  }


}