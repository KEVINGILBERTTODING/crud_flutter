import 'dart:ffi';
import 'dart:math';

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
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
