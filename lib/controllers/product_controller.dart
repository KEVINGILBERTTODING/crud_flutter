import 'package:crud_flutter/modules/products/model/product.dart';
import 'package:crud_flutter/providers/product/product_provider.dart';
import 'package:crud_flutter/repositories/product/product_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductController {
  final ProviderRef ref;
  final ProductRepository productRepository;

  ProductController({required this.ref, required this.productRepository});

  Future<String> addProduct(ProductModel productModel) async {
    final response = await productRepository.addProduct(productModel);
    if (response == 'success') {
      // Refresh provider jika produk berhasil ditambahkan
      ref.refresh(productRepositoryProvider);
      // Kembalikan 'success' jika produk berhasil ditambahkan
      return 'success';
    } else {
      // Kembalikan respon dari repository jika gagal
      return response;
    }
  }
}
