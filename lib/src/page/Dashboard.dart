import 'package:flutter/material.dart';
import 'package:testapp/src/model/OrdersModel.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart' as intl;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testapp/src/model/DemoLocalization.dart';

class DashboardPage extends StatefulWidget {
  final args;
  const DashboardPage({Key key, this.args}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState(args: this.args);
}

class _DashboardPageState extends State<DashboardPage> {
  var args;
  _DashboardPageState({this.args});
  int dur;
  DateTime fromDate;
  DateTime endDate;
  double totalPrice;
  double totalDriverPrice;
  double companyMoney;
  List<OrdersModel> listCompletedOrders;
  List<OrdersModel> completedLists;
  double customerPrice;
  double percentage;
  bool saleFlag;
  int lang_status = -1;
  DemoLocalizationsDelegate delegate = new DemoLocalizationsDelegate();
  DemoLocalizations localization;
  int a = -1;

  @override
  void initState() {
    
    setState(() {
      dur = args[0];
      fromDate = args[1];
      endDate = args[2];
      totalPrice = args[3];
      totalDriverPrice = args[4];
      companyMoney = args[5];
      listCompletedOrders = args[6];
      completedLists = args[7];
      customerPrice = args[8];
      percentage = args[9];
      saleFlag = args[10];
      localization = new DemoLocalizations();
      getLangStatus();
    });
    super.initState();
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
            children: <Widget>[
              ListTile(
                contentPadding:
                    EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 20),
                title: Text(localization.getText("dashboard"),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 56,
                      fontWeight: FontWeight.bold),
                  textDirection: lang_status == 0 ? TextDirection.rtl : TextDirection.ltr,
                  textAlign: TextAlign.center,
                ),
                subtitle: Text(localization.getText("complete orders"),
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
                  // padding:
                  //     EdgeInsets.only(left: 16, right: 16, bottom: 0, top: 50),
                  child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: GridView.count(
                          crossAxisSpacing: 1,
                          mainAxisSpacing: 1.2,
                          crossAxisCount: 2,
                          childAspectRatio: 1.9,
                          padding: EdgeInsets.only(
                              left: 16, right: 16, bottom: 0, top: 40),
                          children: [
                            DateTimeField(
                              readOnly: true,
                              format: intl.DateFormat("MM-dd-yyyy"),
                              initialValue:
                                  DateTime.now().subtract(Duration(days: dur)),
                              onChanged: (DateTime newValue) {
                                setState(() {
                                  fromDate = newValue;
                                });
                                // event
                                if (endDate != null && fromDate != null) {
                                  var diff =
                                      endDate.difference(fromDate).inDays;
                                  totalPrice = 0;
                                  totalDriverPrice = 0;
                                  customerPrice = 0;
                                  List<OrdersModel> tempList = [];
                                  if (diff >= 0) {
                                    for (var i = 0;
                                        i < listCompletedOrders.length;
                                        i++) {
                                      var dt = DateTime.parse(
                                          listCompletedOrders[i]
                                              .Date_Order
                                              .toString());
                                      var dff1 = endDate.difference(dt).inHours;
                                      var dff2 =
                                          dt.difference(fromDate).inHours;

                                      if (dff1 >= 0 &&
                                          dff2 >= 0 &&
                                          listCompletedOrders[i].Order_Status ==
                                              "Completed") {
                                        totalPrice += double.parse(
                                            listCompletedOrders[i].Final_Price);
                                        totalDriverPrice += double.parse(
                                                listCompletedOrders[i]
                                                    .Driver_Price) *
                                            percentage;
                                        customerPrice += double.parse(
                                            listCompletedOrders[i]
                                                .Customer_Price);
                                        tempList.add(listCompletedOrders[i]);
                                      }
                                    }
                                  }
                                  setState(() {
                                    totalPrice = totalPrice;
                                    totalDriverPrice = totalDriverPrice;
                                    customerPrice = customerPrice;
                                    companyMoney =
                                        totalPrice - totalDriverPrice;
                                    completedLists = tempList;
                                    percentage = percentage;
                                  });
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
                                  endDate = newValue;
                                });

                                // event
                                if (endDate != null && fromDate != null) {
                                  var diff =
                                      endDate.difference(fromDate).inDays;
                                  totalPrice = 0;
                                  totalDriverPrice = 0;
                                  customerPrice = 0;
                                  companyMoney = 0;

                                  List<OrdersModel> tempList = [];
                                  if (diff >= 0) {
                                    for (var i = 0;
                                        i < listCompletedOrders.length;
                                        i++) {
                                      var dt = DateTime.parse(
                                          listCompletedOrders[i]
                                              .Date_Order
                                              .toString());
                                      var dff1 = endDate.difference(dt).inHours;
                                      var dff2 =
                                          dt.difference(fromDate).inHours;

                                      if (dff1 >= 0 &&
                                          dff2 >= 0 &&
                                          listCompletedOrders[i].Order_Status ==
                                              "Completed") {
                                        totalPrice += double.parse(
                                            listCompletedOrders[i].Final_Price);
                                        totalDriverPrice += double.parse(
                                                listCompletedOrders[i]
                                                    .Driver_Price) *
                                            percentage;
                                        customerPrice += double.parse(
                                            listCompletedOrders[i]
                                                .Customer_Price);
                                        tempList.add(listCompletedOrders[i]);
                                      }
                                    }
                                  }
                                  setState(() {
                                    totalPrice = totalPrice;
                                    totalDriverPrice = totalDriverPrice;
                                    companyMoney =
                                        totalPrice - totalDriverPrice;
                                    customerPrice = customerPrice;
                                    completedLists = tempList;
                                    percentage = percentage;
                                  });
                                }
                              },
                              onShowPicker: (context, currentValue) {
                                print(currentValue);
                                return showDatePicker(
                                    context: context,
                                    firstDate: new DateTime(1900),
                                    initialDate: currentValue ?? DateTime.now(),
                                    lastDate: new DateTime(2100));
                              },
                            ),
                            if(saleFlag == true)
                              Card(
                                color: Colors.green,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                child: Center(
                                    child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(localization.getText("total price"),
                                      style: TextStyle(
                                          fontSize: 26,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                      textDirection: lang_status == 0 ? TextDirection.rtl : TextDirection.ltr,
                                    ),
                                    Text(
                                      '\$${totalPrice.toString()}',
                                      style: TextStyle(
                                          fontSize: 40,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                )),
                              ),
                            
                            Card(
                              color: Colors.green,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              child: Center(
                                  child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(localization.getText("total count"),
                                    style: TextStyle(
                                        fontSize: 26,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                    textDirection: lang_status == 0 ? TextDirection.rtl : TextDirection.ltr ,
                                  ),
                                  Text(
                                    '${completedLists.length}',
                                    style: TextStyle(
                                        fontSize: 40,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              )),
                            ),
                            if(saleFlag == true) 
                              Card(
                                color: Colors.green,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                child: Center(
                                    child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(localization.getText("total driver"),
                                      style: TextStyle(
                                          fontSize: 26,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                      textDirection: lang_status == 0 ? TextDirection.rtl : TextDirection.ltr,
                                    ),
                                    Text(
                                      '\$${totalDriverPrice.toString()}',
                                      style: TextStyle(
                                          fontSize: 40,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                )),
                              ),
                            
                            if(saleFlag == true) 
                              Card(
                                color: Colors.green,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                child: Center(
                                    child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(localization.getText("company money"),
                                      style: TextStyle(
                                          fontSize: 24,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                      textDirection: lang_status == 0 ? TextDirection.rtl : TextDirection.ltr,
                                    ),
                                    Text(
                                      '\$${companyMoney.toString()}',
                                      style: TextStyle(
                                          fontSize: 36,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                )),
                              ),
                            if(saleFlag == false)
                              Card(
                                color: Colors.green,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                child: Center(
                                    child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(localization.getText("customer price"),
                                      style: TextStyle(
                                          fontSize: 24,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                      textDirection: lang_status == 0 ? TextDirection.rtl : TextDirection.ltr,
                                    ),
                                    Text(
                                      '\$${customerPrice.toString()}',
                                      style: TextStyle(
                                          fontSize: 36,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
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
