import 'dart:convert';

import 'package:demo_api_app/api_link/api_link.dart';
import 'package:demo_api_app/approuter/app_router.dart';
import 'package:demo_api_app/models/products_model/products_model.dart';
import 'package:demo_api_app/screens/home/edit_bottom_Sheet/edit_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'bottom_sheet/bottom_sheet.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    getProducts();
  }

  //List<dynamic> productList = [];
  List<ProductModel> productList = [];

  String selectedCategory = "phones";

  Future<void> openBottomSheet() async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return BottomSheetWork(
          initialCategory: selectedCategory,
        );
      },
    );

    if (result == true) {
      getProducts();
    }
  }

  Future<void> getProducts() async {
    final url = Uri.parse(
      "https://api.restful-api.dev/collections/$selectedCategory/objects",
    );

    final response = await http.get(url, headers: {
      "x-api-key": ApiKeyConf.apiKey,
      "Content-Type": "application/json",
    });

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode == 200) {

      final data = jsonDecode(response.body);

      setState(() {
        productList = data.map(
              (product) => ProductModel.fromJson(product),
        ).toList();
      });

      // setState(() {
      //   productList = List<ProductModel>.from(data.map((product) => ProductModel.fromJson(product),
      //     ),
      //   );
      // });
    }
  }

  Future<void> openEditBottomSheet(ProductModel product) async {
    // Pehle selected product ka detail API se GET karo

    final url = Uri.parse(
      "https://api.restful-api.dev/collections/"
      "$selectedCategory/objects/${product.id}",
    );

    final response = await http.get(
      url,
      headers: {
        "x-api-key": ApiKeyConf.apiKey,
        "Content-Type": "application/json",
      },
    );
    print("EDIT GET STATUS: ${response.statusCode}");
    print("EDIT GET BODY: ${response.body}");

    if(response.statusCode==200){
      final data=jsonDecode(response.body);
      final selectedProduct=ProductModel.fromJson(data);

      if (!mounted) return;

      await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context){
            return EditBottomSheet(
                productModel: selectedProduct,
                category: selectedCategory);
            }
          );
      // Update ke baad list refresh
      getProducts();
    }

  }

  Future<void> deleteProduct(ProductModel product) async {
    final url = Uri.parse(
      "https://api.restful-api.dev/collections/"
          "$selectedCategory/objects/${product.id}",
    );

    final response = await http.delete(
      url,
      headers: {
        "x-api-key": ApiKeyConf.apiKey,
        "Content-Type": "application/json",
      },
    );

    print("DELETE STATUS: ${response.statusCode}");
    print("DELETE BODY: ${response.body}");

    if (!mounted) return;

    if (response.statusCode == 200 || response.statusCode == 204) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Product deleted successfully"),
        ),
      );

      getProducts();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Delete failed"),
        ),
      );
    }
  }

  Future<void> showDeleteDialog(ProductModel product)async{

    final result=await showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: const Text("Delete Product"),
            content: Text("Are you sure you want to delete${product.name}?"),
            actions: [
              TextButton(
                onPressed: (){
                  Navigator.pop(context,false);
                },
                child: Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: (){
                 Navigator.pop(context,true);
                },
                child: Text("Delete"),
              )
            ],
          );
        },
        );
    if(result==true){
      deleteProduct(product);
    }
  }

  Widget categoryButton({
    required String title,
    required String category,
    required IconData icon,
  }) {
    bool isSelected = selectedCategory == category;

    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedCategory = category;
        });

        getProducts();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue : Colors.white,
        foregroundColor: isSelected ? Colors.white : Colors.blue,
        side: const BorderSide(
          color: Colors.blue,
          width: 2,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),

      ),
      child: Row(
        children: [
          Icon(icon),
          Text(title),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              categoryButton(
                title: "Phones",
                category: "phones",
                icon: Icons.phone_android,
              ),
              const SizedBox(width: 4),
              categoryButton(
                title: "Tablets",
                category: "tablets",
                icon: Icons.tablet,
              ),
              const SizedBox(width: 4),
              categoryButton(
                title: "MacBook",
                category: "macbooks",
                icon: Icons.laptop_mac,
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: productList.length,
              itemBuilder: (context, index) {
                final product = productList[index];

                return Card(
                    child: InkWell(
                  onTap: () {
                    context.push(
                      '/product-detail/${product.id}?category=$selectedCategory',
                    );
                  },
                  child: ListTile(
                    title: Text(product.name),
                    subtitle: Text(
                      "Year: ${product.year}\n"
                      "Price: ${product.price}",
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Edit button
                        IconButton(
                          onPressed: () {
                            // edit code
                            // print("Edit clicked");
                            openEditBottomSheet(product);
                          },
                          icon: Icon(Icons.edit),
                        ),

                        // Delete button
                        IconButton(
                          onPressed: () {
                            // delete code
                            //print("Delete clicked");
                            showDeleteDialog(product);
                          },
                          icon: Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ),
                ));
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        onPressed: openBottomSheet,
        child: Icon(Icons.add),
      ),
    );
  }
}
