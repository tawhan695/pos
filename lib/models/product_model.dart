
class ProductModel {
  var id;
  var name;
  //  String  slug;
  var sku;
  //  String  des;
  var unit;
  var retail_price;
  var wholesale_price;
  var sale_price;
  var qty;
  //  String  featured;
  //  String  retail;
  var image;
  //  String  catagory_id;
  //  String  branch_id;
  //  String  created_at;
  //  String  updated_at;

  ProductModel(
    this.id,
    this.name,
    // required this.slug,
    this.sku,
    // required this.des,
    this.unit,
    this.retail_price,
    this.wholesale_price,
    this.sale_price,
     this.qty,
    // required this.featured,
    // required this.retail,
    this.image,
    // required this.catagory_id,
    // required this.branch_id,
    // required this.created_at,
    // required this.updated_at,
  );
}

//   factory ProductModel.fromJson(Map<String, dynamic> json) {
//         print('json');
//     print(json);
//     return ProductModel(
//       id: json["id"],
//       name: json["name"],
//       // slug = json["slug"];
//       sku: json["sku"],
//       // des = json["des"];
//       unit: json["unit"],
//       retail_price: json["retail_price"],
//       wholesale_price: json["wholesale_price"],
//       sale_price: json["sale_price"],
//       qty: json["qty"],
//       // featured = json["featured"];
//       // retail = json["retail"];
//       image: json["image"],
//       // catagory_id = json["catagory_id"];
//       // branch_id = json["branch_id"];
//       // created_at = json["created_at"];
//       // updated_at = json["updated_at"];
//     );
//   }
// }
// Future<List<ProductModel>> fetchProduct() async {
//   final response = await Network().getData({
//     'sale': '0',
//     'catagory': '0',
//   }, '/product');
//   var body = json.decode(response.body);
//   print(body);
//   print('body');
//   // Use the compute function to run parsePhotos in a separate isolate.
//   return parseProduct(response.body);
// }

// // A function that converts a response body into a List<Photo>.
// List<ProductModel> parseProduct(String responseBody) {
//   final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

//   return parsed.map<ProductModel>((json) => ProductModel.fromJson(json)).toList();
// }


// Future<ProductModel> fetchProdut(sale, catagory_id) async {
//   var res = await Network().getData({
//     'sale': '$sale',
//     'catagory': '$catagory_id',
//   }, '/product');
//   var body = json.decode(res.body);
//   if (res.statusCode == 200) {
//     // If the server did return a 200 OK response,
//     // then parse the JSON.
//     print(body);
//     return ProductModel.fromJson(body);
//   } else {
//     // If the server did not return a 200 OK response,
//     // then throw an exception.
//     throw Exception('Failed to load album');
//   }
// }
