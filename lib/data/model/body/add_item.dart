class Add_Item {
  Add_Item({
    required this.id,
    required this.productId,
    required this.productName,
    required this.qty,
  });
  int? id;
  late double qty=0.0;
  late final String productId;
  late final String productName;
  late final String productImage;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'productId': productId,
      'productName': productName,
      'qty': qty,
    };
    return map;
  }

  Add_Item.fromMap(Map<dynamic, dynamic> map) {
    id = map['id'];
    productId = map['productId'];
    productName = map['productName'];
    productImage = map['productImage'];
    qty = map['qty'];
  }
}