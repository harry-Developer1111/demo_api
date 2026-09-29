import 'dart:math';

import 'package:demo_api_app/approuter/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  Future<void> logOut()async{

    final pref=await SharedPreferences.getInstance();

    await pref.setBool("isLogin", false);
    if(!mounted)return;

    context.go('/login');

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Page"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [

              // Profile Image
              const CircleAvatar(
                radius: 55,
                backgroundColor: Colors.blue,
                child: Icon(
                  Icons.person,
                  size: 60,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 15),

              // Name
              const Text(
                "Ram Singh",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              // Email
              const Text(
                "ram@example.com",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 30),

              // Edit Profile
              ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.edit),
                ),
                title: const Text("Edit Profile"),
                subtitle: const Text("Update your profile"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                onTap: () {
                  // Edit profile
                },
              ),

              const Divider(),

              // My Products
              ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.shopping_bag),
                ),
                title: const Text("My Products"),
                subtitle: const Text("View your products"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                onTap: () {
                  // My products
                },
              ),

              const Divider(),

              // Settings
              ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.settings),
                ),
                title: const Text("Settings"),
                subtitle: const Text("App settings"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                onTap: () {
                  // Settings
                },
              ),

              const Divider(),

              // Logout
              ListTile(
                leading: const CircleAvatar(
                  child: Icon(
                    Icons.logout,
                    color: Colors.red,
                  ),
                ),
                title: const Text(
                  "Logout",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  // Logout
                   logOut();

                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}