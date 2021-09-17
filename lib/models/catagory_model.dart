class CatagoryModel{
  final int id;
  final String name;
 

  CatagoryModel( this.id, this.name);

  
}

  //  getCatagory() async {
  //   final response = await Network().getData2('/catagory');
  //   var body = json.decode(response.body);
  //   List<CatagoryModel> _listCatagory = [];
  //   body.forEach((e) {
  //     CatagoryModel catagory = CatagoryModel(e['id'], e['name']);
  //     _listCatagory.add(catagory);
  //   });
  //   print(_listCatagory.length);
  //   return _listCatagory;
  // }
