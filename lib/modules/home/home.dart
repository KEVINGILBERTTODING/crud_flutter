import 'package:crud_flutter/controllers/product_controller.dart';
import 'package:crud_flutter/modules/products/model/product.dart';
import 'package:crud_flutter/providers/auth/auth_provider.dart';
import 'package:crud_flutter/providers/product/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  // const HomeScreen({Key? key}) : super(key: key);

  final productController = Provider((ref) {
    final entryRepository = ref.watch(productRepositoryProvider);
    return ProductController(ref: ref, productRepository: entryRepository);
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController _productNameController = TextEditingController();
    TextEditingController _productPriceController = TextEditingController();
    final asyncDataProduct = ref.watch(dataProductProvider);

    void addProduct(WidgetRef reff) {
      ProductModel dataProduct = ProductModel(
          productName: _productNameController.text,
          price: int.parse(_productPriceController.text),
          tglMasuk: "2020-02-02");
      final asyncProduct = ref.read(productController).addProduct(dataProduct);
      if (asyncProduct == 'success') {
        print('success');
      } else {
        print('gagal');
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
                              title: Text(item.productName),
                              subtitle: Text('Rp. ${item.price?.toString()}'),
                              trailing: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          );
                        }),
                    error: (error, stracTrace) {
                      ScaffoldMessenger(child: SnackBar(content: Text('')));
                      return Text('Error: $error');
                    },
                    loading: () => CircularProgressIndicator()))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (BuildContext context) {
                return SingleChildScrollView(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: Container(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Input data baru',
                            style:
                                TextStyle(fontFamily: 'popbold', fontSize: 15),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value == '') {
                                print('inputan kosong');
                                return 'Nama produk tidak boleh kosong';
                              }
                              return null;
                            },
                            autocorrect: true,
                            controller: _productNameController,
                            decoration: InputDecoration(
                                labelText: 'Nama Produk',
                                border: OutlineInputBorder(),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always),
                          ),
                          SizedBox(
                            height: 20,
                          ),

                          TextField(
                            controller: _productPriceController,
                            decoration: InputDecoration(
                                labelText: 'Harga Produk',
                                border: OutlineInputBorder(),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                                onPressed: () {
                                  addProduct(ref);
                                },
                                child: Text('Simpan'),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.black))),
                          )

                          // Tambahkan widget lain yang diperlukan di sini
                        ],
                      ),
                    ));
              });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
