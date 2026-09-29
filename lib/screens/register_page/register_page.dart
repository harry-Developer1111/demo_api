import 'dart:convert';
import 'dart:ui';
import 'package:demo_api_app/api_link/api_link.dart';
import 'package:demo_api_app/mixin/mixins.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {

  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SnackBarMixin {

  void signUpMessage(){
    showMessage(context, 'Create Account Successfully');
  }


  final formKey=GlobalKey<FormState>();

  final nameController=TextEditingController();
  final emailController=TextEditingController();
  final passwordController=TextEditingController();

  Future<void> createAccount()async{

    final pref=await SharedPreferences.getInstance();

    String name=nameController.text.trim();
    String email=emailController.text.trim();
    String password=passwordController.text.trim();

    try{
      final url = Uri.parse(ApiLink.register);

      final response = await http.post(url,
        headers:
        {
          "x-api-key": ApiKeyConf.apiKey,
          "Content-Type":"application/json"
        }
        ,
        body: jsonEncode({
          "name": name,
          "email": email,
          "password": password,
        }),
      );

      if(response.statusCode==200||response.statusCode==201){
        print(response.body);

        signUpMessage();

        await pref.setBool("isLogin", true);
        if(!mounted)return;
        context.go('/home');

      }else{
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(" Account not Created"))
        );
      }

    }
    catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("error:$e"))
      );
    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.lightGreenAccent,
        title: Text("Register Page",
          style: TextStyle(fontSize: 25),
        ),),

      body: Form(
        key: formKey,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(

            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Enter name',
                  label: Text("name"),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value){
                  if(value==null||value.isEmpty){
                    return 'Please enter name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10,),
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
                   createAccount();
                  }
                }, child: Text('Create Account'),

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
                  context.go('/login');
                },
                  child: Text('login',style: TextStyle(fontSize: 30),))
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}


