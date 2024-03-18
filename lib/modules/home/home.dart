import 'package:crud_flutter/controllers/product_controller.dart';
import 'package:crud_flutter/modules/products/model/product.dart';
import 'package:crud_flutter/providers/auth/auth_provider.dart';
import 'package:crud_flutter/providers/product/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController _productNameController = TextEditingController();
    TextEditingController _productPriceController = TextEditingController();
    final asyncDataProduct = ref.watch(dataProductProvider);

    final productController = Provider((ref) {
      final entryRepository = ref.watch(productRepositoryProvider);
      return ProductController(ref, entryRepository);
    });

    void addProduct(WidgetRef ref) async {
      final controller = ref.read(productController);

      ProductModel productModel = ProductModel(
          productName: _productNameController.text,
          price: int.parse(_productPriceController.text),
          tglMasuk: "2020-02-02");

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
            content: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [Text('Data')],
          ),
        )),
      );

      final response = await controller.addProduct(productModel);

      Navigator.pop(context); // Tutup dialog saat selesai

      // Menampilkan pesan sukses/gagal
      if (response == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Berhasil menambahkan data')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menambahkan data')),
        );
      }
    }

    void deleteProduct(WidgetRef ref, String id) async {
      final controller = ref.read(productController);

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
            content: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [Text('Data')],
          ),
        )),
      );

      final response = await controller.deleteProduct(id);

      Navigator.pop(context); // Tutup dialog saat selesai

      // Menampilkan pesan sukses/gagal
      if (response == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Berhasil menambahkan data')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menambahkan data')),
        );
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer(builder: (context, ref, child) {
              final asyncUsername = ref.watch(dataUsernameProvider);
              final username = asyncUsername.asData?.value;

              return Container(
                child: ListTile(
                  title: Text(
                    'Halo, $username',
                    style: TextStyle(fontFamily: 'popmed', fontSize: 10),
                  ),
                  subtitle: Text(
                    'Produk baru apa hari ini?',
                    style: TextStyle(fontFamily: 'popbold', fontSize: 15),
                  ),
                ),
              );
            }),
            Expanded(
              child: asyncDataProduct.when(
                data: (data) => ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final item = data[index];
                    return Card(
                      child: ListTile(
                        onTap: () {
                          String? productId = item.id;
                          if (productId != null) {
                            deleteProduct(ref, productId);
                          }
                        },
                        title: Text(item.productName),
                        subtitle: Text('Rp. ${item.price?.toString()}'),
                        trailing: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    );
                  },
                ),
                error: (error, stracTrace) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $error')),
                  );
                  return Text('Error: $error');
                },
                loading: () => Center(child: CircularProgressIndicator()),
              ),
            )
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     showModalBottomSheet(
      //       context: context,
      //       isScrollControlled: true,
      //       builder: (BuildContext context) {
      //         return SingleChildScrollView(
      //           padding: EdgeInsets.only(
      //             bottom: MediaQuery.of(context).viewInsets.bottom,
      //           ),
      //           child: Container(
      //             padding: EdgeInsets.all(16),
      //             child: Column(
      //               mainAxisSize: MainAxisSize.min,
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: [
      //                 Text(
      //                   'Input data baru',
      //                   style: TextStyle(fontFamily: 'popbold', fontSize: 15),
      //                 ),
      //                 SizedBox(height: 20),
      //                 TextFormField(
      //                   validator: (value) {
      //                     if (value == null || value.isEmpty) {
      //                       return 'Nama produk tidak boleh kosong';
      //                     }
      //                     return null;
      //                   },
      //                   autocorrect: true,
      //                   controller: _productNameController,
      //                   decoration: InputDecoration(
      //                     labelText: 'Nama Produk',
      //                     border: OutlineInputBorder(),
      //                     floatingLabelBehavior: FloatingLabelBehavior.always,
      //                   ),
      //                 ),
      //                 SizedBox(height: 20),
      //                 TextField(
      //                   controller: _productPriceController,
      //                   decoration: InputDecoration(
      //                     labelText: 'Harga Produk',
      //                     border: OutlineInputBorder(),
      //                     floatingLabelBehavior: FloatingLabelBehavior.always,
      //                   ),
      //                 ),
      //                 SizedBox(height: 20),
      //                 Align(
      //                   alignment: Alignment.centerRight,
      //                   child: TextButton(
      //                     onPressed: () {
      //                       addProduct(ref);
      //                     },
      //                     child: Text('Simpan'),
      //                     style: ButtonStyle(
      //                       backgroundColor:
      //                           MaterialStateProperty.all(Colors.black),
      //                     ),
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ),
      //         );
      //       },
      //     );
      //   },
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
