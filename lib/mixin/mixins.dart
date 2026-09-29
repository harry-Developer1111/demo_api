import 'package:flutter/material.dart';

 mixin SnackBarMixin{

 void showMessage(BuildContext context,String message){
   ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message))
   );
 }
}