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

  Future<ProductModel> detailProduct(String? id) async {
    final responseProduct =
        await http.get(Uri.parse(ApiService.baseUrl + "/$id"));
    if (responseProduct.statusCode == 200) {
      final Map<String, dynamic> responseData =
          jsonDecode(responseProduct.body);
      final ProductModel dataProduct = ProductModel.fromJson(
          responseData); // Ubah Map menjadi objek ProductModel
      return dataProduct;
    } else {
      throw Exception('Failed to get product');
    }
  }

  Future<String> deleteProduct(String id) async {
    try {
      var url = Uri.parse(ApiService.baseUrl + '/$id');
      var response = await http.delete(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return 'success';
      } else {
        print('gagal');

        throw Exception('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print(e.toString());
      throw Exception('Error: $e');
    }
  }

  Future<String> editProduct(ProductModel productData, String id) async {
    try {
      var url = Uri.parse(ApiService.baseUrl + '/$id');
      var response = await http.put(
        url,
        body: jsonEncode(productData),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
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
