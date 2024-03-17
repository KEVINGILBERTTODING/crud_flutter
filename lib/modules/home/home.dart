import 'package:crud_flutter/modules/products/views/list_products.dart';
import 'package:crud_flutter/providers/auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _productNameController = TextEditingController();
  TextEditingController _productPriceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
              child: const ListProducts(),
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
                            child: TextButton(
                                onPressed: () {
                                  String unm = _productNameController.text;
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    content: Text(unm),
                                    duration: Duration(seconds: 2),
                                  ));
                                },
                                child: Text('Simpan'),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.amber))),
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
