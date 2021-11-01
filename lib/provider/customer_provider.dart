import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:pos/models/customer_model.dart';
import 'package:pos/network_api/api.dart';

class CustomerProvider with ChangeNotifier{
  List<CustomerModel> customer =[];
  List<CustomerModel> customer2 =[];
  List<CustomerModel> select_customer = [];
  

  List<CustomerModel>getListCustomer(){
    return customer2;
  }
  List<CustomerModel>getListCustomer2(){
    return customer;
  }
  List<CustomerModel>selectCustomer(){
    return select_customer;
  }
  addCustomer(data){
    print('add cstomer');
    print(data);
    select_customer.insert(0, data);
    print(select_customer.length);
    notifyListeners();
  }
  emtySelect(){
    select_customer.clear();
    print(select_customer.length);
    print('remove customer');
    notifyListeners();
  }

  getindex(tel) async{
    List<CustomerModel> customer3 =[];
    print('changed $tel');
    getListCustomer2().forEach((e) {
      // print(e.phone.indexOf(tel));
      if(  e.phone.indexOf(tel) == 0){
         customer3.add(e);
        print(e.phone);
      }

    print(customer3.length);
    customer2 = customer3;
    });
    notifyListeners();
  }
  getName(id){
    print('id$id');

    String customer4 ='';
      getListCustomer2().forEach((e) {
      // print(e.id);
      if(  e.id == id){
         customer4 =e.name;
         print(e.name);
      }
      });
        print(customer4);

      return customer4;
      // notifyListeners();

  }

  initCustomer() async {
   var company;
   var name;
   var phone;
   var address;
   customer.clear();
  //  var created_at;
  final cus =   await Network().getData3('/customer');
  if (cus == 'error'){
    var body = json.decode(cus.body)['customers'];
    if(cus.statusCode == 200){
      // print(body);
      body.forEach((e){
        company = e['company'];
        name = e['name'];
        phone = e['phone'];
        address = e['address'];
        // created_at = e[''];

        CustomerModel val = CustomerModel(e['id'].toString(),company,name,phone,address);
        customer.insert(0,val);
      });
    }
  }
    customer2 = customer ;
        notifyListeners();


  }
}