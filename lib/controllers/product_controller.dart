import 'package:crud_flutter/modules/products/model/product.dart';
import 'package:crud_flutter/providers/product/product_provider.dart';
import 'package:crud_flutter/repositories/product/product_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ProductStatus { initial, loading, success, error }

class ProductController extends StateNotifier<ProductStatus> {
  final ProviderRef ref;
  final ProductRepository productRepository;

  ProductController(this.ref, this.productRepository)
      : super(ProductStatus.initial);

  Future<String> addProduct(ProductModel product) async {
    try {
      state = ProductStatus.loading;
      final response = await productRepository.addProduct(product);
      if (response == 'success') {
        state = ProductStatus.success;
        ref.refresh(dataProductProvider); // Refresh data product
      } else {
        state = ProductStatus.error;
      }
      return response;
    } catch (e) {
      state = ProductStatus.error;
      return 'error';
    }
  }

  Future<String> deleteProduct(String id) async {
    try {
      state = ProductStatus.loading;
      final response = await productRepository.deleteProduct(id);
      if (response == 'success') {
        state = ProductStatus.success;
        ref.refresh(dataProductProvider); // Refresh data product
      } else {
        state = ProductStatus.error;
      }
      return response;
    } catch (e) {
      state = ProductStatus.error;
      return 'error';
    }
  }

  Future<String> editProduct(ProductModel product, String id) async {
    try {
      state = ProductStatus.loading;
      final response = await productRepository.editProduct(product, id);
      if (response == 'success') {
        state = ProductStatus.success;
        ref.refresh(dataProductProvider); // Refresh data product
      } else {
        state = ProductStatus.error;
      }
      return response;
    } catch (e) {
      state = ProductStatus.error;
      return 'error';
    }
  }
}
