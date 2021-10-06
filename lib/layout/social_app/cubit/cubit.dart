import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/social_app/cubit/states.dart';
import 'package:social_app/models/social_app/message_data.dart';
import 'package:social_app/models/social_app/user_data.dart';
import 'package:social_app/modules/social_app/create_post.dart';
import 'package:social_app/modules/social_app/feed_news.dart';
import 'package:social_app/modules/social_app/setting_screen.dart';
import 'package:social_app/modules/social_app/social_chat.dart';
import 'package:social_app/modules/social_app/users_screen.dart';
import 'package:social_app/shared/components/constans.dart';
import 'package:image_picker/image_picker.dart';

class SocialCubit extends Cubit<SocialStates>{
  SocialCubit() : super(SocialInitialState());

  static SocialCubit getInstance(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> bottomScreens = [
    FeedsScreen(),
    SocialChat(),
    SocialCreatePost(),
    SocialUserScreen(),
    SocialSetting()
  ];

  void changeBottom(int index) {
    currentIndex = index;
    emit(SocialChangeBottomNavState());
    if(index == 0) {
      getUSerData();
    }else if(index  == 1){
      getAllUSerData();
    }
  }

  void logOutClick(){
    close();
  }

  List posts = [];
  List postsId = [];
  List<int> postsLikes = [];
  List<bool> myLikes = [];
  List<int> postsComments =[];
  List<SocialUserData> users = [];
  List<String> usersId = [];
  var picker = ImagePicker();

  void getUSerData(){
     emit(SocialLoadingUserDataState());
     getPosts().then(
             (value)  {
               FirebaseFirestore.instance.collection("users")
                   .doc(Uid)
                   .get().then((value) {
                 userData = SocialUserData.fromJson(value.data()!);
               });
               emit(SocialSuccessUserDataState());
             }).catchError((error){
       emit(SocialErrorUserDataState());
       print(error.toString());
     });

 }

  void getAllUSerData(){
    emit(SocialLoadingAllUserDataState());
          FirebaseFirestore.instance.collection("users")
              .get()
              .then((value) {
                users = [];
                usersId = [];
                for(var doc in value.docs){
                  if(doc.id != Uid){
                    users.add( SocialUserData.fromJson(doc.data()));
                    usersId.add(doc.id);
                  }
                }
                // print(users);
                emit(SocialSuccessAllUserDataState());
          })
              .catchError((error){
                print(error.toString());
                emit(SocialErrorAllUserDataState());
          });

  }

  List<SocialMessageData> messages = [];

  void sendMessage({
   required String mess,
    required String dateTime,
    required String receiverId,
    String? image,
}){
    SocialMessageData messageData = SocialMessageData(
        senderId: Uid,
        receiverId: receiverId,
        text: mess, dateTime: dateTime,
        image: image
    );
    print(messageData.getMessageData().toString());
    FirebaseFirestore.instance
        .collection('users')
        .doc(Uid)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(messageData.getMessageData())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      emit(SocialSendMessageErrorState());
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(Uid)
        .collection('messages')
        .add(messageData.getMessageData())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      emit(SocialSendMessageErrorState());
    });

  }

  File? messImage;
  Future<void> UploadMessImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if(image != null){
      messImage = File(image.path);
      emit(SocialSendMessageImageSuccessState());
    }else{
      emit(SocialSendMessageImageErrorState());
    }

  }

  void sendImageMessage({
    required String mess,
    required String dateTime,
    required String receiverId,
  }){
    emit(SocialUploadImagePostLoading());
    firebase_storage.FirebaseStorage.instance.ref()
        .child("messages/${Uri.file(messImage!.path).pathSegments.last}")
        .putFile(messImage!)
        .then((value) {
      value.ref.getDownloadURL()
          .then((url) {
             sendMessage(mess: mess, dateTime: dateTime,
                 receiverId: receiverId,image: url );

      }).catchError((error){
        emit(SocialUploadImagePostError());
      });
    })
        .catchError((error){
      emit(SocialUploadImagePostError());
    });


  }


  void getAllMessages({
    required String receiverId,
  }) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(Uid)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages = [];

      event.docs.forEach((element) {
        messages.add(SocialMessageData.fromJson(element.data()));
      });

      emit(SocialGetMessagesSuccessState());
    });
  }


  Future<void> getPosts() async{
    postsLikes = [];
    postsId = [];
    posts = [];
    myLikes = [];
    postsComments = [];
    FirebaseFirestore.instance.collection("posts")
        .get()
        .then((value) {
      for(var element in value.docs){
        element.reference.collection("likes").get()
            .then((value2) {
          element.reference.collection("comments").get()
              .then((comm){
            postsComments.add(comm.size);
            postsLikes.add(value2.size);
            postsId.add(element.id);
            posts.add(element);
            bool liked = false;
            for(var doc in value2.docs){
              if(doc.id == Uid){
                liked = true;
                break;
              }
            }
            myLikes.add(liked);
            if(posts.length == value.docs.length) {
              emit(SocialSuccessUserDataState());
            }
            // print(myLikes);

          });
        });
      }
    }).catchError((error){
      emit(SocialErrorUserDataState());
      // print(error.toString());
    });

  }

  File? profileImage;

  Future<void> ChangeProfileImage() async {
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);

  if(image != null){
    profileImage = File(image.path);
    userData.image= image.path;
    emit(SocialChangeProfileSuccess());
  }else{
    emit(SocialChangeProfileError());
  }

}

  void updateProfileData({
  required String name,
  required String bio,
 }){

  userData.bio = bio;
  userData.name = name;
  if(profileImage != null){
    UploadProfileImage(name: name,bio: bio );
  }else {
    FirebaseFirestore.instance.collection("users").
    doc(Uid).update(userData.getUserData()).
    then((value) {
      emit(SocialUpdateProfileSuccess());
    }).
    catchError((error) {
      emit(SocialUpdateProfileError());
    });
  }
}

