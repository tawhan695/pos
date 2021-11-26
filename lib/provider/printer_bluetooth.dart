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

import 'customer_provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class ESC with ChangeNotifier {
  //  late SharedPreferences localStorage;
  PrinterBluetoothManager printerManager = PrinterBluetoothManager();
  var _devices_select = null;
  var _pageSize = '58 mm';
  // late  Image image;
  List listData = [];
  var USER = '';

  intESC(PrinterBluetooth printer) async {
    _devices_select = printer;
    //   final ByteData data = await rootBundle.load('assets/images/5942.png');
    //  final Uint8List buf = data.buffer.asUint8List();
    //   image = decodeImage(buf)!;
    // print(buf);
    notifyListeners();
  }

  getESC() {
    return _devices_select;
  }

  setPaperSize(paper) {
    _pageSize = paper;
  }

  getPaperSize() {
    return _pageSize;
  }

  void Print(order,customer,user) async {
    print('order ${order}');
    print(order);
    List or = await detail(order);
    List o1 =await orderload(order);
    // print(or[0].name);

    var Paper;
    if (_pageSize == '58 mm') {
      Paper = PaperSize.mm58;
    } else if (_pageSize == '80 mm') {
      Paper = PaperSize.mm80;
    }
    try {
      printerManager.selectPrinter(_devices_select);
    } catch (e) {
      showToast('ไม่ได้เชื่อมต่อเครื่องปริ้น');
    }
    final profile = await CapabilityProfile.load();
    // TEST PRINT
    final PosPrintResult res =
        await printerManager.printTicket(await ticket(Paper, profile, or,o1,customer,user));
    showToast(res.msg);
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
             body['cash_totol'],
             body['cash'],
             body['discount'],
             body['net_amount'],
             body['change'],
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
      // print(body);
      body.forEach((e) async {
        // print(e);
        OrdreDetail item = OrdreDetail(
          e['unit'],
          e['id'],
          e['product_id'],
          e['order_id'],
          e['name'],
          e['price'],
          e['totol'],
          e['qty'],
          e['created_at'],
        );
        _detail.add(item);
        //  Uint8List  vv;
        //  vv =getUint8List(e['name']);
        //  print(vv);
        //  _detail2.add(
        //    vv
        //   );
      });
    }
    listData = _detail2;
    print('_detail');
    print(_detail.length);
    print('_detail2');
    print(_detail2.length);
    // listData =  _detail;
    return _detail;
  }

  Future<List<int>> ticket(
      PaperSize paper, CapabilityProfile profile, order_detail,order,customer,user) async {
    final Generator generator = Generator(paper, profile);
    // Uint8List encThai41 = await CharsetConverter.encode('TIS-620', 'สวัวสดีนี้คือการทดสอบภาษา81ไทย');
    List<int> bytes = [];
    // Print image
    // bytes += generator.image(image);
    bytes += generator.textEncoded(
        await CharsetConverter.encode('TIS-620', 'มัทนาไข่สด(สาขา2)'),
        styles: PosStyles(bold: true, align: PosAlign.center)); //ชื่อร้าน สาขา
    bytes += generator.textEncoded(
        await CharsetConverter.encode('TIS-620',
            'หจก.มัทนาไข่สด ฟาร์ม (สาขา2) ที่อยู่ 260/8 บ.หนองเม็ก ต.นาหัวบ่อ อ.พรรณานิคม จ.สกลนคร 47220 เปิดให้บริการทุกวัน จันทร์ - อาทิตย์ วลา 08.00 - 18.00 น.'),
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
          width: 6,
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
          width: 2,
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
        await CharsetConverter.encode('TIS-620', 'ยอดสุทธิ ฿${order[0].net_amount}'),
        styles: PosStyles(align: PosAlign.right));
    bytes += generator.textEncoded(
        await CharsetConverter.encode('TIS-620', 'รับเงิน ${order[0].paid_by}  ฿${order[0].cash}'),
        styles: PosStyles(align: PosAlign.right));
    bytes += generator.textEncoded(
        await CharsetConverter.encode('TIS-620', 'เงินทอน ฿${order[0].change}'),
        styles: PosStyles(align: PosAlign.right));

    bytes += generator.feed(1);
    bytes += generator.hr();
    bytes += generator.textEncoded(
        await CharsetConverter.encode('TIS-620', 'ลูกค้า :$customer'),
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.textEncoded(
        await CharsetConverter.encode('TIS-620', 'พนักงานขาย : $user'),
        styles: PosStyles(align: PosAlign.center));
    final now = DateTime.now();
    final formatter = DateFormat('MM/dd/yyyy H:m');
    final String timestamp = formatter.format(now);
    bytes += generator.textEncoded(
        await CharsetConverter.encode('TIS-620', 'วันเวลา : $timestamp'),
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.hr();
    bytes += generator.feed(1);

    bytes += generator.textEncoded(
        await CharsetConverter.encode('TIS-620', 'ขอบพระคุณที่มาอุดหนุนนะคะ'),
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.feed(2);
    bytes += generator.cut();
    return bytes;
  }
}
