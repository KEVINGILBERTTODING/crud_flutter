import 'dart:math';

import 'package:crud_flutter/providers/product/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListProducts extends ConsumerWidget {
  const ListProducts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncDataProduct = ref.watch(dataProductProvider);
    return asyncDataProduct.when(
        data: (data) => ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              return Card(
                child: ListTile(
                  title: Text(item.productName),
                  subtitle: Text('Rp. ${item.price?.toString() ?? '0'}'),
                  trailing: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
              );
            }),
        error: (error, stackTrace) {
          // Mencetak pesan kesalahan
          print('error: $error');
          return Text('Error: $error'); // Menampilkan pesan kesalahan di UI
        },
        loading: () => CircularProgressIndicator());
  }
}
