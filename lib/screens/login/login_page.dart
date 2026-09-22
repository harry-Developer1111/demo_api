import 'dart:convert';

import 'package:demo_api_app/api_link/api_link.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey=GlobalKey<FormState>();

  final emailController=TextEditingController();
  final passwordController=TextEditingController();

  Future<void> login()async{
    final pref=await SharedPreferences.getInstance();

    String email= emailController.text.trim();
    String password=passwordController.text.trim();

    try{
      final url=Uri.parse(ApiLink.loginApi);
      final response=await http.post(url,

        headers: {
          "x-api-key": ApiKeyConf.apiKey,
          "Content-Type":"application/json"
        },
        body: jsonEncode({
          "email":email,
          "password":password
        })
      );

      print(response.statusCode);

      if(response.statusCode==200||response.statusCode==201){
        print(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("login Successfully"))
        );
        await pref.setBool("isLogin", true);
        if(!mounted)return;
        context.go('/home');
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("login failed")));
      }
      
    }
    catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error:$e"))
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.lightGreenAccent,
        title: Text("LoginPage Page",
          style: TextStyle(fontSize: 25),
        ),),
      body: Form(
        key: formKey,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(

            children: [
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                    hintText: 'Enter email',
                    label: Text("email"),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email)
                ),
                validator: (value){
                  if(value==null||value.isEmpty){
                    return 'Please enter email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                    hintText: 'Enter password',
                    label: Text("password"),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.password)
                ),
                validator: (value){
                  if(value==null||value.isEmpty){
                    return 'Please enter password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30,),

              ElevatedButton(
                onPressed: (){
                  if(formKey.currentState!.validate()){
                    login();
                  }
                }, child: Text('login'),

                style: ElevatedButton.styleFrom(
                  minimumSize:Size(double.infinity,54),
                  backgroundColor: Colors.lightGreenAccent,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              InkWell(
                  onTap: (){
                    context.go('/register');
                  },
                  child: Text('createAccount',style: TextStyle(fontSize: 30),))
            ],
          ),
        ),
      ),

    );
  }
}
