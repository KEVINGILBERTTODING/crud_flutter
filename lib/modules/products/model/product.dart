class ProductModel {
  String? id;
  String productName;
  int price;
  String tglMasuk;

  ProductModel({
    this.id,
    required this.productName,
    required this.price,
    required this.tglMasuk,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'],
      productName: json['product_name'],
      price: json['price'],
      tglMasuk: json['tgl_masuk'],
    );
  }

  // Metode untuk mengonversi objek ProductModel menjadi JSON
  Map<String, dynamic> toJson() {
    return {'product_name': productName, 'price': price, 'tgl_masuk': tglMasuk};
  }
}
