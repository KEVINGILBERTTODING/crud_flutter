import 'dart:async';

import 'package:crud_flutter/controllers/product_controller.dart';
import 'package:crud_flutter/modules/products/model/product.dart';
import 'package:crud_flutter/providers/product/product_provider.dart';
import 'package:crud_flutter/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateProduct extends ConsumerWidget {
  const UpdateProduct({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    String productId = args?['id'];
    TextEditingController _nameProductController = TextEditingController();
    TextEditingController _priceProductController = TextEditingController();

    final AsyncValue<ProductModel> productData =
        ref.watch(detailProductProvider(productId));

    final productController = Provider((ref) {
      final entryRepository = ref.watch(productRepositoryProvider);
      return ProductController(ref, entryRepository);
    });

    void _updateProduct(ProductModel productModel) async {
      final controller = ref.read(productController);

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(), // Tambahkan ini untuk dialog sirkular
              SizedBox(width: 20), // Jarak antara indicator dengan teks
              Text(
                  'Mengubah produk...'), // Teks yang memberi tahu pengguna bahwa proses penghapusan sedang berlangsung
            ],
          ),
        ),
      );

      final response = await controller.editProduct(productModel, productId);
      Navigator.pop(context);

      if (response == 'success') {
        _priceProductController.clear();
        _nameProductController.clear();
        Navigator.pushNamed(context, AppRoutes.homeScreen);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Terjadi kesalahan')));
      }
    }

    return Scaffold(
      body: SafeArea(
        child: productData.when(data: (data) {
          _nameProductController.text = data.productName;
          String? productPrice = data.price.toString();
          _priceProductController.text = productPrice;
          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BackButton(),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Ubah Data Produk',
                      style: TextStyle(fontFamily: 'popbold', fontSize: 18),
                    )),
                SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          TextField(
                            controller: _nameProductController,
                            decoration: InputDecoration(
                                label: Text('Nama Product'),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                                floatingLabelAlignment:
                                    FloatingLabelAlignment.start),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: _priceProductController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                label: Text('Harga Product'),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                                floatingLabelAlignment:
                                    FloatingLabelAlignment.start),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () async {
                        ProductModel dataProduct = ProductModel(
                            productName: _nameProductController.text,
                            price: int.parse(_priceProductController.text),
                            tglMasuk: '2020-02-02');
                        _updateProduct(dataProduct);
                      },
                      child: Text(
                        'Simpan Data',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateColor.resolveWith(
                              (states) => Colors.purple.shade200)),
                    ),
                  ),
                )
              ],
            ),
          );
        }, error: (error, stackTrace) {
          print(error);
          return Center(
            child: Text('Tidak dapat memuat data'),
          );
        }, loading: () {
          return Center(
            child: CircularProgressIndicator(),
          );
        }),
      ),
    );
  }
}
