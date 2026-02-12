import 'dart:convert';

import 'package:basic_flutter/UI/main/product_model.dart';
import 'package:http/http.dart' as http;

class FechApi {
  //  https://api.escuelajs.co/api/v1/products?offset=1&limit=100

  Future<List<ProductModel>> fetchProduct(int offset) async {
    print("========================${offset}");
    int limit = 10;
    final url = Uri.parse(
      "https://api.escuelajs.co/api/v1/products?offset=$offset&limit=$limit",
    );
    final result = await http.get(url);
    if (result.statusCode == 200) {
      final List data = jsonDecode(result.body);

      return data.map((e) => ProductModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load products.");
    }
  }
}
