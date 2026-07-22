class Product {
  final String name;
  final int sellingPrice;
  final int stock;

  Product(
      {required this.name, required this.sellingPrice, required this.stock});

  static List<Product> getMockProducts() {
    return [
      Product(name: "Kemeja Flanel Pria", sellingPrice: 125000, stock: 50),
      Product(name: "Celana Jeans Slim Fit", sellingPrice: 250000, stock: 30),
      Product(name: "Sepatu Sneakers Casual", sellingPrice: 300000, stock: 20),
      Product(
          name: "Jam Tangan Digital Sporty", sellingPrice: 180000, stock: 40),
      Product(
          name: "Headphone Bluetooth Over-Ear",
          sellingPrice: 450000,
          stock: 15),
    ];
  }
}
