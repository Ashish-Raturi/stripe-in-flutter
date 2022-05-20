import 'package:cloud_firestore/cloud_firestore.dart';

class ProductDetials {
  String name;
  String description;
  String imageUrl;
  String price;
  String priceId;
  int quatity;
  ProductDetials({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.priceId,
    required this.quatity,
  });
}

Future<List<ProductDetials>> featchProductDetails() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<ProductDetials> productDetailsLst = [];

  var qs = await firestore.collection('products').get();

  for (var ds in qs.docs) {
    ProductDetials productDetials = await getProductDetailsFromDs(ds);
    productDetailsLst.add(productDetials);
  }

  return productDetailsLst;
}

Future<ProductDetials> getProductDetailsFromDs(ds) async {
  String price = '';

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var prices = await firestore
      .collection('products')
      .doc(ds.id)
      .collection('prices')
      .get();
  price = (prices.docs.first.get('unit_amount') / 100).toString();

  return ProductDetials(
      name: ds.get('name'),
      description: ds.get('description'),
      imageUrl: ds.get('images')[0],
      price: price,
      priceId: prices.docs.first.id,
      quatity: 1);
}
