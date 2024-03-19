import 'package:crud_flutter/modules/products/model/product.dart';
import 'package:crud_flutter/repositories/product/product_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository();
});

final dataProductProvider = FutureProvider<List<ProductModel>>((ref) async {
  final productRepository = ref.watch(productRepositoryProvider);
  return productRepository.getProduct();
});

final detailProductProvider =
    FutureProvider.family.autoDispose<ProductModel, String?>((ref, id) async {
  final productRepositroy = ref.watch(productRepositoryProvider);
  return productRepositroy.detailProduct(id);
});
