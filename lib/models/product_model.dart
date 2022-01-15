
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
  var wholesaler;
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
    this.wholesaler,
    // required this.catagory_id,
    // required this.branch_id,
    // required this.created_at,
    // required this.updated_at,
  );
}

