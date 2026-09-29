import 'dart:convert';

import 'package:demo_api_app/models/products_model/products_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;

import '../../../api_link/api_link.dart';


class EditBottomSheet extends StatefulWidget {
  final ProductModel productModel;
  final String category;

  const EditBottomSheet({super.key,
    required this.productModel,
    required this.category

  });

  @override
  State<EditBottomSheet> createState() => _EditBottomSheetState();
}

class _EditBottomSheetState extends State<EditBottomSheet> {

  late TextEditingController nameController;
  late TextEditingController yearController;
  late TextEditingController priceController;

  @override
  void initState() {
    super.initState();
    nameController=TextEditingController(
      text: widget.productModel.name
    );
    yearController=TextEditingController(
      text: widget.productModel.year
    );
    priceController=TextEditingController(
      text: widget.productModel.price
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    yearController.dispose();
    priceController.dispose();
    super.dispose();
  }

  Future<void> updateProduct() async {
    final url = Uri.parse(
      "https://api.restful-api.dev/collections/"
          "${widget.category}/objects/${widget.productModel.id}",
    );

    final body = {
      "name": nameController.text.trim(),
      "data": {
        "year": yearController.text.trim(),
        "price": priceController.text.trim(),
      },
    };

    final response = await http.put(
      url,
      headers: {
        "x-api-key": ApiKeyConf.apiKey,
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    print("UPDATE STATUS: ${response.statusCode}");
    print("UPDATE BODY: ${response.body}");

    if (!mounted) return;

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Product updated successfully"),
        ),
      );

      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Update failed"),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
    ),
    child:  Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "Edit Product",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 20),

        TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: "Product Name",
            border: OutlineInputBorder(),
          ),
        ),

        const SizedBox(height: 15),

        TextField(
          controller: yearController,
          decoration: const InputDecoration(
            labelText: "Year",
            border: OutlineInputBorder(),
          ),
        ),

        const SizedBox(height: 15),

        TextField(
          controller: priceController,
          decoration: const InputDecoration(
            labelText: "Price",
            border: OutlineInputBorder(),
          ),
        ),

        const SizedBox(height: 20),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: updateProduct,
            child: const Text("Update"),
          ),
        ),
      ],
    ),
    );
  }
}