import 'package:crud_flutter/controllers/product_controller.dart';
import 'package:crud_flutter/modules/products/model/product.dart';
import 'package:crud_flutter/providers/auth/auth_provider.dart';
import 'package:crud_flutter/providers/product/product_provider.dart';
import 'package:crud_flutter/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController _productNameController = TextEditingController();
    TextEditingController _productPriceController = TextEditingController();

    TextEditingController _productNameEditController = TextEditingController();
    TextEditingController _productPriceEditController = TextEditingController();
    final asyncDataProduct = ref.watch(dataProductProvider);

    final productController = Provider((ref) {
      final entryRepository = ref.watch(productRepositoryProvider);
      return ProductController(ref, entryRepository);
    });

    Future<bool> addProduct(WidgetRef ref) async {
      final controller = ref.read(productController);

      ProductModel productModel = ProductModel(
          productName: _productNameController.text,
          price: int.parse(_productPriceController.text),
          tglMasuk: "2020-02-02");

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(), // Tambahkan ini untuk dialog sirkular
              SizedBox(width: 20), // Jarak antara indicator dengan teks
              Text(
                  'Menambahkan produk...'), // Teks yang memberi tahu pengguna bahwa proses penghapusan sedang berlangsung
            ],
          ),
        ),
      );

      final response = await controller.addProduct(productModel);

      Navigator.pop(context);
      // Menampilkan pesan sukses/gagal
      if (response == 'success') {
        _productPriceController.clear();
        _productNameController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Berhasil menambahkan data')),
        );
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menambahkan data')),
        );
        return false;
      }
    }

    void deleteProduct(WidgetRef ref, String id) async {
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
                  'Menghapus produk...'), // Teks yang memberi tahu pengguna bahwa proses penghapusan sedang berlangsung
            ],
          ),
        ),
      );

      final response = await controller.deleteProduct(id);

      Navigator.pop(context); // Tutup dialog saat selesai

      // Menampilkan pesan sukses/gagal
      if (response == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Berhasil menghapus data')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghapus data data')),
        );
      }
    }

    void _showModalEdit(String id) async {
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
                    'Ubah Data',
                    style: TextStyle(fontFamily: 'popbold', fontSize: 15),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama produk tidak boleh kosong';
                      }
                      return null;
                    },
                    autocorrect: true,
                    controller: _productNameEditController,
                    decoration: InputDecoration(
                      labelText: 'Nama Produk',
                      border: OutlineInputBorder(),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _productPriceEditController,
                    decoration: InputDecoration(
                      labelText: 'Harga Produk',
                      border: OutlineInputBorder(),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () async {
                        // final _addProductAsync = await addProduct(ref);
                        // if (_addProductAsync) {
                        //   Navigator.pop(context);
                        // }
                      },
                      child: Text('Simpan'),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    void _showPopUpMenu(WidgetRef ref, String id) {
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) => AlertDialog(
                content: Container(
                    height: 120,
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            "Menu Pop Up",
                            style:
                                TextStyle(fontFamily: 'popbold', fontSize: 15),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton.icon(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, AppRoutes.updateProductScreen,
                                      arguments: {'id': id});
                                },
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateColor.resolveWith(
                                            (states) =>
                                                Colors.orange.shade300)),
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.black,
                                ),
                                label: Text(
                                  'Edit',
                                  style: TextStyle(
                                      fontFamily: 'popmed',
                                      fontSize: 15,
                                      color: Colors.black),
                                )),
                            SizedBox(
                              width: 20,
                            ),
                            TextButton.icon(
                                onPressed: () {
                                  Navigator.pop(context);

                                  deleteProduct(ref, id);
                                },
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateColor.resolveWith(
                                            (states) => Colors.red.shade400)),
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                                label: Text('Hapus',
                                    style: TextStyle(
                                      fontFamily: 'popmed',
                                      fontSize: 15,
                                      color: Colors.white,
                                    ))),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    )),
              ));
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
                      color: Colors.purple.shade100,
                      child: ListTile(
                        onTap: () {
                          String? productId = item.id;
                          if (productId != null) {
                            _showPopUpMenu(ref, productId);
                            // deleteProduct(ref, productId);
                          }
                        },
                        title: Text(
                          item.productName,
                          style: TextStyle(fontFamily: 'popbold', fontSize: 15),
                        ),
                        subtitle: Text('Rp. ${item.price?.toString()}'),
                        trailing: Icon(Icons.keyboard_arrow_right),
                      ),
                    );
                  },
                ),
                error: (error, stracTrace) {
                  return Center(
                    child: Text('Gagal memuat data'),
                  );
                },
                loading: () => Center(child: CircularProgressIndicator()),
              ),
            )
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
                        style: TextStyle(fontFamily: 'popbold', fontSize: 15),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nama produk tidak boleh kosong';
                          }
                          return null;
                        },
                        autocorrect: true,
                        controller: _productNameController,
                        decoration: InputDecoration(
                          labelText: 'Nama Produk',
                          border: OutlineInputBorder(),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: _productPriceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Harga Produk',
                          border: OutlineInputBorder(),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                      SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () async {
                            final _addProductAsync = await addProduct(ref);
                            if (_addProductAsync) {
                              Navigator.pop(context);
                            }
                          },
                          child: Text('Simpan'),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
