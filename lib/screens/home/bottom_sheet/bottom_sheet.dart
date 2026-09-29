import 'dart:convert';

import 'package:demo_api_app/api_link/api_link.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BottomSheetWork extends StatefulWidget {
  final String initialCategory;

  const BottomSheetWork({super.key,
    required this.initialCategory
  });

  @override
  State<BottomSheetWork> createState() => _BottomSheetWorkState();
}

class _BottomSheetWorkState extends State<BottomSheetWork> {
  // Category
  late String selectedCategory;

  @override
  void initState() {
    selectedCategory = widget.initialCategory;
    super.initState();
  }

  // String getCollectionName() {
  //
  //   if (selectedCategory == "Phones") {
  //     return "phones";
  //   }
  //
  //   if (selectedCategory == "Tablets") {
  //     return "tablets";
  //   }
  //
  //   if (selectedCategory == "MacBook") {
  //     return "macbooks";
  //   }
  //
  //   return "phones";
  // }

  //Controllers

  final nameController = TextEditingController();
  final yearController = TextEditingController();
  final priceController = TextEditingController();

  Future<void> saveProduct() async {

    String name = nameController.text.trim();
    String year = yearController.text.trim();
    String price = priceController.text.trim();

    // Validation
    if (name.isEmpty || year.isEmpty || price.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields"),
        ),
      );
      return;
    }

    // API URL
    final url = Uri.parse(
      "https://api.restful-api.dev/collections/${selectedCategory.toLowerCase()}/objects",
    );

    // POST request
    final response = await http.post(
      url,
      headers: {
        "x-api-key":ApiKeyConf.apiKey,
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "name": name,
        "data": {
          "category": selectedCategory,
          "year": int.parse(year),
          "price": double.parse(price),
        },
      }),
    );

    print(response.statusCode);
    print(response.body);

    if (!mounted) return;

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Product created successfully"),
        ),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed: ${response.statusCode}"),
        ),
      );
    }
  }

  // ================= CATEGORY BUTTON =================

  Widget categoryButton({
    required String title,
    required IconData icon,}) {

    bool isSelected = selectedCategory == title;

    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedCategory = title;
        }); },

      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue : Colors.white,
        foregroundColor: isSelected ? Colors.white : Colors.blue,
        side: BorderSide(
          color: Colors.blue,
          width: 2, ),
          padding: EdgeInsets.symmetric(
              horizontal: 8
          ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), ), ),
      child: Row(
        children: [
          Icon(icon),
          Text(title), ], ), ); }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: SizedBox(
        // height: MediaQuery.of(context).size.height * 0.8,
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Create Collections",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.highlight_remove)),
              ],
            ),

            SizedBox(
              height: 20,
            ),

            const SizedBox(height: 20,),

            Row(
              children: [
                Text(
                  "Category",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),

            Row(

              children: [
                Expanded(
                  child: categoryButton(
                    title: "phones",
                    icon: Icons.work_outline,
                  ),
                ),
                const SizedBox(width: 4,),

                Expanded(
                  child: categoryButton( title: "tablets",
                    icon: Icons.perm_identity, ),
                ),

                const SizedBox(width: 4,),

                Expanded(
                  child: categoryButton( title: "macbooks",
                    icon: Icons.school_outlined, ),
                ),
              ],
            ),

            SizedBox(height: 30,),

            Row(
              children: [
                Text(
                  "Name",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                  hintText: "name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
            ),
            Row(
              children: [
                Text(
                  "Year",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            TextField(
              controller: yearController,
              decoration: InputDecoration(
                  hintText: "year",
                  // contentPadding: EdgeInsets.symmetric(
                  //     // vertical: 50,
                  //     // horizontal: 20
                  // ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
            ),
            Row(
              children: [
                Text(
                  "price",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(
                  hintText: "price",
                  // contentPadding: EdgeInsets.symmetric(
                  //     // vertical: 50,
                  //     // horizontal: 20
                  // ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
            ),

            SizedBox(
              height: 10,
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                saveProduct();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Icon(Icons.add), Text("Create Collcetion")],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );


  }
  @override
  void dispose() {
    nameController.dispose();
    yearController.dispose();
    priceController.dispose();
    super.dispose();
  }
}