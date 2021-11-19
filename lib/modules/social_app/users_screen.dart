
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:social_app/layout/social_app/cubit/cubit.dart';
import 'package:social_app/layout/social_app/cubit/states.dart';
import 'package:social_app/modules/social_app/edit_profile.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constans.dart';
import 'package:social_app/shared/styles/colors.dart';

class SocialUserScreen extends StatelessWidget{

  var commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var commentController = TextEditingController();

    return BlocConsumer<SocialCubit,SocialStates>(
      listener: (context,state){},
      builder: (context,state){
        SocialCubit cubit = SocialCubit.getInstance(context);
        return SingleChildScrollView(
          child: Conditional.single(
          context: context,
          conditionBuilder: (context) =>
          cubit.posts.isNotEmpty ,
          fallbackBuilder:(context)=> const Center(child: CircularProgressIndicator()),
          widgetBuilder:  (context)=> Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  height: 190.0,
                  child: Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      Align(
                        child: Container(
                          height: 150.0,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
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
                        radius: 60.0,
                        backgroundColor:
                        Theme.of(context).scaffoldBackgroundColor,
                        child: CircleAvatar(
                          radius: 60.0,
                          backgroundImage: NetworkImage(
                            userData.image??ProfImg,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Text(
                  userData.name,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Text(
                  userData.bio??"bio",
                  style: Theme.of(context).textTheme.caption,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20.0,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          child: Column(
                            children: [
                              Text(
                                '100',
                                style: Theme.of(context).textTheme.subtitle2,
                              ),
                              Text(
                                'Posts',
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                          onTap: () {},
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          child: Column(
                            children: [
                              Text(
                                '265',
                                style: Theme.of(context).textTheme.subtitle2,
                              ),
                              Text(
                                'Photos',
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                          onTap: () {},
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          child: Column(
                            children: [
                              Text(
                                '10k',
                                style: Theme.of(context).textTheme.subtitle2,
                              ),
                              Text(
                                'Followers',
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                          onTap: () {},
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          child: Column(
                            children: [
                              Text(
                                '64',
                                style: Theme.of(context).textTheme.subtitle2,
                              ),
                              Text(
                                'Followings',
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          NavgPushTo(context, EditProfile(userData: userData,),);
                        },
                        child: const Text(
                          'Edit Profile',
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    OutlinedButton(
                      onPressed: () {
                        NavgPushTo(context, EditProfile(userData: userData,),);
                      },
                      child: const Icon(
                        Icons.edit,
                        size: 16.0,
                      ),
                    ),
                  ],
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index){
                    if(cubit.posts[index]['uid'] == Uid) {
                      return buildPostItem(context,index,cubit.posts);
                    }else{
                      return const SizedBox();
                    }
                    },
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 8.0,
                  ),
                  itemCount: cubit.posts.length,
                ),

              ],
            ),
          ),
          ),
        );
      },
    );
  }

  Widget buildPostItem(context,index,posts) {
    SocialCubit cubit = SocialCubit.getInstance(context);
    return Card(
      // color: HexColor('333739'),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 5.0,
      margin: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25.0,
                  backgroundImage: NetworkImage(
                      posts[index]['profileImage']??ProfImg
                  ),
                ),
                const SizedBox(
                  width: 15.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            posts[index]['name'],
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          const Icon(
                            Icons.check_circle,
                            color: defaultColor,
                            size: 16.0,
                          ),
                        ],
                      ),
                      Text(
                        posts[index]['dateTime'].toString().substring(0,16),
                        style: Theme
                            .of(context)
                            .textTheme
                            .caption!
                            .copyWith(
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 15.0,
                ),
                IconButton(
                  icon: const Icon(
                    Icons.more_horiz,
                    size: 16.0,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 15.0,
              ),
              child: Container(
                width: double.infinity,
                height: 1.0,
                color: Colors.grey[300],
              ),
            ),
            Text(
              posts[index]['text'],
              style: Theme
                  .of(context)
                  .textTheme
                  .bodyText1,
              maxLines: 8,
              overflow: TextOverflow.ellipsis,
            ),
            if(posts[index]['postImage'] != null &&
                posts[index]['postImage'] != "" )
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  height: 400.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      4.0,
                    ),
                    image: DecorationImage(
                      image: NetworkImage(
                          posts[index]['postImage']
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 5.0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5.0,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.favorite,
                              size: 16.0,
                              color: Colors.red,
                            ),
                            const SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              cubit.postsLikes[index].toString(),
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .caption,
                            ),
                          ],
                        ),
                      ),
                      onTap: () {},
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Icon(
                              Icons.chat,
                              size: 16.0,
                              color: Colors.amber,
                            ),
                            const SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              cubit.postsComments[index].toString(),
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .caption,
                            ),
                          ],
                        ),
                      ),
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 10.0,
              ),
              child: Container(
                width: double.infinity,
                height: 1.0,
                color: Colors.grey[300],
              ),
            ),
            Row(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 18.0,
                      backgroundImage: NetworkImage(
                          userData.image ?? ProfImg
                      ),
                    ),
                    const SizedBox(
                      width: 15.0,
                    ),
                    SizedBox(
                      width: 170,
                      child:
                      TextFormField(
                        maxLines: 1,
                        controller: commentController,
                        decoration: const InputDecoration(
                          hintText: ('write a comment ...'),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // if(commentController.text != "")
                IconButton(
                  icon: const Icon(Icons.send),
                  color: defaultColor,
                  onPressed: () {
                    cubit.commentClick(index, commentController.text);
                    commentController.text = "";
                  },
                ) ,
                InkWell(
                  child: Row(
                    children: [
                      Icon(
                        cubit.myLikes[index]? Icons.favorite :Icons.favorite_border,
                        size: 16.0,
                        color: Colors.red,
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        'Like',
                        style: Theme
                            .of(context)
                            .textTheme
                            .caption,
                      ),
                    ],
                  ),
                  onTap: () {
                    if(cubit.myLikes[index]) {
                      cubit.dislikeClick(index);
                    } else {
                      cubit.likeClick(index);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}