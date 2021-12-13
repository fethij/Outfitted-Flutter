class Product {
  String id;
  String name;
  String productImage;
  String supplier;
  String productDescription;
  int stock, discountPercentage;
  double price;

  Product({
    this.id,
    this.name,
    this.productImage,
    this.supplier,
    this.productDescription,
    this.stock,
    this.discountPercentage,
    this.price,
  });

  Product.getProductFromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    productImage = json['productImage'];
    supplier = json['supplier'];
    productDescription = json['productDescription'];
    stock = json['stock'];
    discountPercentage = int.parse(json['discount'].toString());
    price = double.parse(json['price'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['productImage'] = this.productImage;
    data['supplier'] = this.supplier;
    data['productDescription'] = this.productDescription;
    data['stock'] = this.stock;
    data['discount'] = this.discountPercentage;
    data['price'] = this.price;

    return data;
  }

  // When using the API

  Product.fromJsonApi(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    productImage = json['productImage'];
    supplier = json['supplier'];
    productDescription = json['productDescription'];
    stock = int.parse(json['stock'].toString());
    price = double.parse(json['price'].toString());
  }

  Map<String, dynamic> toJsonApi() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['productImage'] = this.productImage;
    data['supplier'] = this.supplier;
    data['productDescription'] = this.productDescription;
    data['stock'] = this.stock.toString();
    data['price'] = this.price.toString();

    return data;
  }
// End of API
}
