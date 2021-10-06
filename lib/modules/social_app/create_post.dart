import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:social_app/layout/social_app/cubit/cubit.dart';
import 'package:social_app/layout/social_app/cubit/states.dart';
import 'package:social_app/layout/social_app/social_app_layout.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constans.dart';

class SocialCreatePost extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    var textController = TextEditingController();
    return BlocConsumer<SocialCubit,SocialStates>(
      listener:(context,state){
        if(state is SocialUploadPostSuccess){
          defaultToast(msg: "post success",color: Colors.green);
          NavgPushToAndFinish(context, SocialLayout());
        }

      } ,
      builder: (context,state){
        SocialCubit cubit = SocialCubit.getInstance(context);
         return Scaffold(
           appBar: AppBar(
             leading: IconButton(
               onPressed: (){
                 NavgPushToAndFinish(context, SocialLayout());
               },
               icon: const Icon(Icons.arrow_back),
             ),
             actions: [
               TextButton(onPressed: (){
                 var now = DateTime.now();

                 if (cubit.postImage == null)
                 {
                   cubit.CraeteTextPost(
                     dateTime: now.toString(),
                     text: textController.text,
                   );
                 }else{
                   cubit.CreateImagePost(
                     dateTime: now.toString(),
                     text: textController.text,
                   );
                 }

               },
               child: const Text("Post")
               )
             ],
             title: const Text("Create Post"),
           ),
           body: Padding(
             padding: const EdgeInsets.all(20.0),
             child: Column(
               children: [
                 Row(
                   children: [
                     CircleAvatar(
                       radius: 25.0,
                       backgroundImage: NetworkImage(
                         userData.image??ProfImg
                       ),
                     ),
                     const SizedBox(
                       width: 15.0,
                     ),
                     Expanded(
                       child:  Text(
                         userData.name,
                         style: const TextStyle(
                           height: 1.4,
                         ),
                       ),
                     ),
                   ],
                 ),
                 const SizedBox(height: 15.0,),
                 Expanded(
                   child: SingleChildScrollView(
                     child: Column(
                       children: [
                         TextFormField(
                           controller: textController,
                           maxLines: 8,
                           decoration: const InputDecoration(
                             hintText: ("what is on your mind.."),
                             border: InputBorder.none,
                           ),
                         ),
                         Conditional.single(
                             context: context,
                             conditionBuilder: (context)=> cubit.postImage != null ,
                             widgetBuilder: (context)=> Image(image: FileImage(cubit.postImage!)),
                             fallbackBuilder: (context)=> const SizedBox(height: 0.0,)
                         ),
                       ],
                     ),
                   ),
                 ),
                 // Spacer(),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Expanded(
                       child: Conditional.single(
                         context: context,
                         conditionBuilder: (context)=>cubit.postImage ==null,
                         widgetBuilder: (context)=> TextButton(
                             onPressed: (){
                               cubit.UploadPostImage();
                             },
                             child: Row(
                               children: const [
                                 Icon(Icons.image),
                                 SizedBox(width: 10.0,),
                                 Text("add Photo")
                               ],
                             )
                         ),
                         fallbackBuilder: (context)=>  TextButton(
                             onPressed: (){
                               cubit.removePostImage();
                             },
                             child: Row(
                               children: const [
                                 Icon(Icons.highlight_remove_outlined),
                                 SizedBox(width: 10.0,),
                                 Text("remove Photo")
                               ],
                             )
                         ),

                       ),
                     ),
                     Expanded(
                       child: TextButton(
                           onPressed: (){

                           },
                           child: Row(
                             children: const [
                               Text("# tags")
                             ],
                           )
                       ),
                     ),

                   ],
                 ),

               ],
             ),
           ),
         );

       },
    );
  }


}