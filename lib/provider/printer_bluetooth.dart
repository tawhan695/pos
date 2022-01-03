import 'dart:convert';
import 'dart:typed_data';
// import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:charset_converter/charset_converter.dart';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';
import 'dart:io';

import 'package:pos/models/order_dertail_model.dart';
import 'package:pos/models/order_model.dart';
import 'package:pos/network_api/api.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'customer_provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class ESC with ChangeNotifier {
  //  late SharedPreferences localStorage;
  PrinterBluetoothManager printerManager = PrinterBluetoothManager();
  var _devices_select = null;
  var _pageSize = '58 mm';
  // late  Image image;
  List listData = [];
  List Branches = [];
  var USER = '';
  List<PrinterBluetooth> _devices = [];
  startScanDevices() {
    print('_startScanDevices');
    // _devices = [];
    printerManager.startScan(Duration(seconds: 4));
  }

  stopScanDevices() {
    print('_stopScanDevices');
    // printerManager.stopScan();
  }

  selectDevices() {
     print('selectDevices');
    printerManager.scanResults.listen((devices) async {
      print('UI: Devices found ${devices.length}');
      _devices = devices;
    });
// stopScanDevices();
  }

  intESC(PrinterBluetooth printer) async {
    print('intESC');
    setPrinter(printer);
    _devices_select = printer;
    print(printer.name);
    print(printer.address);
    print(printer.type);
    print(printer);
    notifyListeners();
  }

  getESC() {
    print('_devices_select');
    return _devices_select;
  }

  showDevice() {
    return _devices;
  }

  setPaperSize(paper) {
    _pageSize = paper;
  }

  getPaperSize() {
    return _pageSize;
  }

  getPrintter() async {
    print('getPrintter ');
    if(_devices_select == null) {
      print('กำลังเชื่อมต่อเครื่องปริ้น...');
      SharedPreferences localStorage = await SharedPreferences.getInstance();
    var printer = jsonDecode(localStorage.getString('printer').toString());
    print('get $printer');
    if (printer != null) {
      if (_devices.length > 0) {
        print('device  ${_devices.length}');
        _devices.forEach((e) {
          print('${e.name} ${e.address}  ${e.type}');
          if (e.address == printer['address']) {
            print('connect .. to  ${printer['address']}');
            _devices_select = e;
            print('connect .. สำเร็จ');  
          }
        });
      }
    }else{
      print('printer = $printer');
    }
    }else{
      print('เชื่อมต่อเครื่องปริ้นแล้ว');
    }

    //  print(printer['address']);
    //  return printer;
  }

  setPrinter(printer) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var data = {
      'name': '${printer.name}',
      'address': '${printer.address}',
      'type': '${printer.type}'
    };
    print('set ${data}');
    localStorage.setString('printer', json.encode(data));
  }

  getBranch() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var branch = jsonDecode(localStorage.getString('branch').toString());

    //  print(branch);
    //  print(branch);
    print('start branch');

    Branches.add(branch['name']);

    Branches.add(branch['des']);

    print(Branches);
  }

  void Print(order, customer, user) async {
    print('order ${order}');
    print(order);
    print('show');
    print('getBranch ${Branches}');
    List or = await detail(order);
    List o1 = await orderload(order);
    print('Print');
    print(Branches[0]);
    print(Branches[1]);
    // List branch = await getBranch();
     print('or :${or}');
    //  print('getBranch ${branch[0]}');
    //  print('getBranch ${branch[1]}');

    var Paper;
    if (_pageSize == '58 mm') {
      Paper = PaperSize.mm58;
    } else if (_pageSize == '80 mm') {
      Paper = PaperSize.mm80;
    }
    try {
      printerManager.selectPrinter(_devices_select);
    } catch (e) {
      // printerManager.
      showToast('ไม่ได้เชื่อมต่อเครื่องปริ้น');
    }
    final profile = await CapabilityProfile.load();
    // TEST PRINT
   try { final PosPrintResult res = await printerManager.printTicket(
        await ticket(Paper, profile, or, o1, customer, user, Branches));
    if (res.msg.toString() == 'Success'){
      showToast('สถานะการทำงาน :'+res.msg.toString());

    }else{
      showToast('ไม่ได้เชื่อมต่อเครื่องพิมพ์ :'+res.msg.toString());
    }
    }catch(e){
      return null;
    }
  }

  getUint8List(String data) async {
    Uint8List g1 =
        await CharsetConverter.encode('TIS-620', '${data.toString()}');
    return g1;
  }

  orderload(id) async {
    List<ListOrder_model> _order = [];
    var res = await Network().getData3('/order/$id/?id=$id');
    if (res != 'error') {
      var body = json.decode(res.body)['order'];
      print(body);
      print(body[0]);
      print(body['paid_by']);
      var str = body['created_at'];
      var newStr = str.substring(0, 10) + ' ' + str.substring(11, 19);
      print(newStr); // 2019-04-05 14:00:51.000
      ListOrder_model model = ListOrder_model(
          body['id'],
          double.parse(body['cash_totol'].toString()),
          double.parse(body['cash'].toString()),
          double.parse(body['discount'].toString()),
          double.parse(body['net_amount'].toString()),
          double.parse(body['change'].toString()),
          body['status'],
          body['status_sale'],
          body['paid_by'],
          body['user_id'],
          body['customer_id'],
          body['branch_id'],
          newStr
          // e['created_at'],
          );
      _order.add(model);
      return _order;
    }
  }

  detail(id) async {
    List<OrdreDetail> _detail = [];
    List _detail2 = [];
    var res = await Network().getData({'id': '$id'}, '/order/detail');
    if (res != 'error') {
      var body = json.decode(res.body)['detail'];
      print('body : $body');
      print('body : ${body.length}');
      for (var i = 0; i < body.length; i++){
        print('${body[i]['name']}');
         OrdreDetail item = OrdreDetail(
          body[i]['unit'],
          body[i]['id'],
          body[i]['product_id'],
          body[i]['order_id'],
          body[i]['name'],
          double.parse(body[i]['price'].toString()),
          double.parse(body[i]['totol'].toString()),
          body[i]['qty'],
          body[i]['created_at'],
        );
        _detail.add(item);
      }
      // body.forEach((e) async {
      //   print(' e[name] ${e['name']}');
      //   // print(' e[name] ${e['name']}');
      //   OrdreDetail item = OrdreDetail(
      //     e['unit'],
      //     e['id'],
      //     e['product_id'],
      //     e['order_id'],
      //     e['name'],
      //     e['price'],
      //     e['totol'],
      //     e['qty'],
      //     e['created_at'],
      //   );
      //   _detail.add(item);
      // });
    }
    listData = _detail2;
    // print('_detail');
    print(_detail);
    // print('_detail2');
    // print(_detail2.length);
    return _detail;
  }

  Future<List<int>> ticket(PaperSize paper, CapabilityProfile profile,
      order_detail, order, customer, user, branch) async {
    print('order_detail ${order_detail.length}');
    final Generator generator = Generator(paper, profile);
    // Uint8List encThai41 = await CharsetConverter.encode('TIS-620', 'สวัวสดีนี้คือการทดสอบภาษา81ไทย');
    List<int> bytes = [];
     bytes += generator.setGlobalCodeTable('CP1250');
     
    // Print image
    // bytes += generator.image(image);
      bytes += generator.text('MTN',
      styles: PosStyles(
        height: PosTextSize.size3,
        width: PosTextSize.size5,
        bold: true,
         align: PosAlign.center,
      ));
    // bytes += generator.textEncoded(
    //     await CharsetConverter.encode('TIS-620', 'M T N'),
    //     styles: PosStyles(bold: true, align: PosAlign.center,)); //LOGO
    bytes += generator.textEncoded(
        await CharsetConverter.encode('TIS-620', '${branch[0]}'),
        styles: PosStyles(bold: true, align: PosAlign.center)); //ชื่อร้าน สาขา
    bytes += generator.textEncoded(
        await CharsetConverter.encode('TIS-620', '${branch[1]}'),
        styles: PosStyles(align: PosAlign.center)); //ชื่อร้าน สาขา
    bytes += generator.hr();
    //  bytes += generator.feed(2);
    Uint8List et3 = await CharsetConverter.encode('TIS-620', 'ใบเสร็จ/สินค้า');
    bytes += generator.textEncoded(et3,
        styles: PosStyles(align: PosAlign.center)); //ชื่อร้าน สาขา

    bytes += generator.hr();
    Uint8List etr1 = await CharsetConverter.encode('TIS-620', 'จำนวน');
    Uint8List etr2 = await CharsetConverter.encode('TIS-620', 'สินค้า');
    Uint8List etr3 = await CharsetConverter.encode('TIS-620', 'ราคา');
    Uint8List etr4 = await CharsetConverter.encode('TIS-620', 'รวม');
    bytes += generator.row([
      PosColumn(
        textEncoded: etr1,
        width: 3,
        styles: PosStyles(align: PosAlign.left, underline: true, bold: true),
      ),
      PosColumn(
        textEncoded: etr2,
        width: 5,
        styles: PosStyles(align: PosAlign.left, underline: true, bold: true),
      ),
      PosColumn(
        textEncoded: etr3,
        width: 2,
        styles: PosStyles(align: PosAlign.right, underline: true, bold: true),
      ),
      PosColumn(
        textEncoded: etr4,
        width: 2,
        styles: PosStyles(align: PosAlign.right, underline: true, bold: true),
      ),
    ]);

    for (int i = 0; i < order_detail.length; i++) {
          print('name $i: ${order_detail[i].name}');
          print('qty $i : ${order_detail[i].qty}');
          print('price $i : ${order_detail[i].price}');
      bytes += generator.row([
        PosColumn(
          textEncoded: await CharsetConverter.encode(
              'TIS-620', '${order_detail[i].qty}'),
          width: 2,
          styles: PosStyles(
            align: PosAlign.center,
          ),
        ),
        PosColumn(
          textEncoded: await CharsetConverter.encode(
              'TIS-620', '${order_detail[i].name}'),
          width: 5,
          styles: PosStyles(
            align: PosAlign.left,
          ),
        ),
        PosColumn(
          textEncoded: await CharsetConverter.encode(
              'TIS-620', '${order_detail[i].price}'),
          width: 2,
          styles: PosStyles(
            align: PosAlign.right,
          ),
        ),
        PosColumn(
          textEncoded: await CharsetConverter.encode(
              'TIS-620', '${order_detail[i].totol}'),
          width: 3,
          styles: PosStyles(
            align: PosAlign.right,
          ),
        ),
      ]);
    }
    bytes += generator.hr();
    bytes += generator.textEncoded(
        await CharsetConverter.encode('TIS-620', 'รวม ฿${order[0].cash_totol}'),
        styles: PosStyles(bold: true, align: PosAlign.right));
    bytes += generator.textEncoded(
        await CharsetConverter.encode('TIS-620', 'สวนลด ฿${order[0].discount}'),
        styles: PosStyles(align: PosAlign.right));
    bytes += generator.textEncoded(
        await CharsetConverter.encode(
            'TIS-620', 'ยอดสุทธิ ฿${order[0].net_amount}'),
        styles: PosStyles(align: PosAlign.right));
    bytes += generator.textEncoded(
        await CharsetConverter.encode(
            'TIS-620', 'รับเงิน ${order[0].paid_by}  ฿${order[0].cash}'),
        styles: PosStyles(align: PosAlign.right));
    bytes += generator.textEncoded(
        await CharsetConverter.encode('TIS-620', 'เงินทอน ฿${order[0].change}'),
        styles: PosStyles(align: PosAlign.right));

    bytes += generator.feed(1);
    bytes += generator.hr();
    bytes += generator.textEncoded(
        await CharsetConverter.encode('TIS-620', 'ลูกค้า :$customer'),
        styles: PosStyles(align: PosAlign.left));
    bytes += generator.textEncoded(
        await CharsetConverter.encode('TIS-620', 'พนักงานขาย : $user'),
        styles: PosStyles(align: PosAlign.left));
    final now = DateTime.now();
    final formatter = DateFormat('MM/dd/yyyy H:m');
    final String timestamp = formatter.format(now);
    bytes += generator.textEncoded(
        await CharsetConverter.encode('TIS-620', 'วันเวลา : ${order[0].created_at}'),
        styles: PosStyles(align: PosAlign.left));
    bytes += generator.textEncoded(
        await CharsetConverter.encode('TIS-620', 'เลขที่ใบเสร็จ : ${order[0].id}'),
        styles: PosStyles(align: PosAlign.left));
    bytes += generator.hr();
    bytes += generator.feed(1);

    bytes += generator.textEncoded(
        await CharsetConverter.encode('TIS-620', 'ขอบพระคุณที่มาอุดหนุนนะคะ'),
        styles: PosStyles(align: PosAlign.center));
    // bytes += generator.feed(1);
    bytes += generator.cut();
    bytes += generator.drawer();
    bytes += generator.beep();
    // bytes += generator.disconnect();
    // bytes += generator.;
    return bytes;
  }
}
