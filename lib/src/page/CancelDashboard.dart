import 'package:flutter/material.dart';
import 'package:testapp/src/model/OrdersModel.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart' as intl;
import 'package:testapp/src/model/DemoLocalization.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CancelDashboardPage extends StatefulWidget {
  final args;
  const CancelDashboardPage({Key key, this.args}) : super(key: key);

  @override
  _CancelDashboardPageState createState() =>
      _CancelDashboardPageState(args: this.args);
}

class _CancelDashboardPageState extends State<CancelDashboardPage> {
  var args;
  _CancelDashboardPageState({this.args});

  int dur;
  DateTime fromDate1;
  DateTime endDate1;
  List<OrdersModel> listCompletedOrders;
  List<OrdersModel> cancelledLists;
  DemoLocalizationsDelegate delegate = new DemoLocalizationsDelegate();
  DemoLocalizations localization;
  int lang_status = -1;

  @override
  void initState() {
    super.initState();
    setState(() {
      dur = args[0];
      fromDate1 = args[1];
      endDate1 = args[2];
      listCompletedOrders = args[3];
      cancelledLists = args[4];
      localization = new DemoLocalizations();
    });
  }
  void getLangStatus() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int value = prefs.getInt("lang_status");
    setState(() {
      lang_status = value;
    });
    if(lang_status == 1){
      Locale locale = Locale("en");
      localization = await delegate.load(locale);
    }
    if(lang_status == 0 || lang_status == null){
      Locale locale = Locale("ar");
      localization = await delegate.load(locale);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: Container(color: Colors.black87),
              flex: 2,
            ),
            Expanded(
              child: Container(color: Colors.transparent),
              flex: 5,
            ),
          ],
        ),
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              ListTile(
                contentPadding:
                    EdgeInsets.only(left: 16, right: 16, top: 30, bottom: 20),
                title: Text(localization.getText("canceled"),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 56,
                      fontWeight: FontWeight.bold),
                  textDirection: lang_status == 0 ? TextDirection.rtl : TextDirection.ltr,
                  textAlign: TextAlign.center,
                ),
                subtitle: Text(localization.getText("cancelled orders"),
                  style: TextStyle(
                      color: Colors.amber,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                  textDirection: lang_status == 0 ? TextDirection.rtl : TextDirection.ltr,
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Container(
                  height: 200.0,
                  padding:
                      EdgeInsets.only(left: 16, right: 16, bottom: 0, top: 40),
                  child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: GridView.count(
                          crossAxisSpacing: 1,
                          mainAxisSpacing: 1,
                          crossAxisCount: 2,
                          childAspectRatio: 1.9,
                          children: [
                            DateTimeField(
                              readOnly: true,
                              format: intl.DateFormat("MM-dd-yyyy"),
                              initialValue:
                                  DateTime.now().subtract(Duration(days: dur)),
                              onChanged: (DateTime newValue) {
                                setState(() {
                                  fromDate1 = newValue;
                                });
                                // event
                                if (endDate1 != null && fromDate1 != null) {
                                  var diff =
                                      endDate1.difference(fromDate1).inDays;

                                  List<OrdersModel> tempList = [];
                                  if (diff >= 0) {
                                    for (var i = 0;
                                        i < listCompletedOrders.length;
                                        i++) {
                                      var dt = DateTime.parse(
                                          listCompletedOrders[i]
                                              .Date_Order
                                              .toString());
                                      var dff1 =
                                          endDate1.difference(dt).inHours;
                                      var dff2 =
                                          dt.difference(fromDate1).inHours;

                                      if (dff1 >= 0 &&
                                          dff2 >= 0 &&
                                          listCompletedOrders[i].Order_Status ==
                                              "Cancelled") {
                                        tempList.add(listCompletedOrders[i]);
                                      }
                                      setState(() {
                                        cancelledLists = tempList;
                                      });
                                    }
                                  }
                                }
                              },
                              onShowPicker: (context, currentValue) {
                                return showDatePicker(
                                    context: context,
                                    firstDate: new DateTime(1900),
                                    initialDate: currentValue ?? DateTime.now(),
                                    lastDate: new DateTime(2100));
                              },
                            ),
                            DateTimeField(
                              //readOnly: true,
                              format: intl.DateFormat("MM-dd-yyyy"),
                              initialValue: DateTime.now(),
                              onChanged: (DateTime newValue) {
                                setState(() {
                                  endDate1 = newValue;
                                });

                                // event
                                if (endDate1 != null && fromDate1 != null) {
                                  var diff =
                                      endDate1.difference(fromDate1).inDays;

                                  List<OrdersModel> tempList = [];
                                  if (diff >= 0) {
                                    for (var i = 0;
                                        i < listCompletedOrders.length;
                                        i++) {
                                      var dt = DateTime.parse(
                                          listCompletedOrders[i]
                                              .Date_Order
                                              .toString());
                                      var dff1 =
                                          endDate1.difference(dt).inHours;
                                      var dff2 =
                                          dt.difference(fromDate1).inHours;

                                      if (dff1 >= 0 &&
                                          dff2 >= 0 &&
                                          listCompletedOrders[i].Order_Status ==
                                              "Cancelled") {
                                        tempList.add(listCompletedOrders[i]);
                                      }
                                      setState(() {
                                        cancelledLists = tempList;
                                      });
                                    }
                                  }
                                }
                              },
                              onShowPicker: (context, currentValue) {
                                return showDatePicker(
                                    context: context,
                                    firstDate: new DateTime(1900),
                                    initialDate: currentValue ?? DateTime.now(),
                                    lastDate: new DateTime(2100));
                              },
                            ),
                            Card(
                              color: Colors.green,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              child: Center(
                                  child: Column(
                                mainAxisSize: MainAxisSize.min,
                                textDirection: TextDirection.rtl,
                                children: <Widget>[
                                  Text(localization.getText("total count"),
                                    style: TextStyle(
                                        fontSize: 28,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                    textDirection: lang_status == 0 ? TextDirection.rtl : TextDirection.ltr,
                                  ),
                                  Text(
                                    '${cancelledLists.length}',
                                    style: TextStyle(
                                        fontSize: 42,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                    textDirection: lang_status == 0 ? TextDirection.rtl : TextDirection.ltr,
                                  )
                                ],
                              )),
                            )
                          ])),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
