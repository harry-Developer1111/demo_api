import 'dart:convert';

import 'package:demo_api_app/models/products_model/products_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../api_link/api_link.dart';

class ProductDetailPage extends StatefulWidget {
  final String id;
  final String category;

  const ProductDetailPage(
      {super.key, required this.id, required this.category});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  ProductModel? product;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getProductDetail();
  }

  Future<void> getProductDetail() async {
    final url = Uri.parse(
        'https://api.restful-api.dev/collections/${widget.category}/objects/${widget.id}');

    final response = await http.get(url, headers: {
      "x-api-key": ApiKeyConf.apiKey,
      "Content-Type": "application/json",
    });

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      setState(() {
        product = ProductModel.fromJson(data);
        isLoading = false;
      });

    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Details"),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : product == null
              ? const Center(
                  child: Text("Product not found"),
                )
              : Padding(
                  padding: const EdgeInsets.all(20),
                  child: Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Name:${product!.name}',
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "Year: ${product!.year}",
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Price: ${product!.price}",
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Category: ${widget.category}",
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "ID: ${product!.id}",
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }
}
