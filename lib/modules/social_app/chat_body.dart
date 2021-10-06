import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:social_app/layout/social_app/cubit/cubit.dart';
import 'package:social_app/layout/social_app/cubit/states.dart';
import 'package:social_app/models/social_app/message_data.dart';
import 'package:social_app/models/social_app/user_data.dart';
import 'package:social_app/shared/components/constans.dart';
import 'package:social_app/shared/network/remote/social_dio_helper.dart';
import 'package:social_app/shared/styles/colors.dart';

class ChatBody extends StatelessWidget{

  late SocialUserData user;
  late String userId;

  ChatBody({
    required this.user,
    required this.userId,
  });
  var messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Builder(
      builder: (context) {
        SocialCubit.getInstance(context).getAllMessages(receiverId: userId);
        return BlocConsumer<SocialCubit, SocialStates>(
            listener: (context, state) {},
            builder: (context, state) {
               SocialCubit cubit = SocialCubit.getInstance(context);

               return Scaffold(
                 appBar: AppBar(
                   titleSpacing: 0.0,
                   title: Row(
                     children: [
                       CircleAvatar(
                         radius: 20.0,
                         backgroundImage: NetworkImage(
                           user.image??ProfImg,
                         ),
                       ),
                       const SizedBox(
                         width: 15.0,
                       ),
                       Text(
                         user.name,
                       ),
                     ],
                   ),
                 ),
                 body: Conditional.single(
                     context: context,
                     conditionBuilder: (context) => true ,
                     widgetBuilder: (context) =>  Padding(
                       padding: const EdgeInsets.all(20.0),
                       child: Column(
                         children: [
                           Expanded(
                             child: ListView.separated(
                               physics: BouncingScrollPhysics(),
                               itemBuilder: (context, index)
                               {
                                 var message = cubit.messages[index];

                                 if(Uid == message.senderId) {
                                   return buildMyMessage(message,context);
                                 } else {
                                   return buildMessage(message,context);
                                 }
                               },
                               separatorBuilder: (context, index) => const SizedBox(
                                 height: 15.0,
                               ),
                               itemCount: cubit.messages.length,
                             ),
                           ),
                           Container(
                             decoration: BoxDecoration(
                               border: Border.all(
                                 color: Colors.grey,
                                 width: 1.0,
                               ),
                               borderRadius: BorderRadius.circular(
                                 15.0,
                               ),
                             ),
                             clipBehavior: Clip.antiAliasWithSaveLayer,
                             child: Row(
                               children: [
                                 Expanded(
                                   child: Padding(
                                     padding: const EdgeInsets.symmetric(
                                       horizontal: 15.0,
                                     ),
                                     child: TextFormField(
                                       controller: messageController,
                                       decoration: const InputDecoration(
                                         border: InputBorder.none,
                                         hintText: 'type your message here ...',
                                       ),
                                     ),
                                   ),
                                 ),
                                 if(cubit.messImage == null)
                                   Container(
                                   height: 50.0,
                                   color: defaultColor,
                                   child: MaterialButton(
                                     onPressed: () {
                                       cubit.UploadMessImage();
                                     },
                                     minWidth: 1.0,
                                     child: const Icon(
                                       Icons.image,
                                       size: 16.0,
                                       color: Colors.white,
                                     ),
                                   ),
                                 ),
                                 if(cubit.messImage != null)
                                   Container(
                                     height: 50.0,
                                     color: defaultColor,
                                     child: Image(
                                       image: FileImage(cubit.messImage!),
                                     ),
                                   ),

                                 Container(
                                   height: 50.0,
                                   color: defaultColor,
                                   child: MaterialButton(
                                     onPressed: () {
                                       if(cubit.messImage == null) {
                                         cubit.sendMessage(
                                           receiverId: userId,
                                           dateTime: DateTime.now().toString(),
                                           mess: messageController.text,
                                         );
                                       }else{
                                         cubit.sendImageMessage(
                                           receiverId: userId,
                                           dateTime: DateTime.now().toString(),
                                           mess: messageController.text,
                                         );

                                       }
                                       cubit.messImage = null;
                                       SocialDioHelper.postData(
                                           data: {
                                             "to":"/topics/$userId",
                                             "notification":{
                                               "body":messageController.text,
                                               "title":userData.name
                                             }
                                           });
                                       messageController.text = "";

                                     },
                                     minWidth: 1.0,
                                     child: const Icon(
                                       Icons.send,
                                       size: 16.0,
                                       color: Colors.white,
                                     ),
                                   ),
                                 ),
                               ],
                             ),
                           ),
                         ],
                       ),
                     ),
                     fallbackBuilder: (context) => const Center(child: CircularProgressIndicator()),
                 ),
               );
           }
        );
      }
    );
  }

  Widget buildMessage(SocialMessageData model,context) => Align(
    alignment: AlignmentDirectional.centerStart,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: const BorderRadiusDirectional.only(
          bottomEnd: Radius.circular(
            10.0,
          ),
          topStart: Radius.circular(
            10.0,
          ),
          topEnd: Radius.circular(
            10.0,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 10.0,
      ),
      child: Column(
        children: [
          Text(
            model.text,
            style: Theme.of(context).textTheme.subtitle1

          ),
          if(model.image != null)
            Image.network(
              model.image??"",
            )
        ],
      ),
    ),
  );

  Widget buildMyMessage(SocialMessageData model,context) => Align(
    alignment: AlignmentDirectional.centerEnd,
    child: Container(
      decoration: BoxDecoration(
        color: defaultColor.withOpacity(
          .2,
        ),
        borderRadius: const BorderRadiusDirectional.only(
          bottomStart: Radius.circular(
            10.0,
          ),
          topStart: Radius.circular(
            10.0,
          ),
          topEnd: Radius.circular(
            10.0,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 10.0,
      ),
      child: Column(
        children: [
          Text(
            model.text,
            style: Theme.of(context).textTheme.subtitle1

          ),
          if(model.image != null)
            Image.network(
              model.image??"",
            )

        ],
      ),
    ),
  );


}