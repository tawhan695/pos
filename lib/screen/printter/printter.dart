import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart' hide Image;
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'dart:io' show Platform;
import 'package:image/image.dart';
import 'package:oktoast/oktoast.dart';
import 'package:intl/intl.dart';
import 'package:pos/provider/printer_bluetooth.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:charset_converter/charset_converter.dart';
// import 'package:path_provider/path_provider.dart';

class Printer extends StatefulWidget {
  // Printter({Key? key}) : super(key: key);

  @override
  _PrintterState createState() => _PrintterState();
}

class _PrintterState extends State<Printer> {
  String dropdownValue = '58 mm';
  PrinterBluetoothManager printerManager = new PrinterBluetoothManager();
  List<PrinterBluetooth> _devices = [];
  late SharedPreferences localStorage;
  var _devices_select = null;
  bool isPrinting = false;
  List<String> _char = [];
  var Devices;
  @override
  void initState() {
    super.initState();
 printerManager.scanResults.listen((devices) async {
      // print('UI: Devices found ${devices.length}');
      setState(() {
        _devices = devices;
      });
    });
  }

 void _startScanDevices() {
    setState(() {
      _devices = [];
    });
    printerManager.startScan(Duration(seconds: 4));
  }

  void _stopScanDevices() {
    printerManager.stopScan();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // _stopScanDevices();
  }


  void _testPrint(PrinterBluetooth printer) async {
    setState(() {
      isPrinting = true;
    });
    try {
    printerManager.selectPrinter(printer);
    const PaperSize paper = PaperSize.mm58;
    final profile = await CapabilityProfile.load();
    // TEST PRINT
    final PosPrintResult res =
        await printerManager.printTicket(await testgenerator(paper, profile));
    showToast(res.msg);
    }catch (e) {
        setState(() {
      isPrinting = false;
    });
    showToast(e.toString());
    }

    setState(() {
      isPrinting = false;
    });
  }

  Widget setupAlertDialoadContainer() {
          print(_devices.length);
    return 
    //  _devices.length <= 0 ?
    Column(
      children: [
        // ค้นหา
        
        StreamBuilder<bool>(
        stream: printerManager.isScanningStream,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data!) {
            return Row(
          children: [
            Text('กำลังค้นหา..'),
            CircularProgressIndicator()
          ],
        );
          } else {
            return Container(
      height: 500.0, // Change as per your requirement
      width: 500.0, // Change as per your requirement
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _devices.length,
        itemBuilder: (BuildContext context, int index) {
          return _devices.length <= 0
              ? Text('ไม่มีข้อมูล')
              : Column(
                children: [
                  // Text('กำลังค้นหา..'),
                  InkWell(
                      onTap: () {
                        print(_devices[index]);
                        // setState(() {
                        //   // _devices_select = _devices[index];
                          Provider.of<ESC>(context, listen: false)
                              .intESC(_devices[index]);

                          setState(() {
                            _devices_select =
                                Provider.of<ESC>(context, listen: false).getESC();
                          });
                        //   // localStorage.setString('blue', _devices[index].address.toString());
                        //   // SharedPreferences.setMockInitialValues (PrinterBluetooth _devices_select);
                        Navigator.pop(context);
                        //   // localStorage.setMockInitialValues(_devices_select);
                        // });
                        // // _testPrint();
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(_devices[index].name ?? ''),
                          Text(_devices[index].address!),
                          Text(
                            'เลือกให้ตรงชื่อเครื่องปริ้นเด้อ',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ),
                ],
              );
        },
      ),
    );
          }
        },
      ),
      ],
    );
    
    
  }
  Future<List<int>> testgenerator(
      PaperSize paper, CapabilityProfile profile) async {
    final Generator generator = Generator(paper, profile);
        // final rofile = await CapabilityProfile.load();
    // Uint8List encThai41 = await CharsetConverter.encode('TIS-620', 'สวัวสดีนี้คือการทดสอบภาษา81ไทย');
    // Provider.of<ESC>(context, listen: false).
    List<int> bytes = [];
    // bytes += generator.setGlobalCodeTable('RK1048');
    bytes += generator.setGlobalCodeTable('CP1250');
    // bytes += generator.setGlobalCodeTable('TM-T20');
    bytes += generator.textEncoded(
        await CharsetConverter.encode('TIS-620', 'ทดสอบ')); //ชื่อร้าน สาขา
    bytes += generator.textEncoded(
        await CharsetConverter.encode('TIS620', 'หจก.มัทนาไข่สด ฟาร์ม')); //ชื่อร้าน สาขา
          
     bytes += generator.feed(2);
     bytes +=generator.feed(2);
     bytes +=generator.cut();
    return bytes;
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ตั้งค่าเครื่องปริ้น'),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 200, right: 200),
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('ขนาดเครื่องพิมพ์', style: TextStyle(fontSize: 25)),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButton<String>(
                          value: Provider.of<ESC>(context, listen: false)
                              .getPaperSize(),
                          icon: const Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
                          style: const TextStyle(color: Colors.deepPurple),
                          underline: Container(
                            height: 2,
                            color: Colors.deepPurpleAccent,
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              // dropdownValue = newValue!;
                              print(' เลือกขานด $dropdownValue');
                              Provider.of<ESC>(context, listen: false)
                                  .setPaperSize(newValue);
                            });
                          },
                          items: <String>[
                            '58 mm',
                            '80 mm',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child:
                                  Text(value, style: TextStyle(fontSize: 25)),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('เครื่องพิมพ์', style: TextStyle(fontSize: 25)),
                      Card(
                        margin: EdgeInsets.all(10),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Center(
                              child: Text(
                            // print(_devices_select);
                            Provider.of<ESC>(context, listen: false).getESC() ==
                                    null
                                ? 'ยังไม่เลือก'
                                : '${Provider.of<ESC>(context, listen: false).getESC().name}',
                            style: TextStyle(fontSize: 20, color: Colors.grey),
                          )),
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(16.0),
                          primary: Colors.white,
                          backgroundColor: Colors.orange,
                          textStyle: const TextStyle(fontSize: 20),
                        ),
                        onPressed: () {
                          _startScanDevices();
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('โปรดเลือก'),
                                  content: setupAlertDialoadContainer(),
                                );
                              });

                          // _stopScanDevices();
                          // print('หยุดการค้นหา');
                        },
                        child: Text(
                            _devices_select == null ? 'ค้นหา' : 'เลือกใหม่'),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 200,
                  height: 80,
                  padding: EdgeInsets.only(
                    left: 280,
                    right: 280,
                  ),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(16.0),
                      primary: Colors.white,
                      backgroundColor: Colors.orange,
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    onPressed: () => _devices_select != null
                        ? _testPrint(_devices_select)
                        : null,
                    child: Container(
                      child: isPrinting
                          ? CircularProgressIndicator()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.print),
                                Text('พิมพ์ทดสอบ'),
                              ],
                            ),
                    ),
                  ),
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
