import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  bool isUpperCase = true,
  double radius = 3.0,
  required VoidCallback onPressed,
  required String text,
}) =>
    Container(
      width: width,
      height: 50.0,
      child: MaterialButton(
        onPressed: onPressed,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          radius,
        ),
        color: background,
      ),
    );


Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  Function(String value)? onSubmit,
  Function(String value)? onChange,
  Function()? onTap,
  bool isPassword = false,
  required String validText,
  required String label,
  IconData? prefix,
  IconData? suffix,
  Function()? suffixPressed,
  bool isClickable = true,
  bool readOnly = false,
  TextStyle? style,
  border = true,

}) =>
    TextFormField(
      controller: controller,
      readOnly: readOnly ,
      keyboardType: type,
      obscureText: isPassword,
      enabled: isClickable,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      onTap: onTap,
      style: style,
      validator: (value) {
        if (value!.isEmpty) {
          return validText;
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
        color: Colors.black,
      ),
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null
            ? IconButton(
          onPressed: suffixPressed,
          icon: Icon(
            suffix,
            color: Colors.black,
          ),
        )
            : null,
        border: border? const OutlineInputBorder():InputBorder.none ,
      ),
    );


void NavgPushTo(context,Widget widget){


    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context){
            return widget;
          },
        )
    );

}

void NavgPushToAndFinish(context,Widget widget){

  Navigator.pushAndRemoveUntil(
       context,
      MaterialPageRoute(
        builder: (context){
          return widget;
        },
      ),
       (Route<dynamic> route)=> false,
  );

}

void defaultToast({
  required String msg,
  Toast length = Toast.LENGTH_SHORT,
  Color color = Colors.red,
  Color textColor = Colors.white,
  double fontSize = 16.0,
}) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: length,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: color,
      textColor: textColor,
      fontSize: fontSize
  );


}


Widget myDivider() => Padding(
  padding: const EdgeInsetsDirectional.only(
    start: 20.0,
  ),
  child: Container(
    width: double.infinity,
    height: 2.0,
    color: Colors.grey[300],
  ),
);

Widget textLogin(){

  return Padding(
    padding: const EdgeInsets.only(top: 30.0, left: 10.0),
    child: SizedBox(
      //color: Colors.green,
      height: 200,
      width: 200,
      child: Column(
        children: <Widget>[
          Container(
            height: 60,
          ),
          const Center(
            child: Text(
              'A world of possibility in an app',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget verticalText(){
  return const Padding(
    padding: EdgeInsets.only(top: 60, left: 10),
    child: RotatedBox(
        quarterTurns: -1,
        child: Text(
          'Sing in',
          style: TextStyle(
            color: Colors.white,
            fontSize: 38,
            fontWeight: FontWeight.w900,
          ),
        )),
  );
}

Widget singUpText(){
  return const Padding(
    padding: EdgeInsets.only(top: 30, left: 10),
    child: RotatedBox(
        quarterTurns: -1,
        child: Text(
          'Sing up',
          style: TextStyle(
            color: Colors.white,
            fontSize: 38,
            fontWeight: FontWeight.w900,
          ),
        )),
  );

}

Widget verticalNew(){
  return Padding(
    padding: const EdgeInsets.only(top: 10.0, left: 10.0),
    child: SizedBox(
      //color: Colors.green,
      height: 200,
      width: 200,
      child: Column(
        children: <Widget>[
          Container(
            height: 60,
          ),
          const Center(
            child: Text(
              'We can start something new',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    ),
  );

}