void UploadProfileImage({
  required String name,
  required String bio,

}){

  firebase_storage.FirebaseStorage.instance.ref()
      .child("users/${Uri.file(profileImage!.path).pathSegments.last}")
      .putFile(profileImage!)
      .then((value) {
         value.ref.getDownloadURL()
             .then((url) {
               userData.image = url;
               FirebaseFirestore.instance.collection("users").
               doc(Uid).update(userData.getUserData()).
               then((value) {
                 emit(SocialUpdateProfileSuccess());
               }).
               catchError((error) {
                 emit(SocialUpdateProfileError());
               });

               emit(SocialUploadProfileSuccess());
         })
             .catchError((error){
               emit(SocialUploadProfileError());
         });
  })
      .catchError((error){
            emit(SocialUploadProfileError());
  });


}


  File? postImage;

  Future<void> UploadPostImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if(image != null){
      postImage = File(image.path);
      emit(SocialUploadPostImageSuccess());
    }else{
      emit(SocialUploadPostImageError());
    }

  }

  void removePostImage(){
    postImage = null;
    emit(SocialRemovePostImageSuccess());
  }

  void CraeteTextPost({
    required String text,
    required String dateTime,
  }){
    emit(SocialUploadPostLoading());
    FirebaseFirestore.instance
        .collection("posts")
        .add({
      "dateTime" : dateTime,
      "uid": Uid,
      "name": userData.name,
      "postImage": "",
      "text": text,
      "profileImage":userData.image,
    }).then((value) {
      emit(SocialUploadPostSuccess());
    })
        .catchError((error){
          emit(SocialUploadPostError());
    });

  }

  void CreateImagePost({
    required String text,
    required String dateTime,

  }){
   emit(SocialUploadImagePostLoading());
    firebase_storage.FirebaseStorage.instance.ref()
        .child("posts/${Uri.file(postImage!.path).pathSegments.last}")
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL()
          .then((url) {
        FirebaseFirestore.instance
            .collection("posts")
            .add({
          "dateTime" : dateTime,
          "uid": Uid,
          "name": userData.name,
          "postImage": url,
          "text": text,
          "profileImage":userData.image,
        }).then((value) {
          emit(SocialUploadPostSuccess());
        })
            .catchError((error){
          emit(SocialUploadImagePostError());
        });
      })
          .catchError((error){
        emit(SocialUploadImagePostError());
      });
    })
        .catchError((error){
      emit(SocialUploadImagePostError());
    });


  }

  void likeClick(index){
    FirebaseFirestore.instance.collection("posts")
      .doc(postsId[index])
      .collection("likes")
      .doc(Uid)
      .set({
      "like": true
    }).then((value) {
      myLikes[index] = true;
      postsLikes[index] ++;
      emit(SocialLikePostSuccess());
    })
        .catchError((error){
          emit(SocialLikePostError());
    });
  }

  void dislikeClick(index){
    FirebaseFirestore.instance.collection("posts")
        .doc(postsId[index])
        .collection("likes")
        .doc(Uid)
        .delete()
        .then((value) {
          myLikes[index] =false;
          postsLikes[index] --;
          emit(SocialLikePostSuccess());
    })
        .catchError((error){
      emit(SocialLikePostError());
    });
  }

  void commentClick(index,text){
    FirebaseFirestore.instance.collection("posts")
        .doc(postsId[index])
        .collection("comments")
        .add({
      "comment": text
    }).then((value) {
      postsComments[index] ++;
      emit(SocialCommentPostSuccess());
    })
        .catchError((error){
      emit(SocialCommentPostError());
    });
  }


}