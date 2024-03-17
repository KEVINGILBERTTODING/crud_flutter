class ProductModel {
  String? id;
  String productName;
  int price;
  DateTime tglMasuk;

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
      tglMasuk: DateTime.parse(json['tgl_masuk']),
    );
  }
}
