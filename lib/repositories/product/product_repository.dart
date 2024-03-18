import 'dart:convert';

import 'package:crud_flutter/modules/products/model/product.dart';
import 'package:crud_flutter/remote/api_service.dart';
import 'package:http/http.dart' as http;

class ProductRepository {
  Future<List<ProductModel>> getProduct() async {
    final responseProduct = await http.get(Uri.parse(ApiService.baseUrl));
    if (responseProduct.statusCode == 200) {
      final List<dynamic> dataProduct = jsonDecode(responseProduct.body);

      return dataProduct.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw Exception('failed get product');
    }
  }

  Future<String> addProduct(ProductModel productData) async {
    try {
      var url = Uri.parse(ApiService.baseUrl);
      var response = await http.post(
        url,
        body: jsonEncode(productData),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        return 'success';
      } else {
        print('gagal');

        throw Exception('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('error');
      throw Exception('Error: $e');
    }
  }
}
