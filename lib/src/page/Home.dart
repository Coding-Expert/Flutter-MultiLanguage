import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testapp/src/model/OrdersModel.dart';
import 'dart:async';
import 'dart:convert';
import 'package:testapp/src/page/Login.dart';
import 'package:testapp/src/page/Dashboard.dart';
import 'package:testapp/src/page/CancelDashboard.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:testapp/src/page/Helper.dart';
import 'package:testapp/src/page/About.dart';
import 'package:testapp/src/model/DemoLocalization.dart';

class Home extends StatefulWidget {
  final args;
  Home({this.args});

  static const String routeName = "home";

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  _HomeState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          if (this.orderFlag) {
            filteredListOrders = listOrders;
          } else {
            filteredListOrders = listCompletedOrders;
          }
        });
      } else {
        setState(() {
          _searchText = _filter.text;
          checkList(this.orderFlag);
          print("triger(home constructor)");
        });
      }
    });
  }
//  String urlApi = "https://transporter.group/wp-json/wc/v1/order/1";
  final TextEditingController _filter = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // final TextEditingController _initNote = new TextEditingController();
  String tempNote = "";
  String _searchText = "";
  String user = "";
  int idUser = 0;
  bool saleFlag;
  int lang_status;
  int temp_value = 0;

  int currentIndex = 0;
  bool orderFlag = true;

  DateTime startOfPeriod;
  DateTime endOfPeriod;
  DateTime firstDate;
  DateTime lastDate;
  DateTime fromDate;
  DateTime endDate = DateTime.now();
  DateTime fromDate1;
  DateTime endDate1 = DateTime.now();
  int dur = 0;
  int _radioValue = 0;
  List<String> ringTone = ['Arabic','English'];

  List<OrdersModel> listOrders = [];
  List<OrdersModel> listCompletedOrders = [];
  List<OrdersModel> filteredListOrders = [];
  List<OrdersModel> completedLists = [];
  List<OrdersModel> cancelledLists = [];
  List<OrdersModel> processingLists = [];
  double totalPrice = 0.0;
  double totalDriverPrice = 0.0;
  double companyMoney = 0.0;
  double customerPrice = 0.0;
  double percentage = 0.5;
  Icon _searchIcon = new Icon(Icons.search);
  DemoLocalizationsDelegate delegate = new DemoLocalizationsDelegate();
  DemoLocalizations localization;
  Widget _appBarTitle;
  
  void getAppBarTitle(){
    _appBarTitle = new Text(localization == null ? 'Order Count' : localization.getText('Order Count'));
  }

  _launchURL(BuildContext context, String number) async {
    String url = 'tel:$number';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(localization.getText("wrong number"),
          textDirection: TextDirection.rtl,
        ),
      ));
      // throw 'Could not launch $url';
    }
  }

  void onTabTapped(int index) async {
    setState(() {
      currentIndex = index;
      dur = dur;
    });

    switch (currentIndex) {
      case 0:
        {
          print("======");
          _searchIcon = new Icon(Icons.search);
          _appBarTitle = new Text(localization.getText("Order Count") + ": " + listOrders.length.toString(),
            textDirection: lang_status == 0 ? TextDirection.rtl :TextDirection.ltr,
          );
          setState(() {
            this.orderFlag = true;
            _filter.clear();
            this._searchText = '';
            filteredListOrders = listOrders;
            completedLists = [];
            cancelledLists = [];
          });
        }
        break;
      case 1:
        {
          print("=================\nCanccel Dashboard\n================");
          // this._searchIcon = null;
          _appBarTitle = new Text(localization.getText("Case order"),
            textDirection: lang_status == 0 ? TextDirection.rtl :TextDirection.ltr,
          );
          cancelledLists = [];
          for (var i = 0; i < listCompletedOrders.length; i++) {
            print(listCompletedOrders[i].Order_Status);
            if (listCompletedOrders[i].Order_Status == "Cancelled") {
              cancelledLists.add(listCompletedOrders[i]);
            }
          }
          setState(() {
            this.orderFlag = false;
            _filter.clear();
            this._searchText = '';
            filteredListOrders = [];
            cancelledLists = cancelledLists;
            completedLists = [];
          });
        }
        break;
      case 2:
        {
          print("=================\nDashboard\n================");
          totalPrice = 0.0;
          totalDriverPrice = 0.0;
          customerPrice = 0.0;
          completedLists = [];
          // this._searchIcon = null;
          _appBarTitle = new Text(localization.getText("Case order"),
            textDirection: lang_status == 0 ? TextDirection.rtl :TextDirection.ltr,
          );
          for (var i = 0; i < listCompletedOrders.length; i++) {
            if (listCompletedOrders[i].Order_Status == "Completed") {
              completedLists.add(listCompletedOrders[i]);
              totalPrice += double.parse(listCompletedOrders[i].Final_Price);
              totalDriverPrice +=
                  double.parse(listCompletedOrders[i].Driver_Price) * 0.5;
              customerPrice +=
                  double.parse(listCompletedOrders[i].Customer_Price);
            }
          }
          companyMoney = totalPrice - totalDriverPrice;
          setState(() {
            this.orderFlag = false;
            _filter.clear();
            this._searchText = '';
            filteredListOrders = [];
            completedLists = completedLists;
            cancelledLists = [];
            totalPrice = totalPrice;
            totalDriverPrice = totalDriverPrice;
            companyMoney = companyMoney;
            customerPrice = customerPrice;
            percentage = percentage;
          });
        }
        break;
      case 3:
        {
          print("+++++++");
          _searchIcon = new Icon(Icons.search);
          _appBarTitle = new Text(localization.getText("Case order"),
            textDirection: lang_status == 0 ? TextDirection.rtl :TextDirection.ltr,
          );
          setState(() {
            this.orderFlag = false;
            _filter.clear();
            this._searchText = '';
            filteredListOrders = listCompletedOrders;
            completedLists = [];
            cancelledLists = [];
          });
        }
        break;
    }
  }

  void fetchApi() async {
    print("FetchApi start");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String idInLocal = prefs.getString("id");
    saleFlag = prefs.getBool("saleFlag");
    int status_value = prefs.getInt("lang_status");
    print("current language: -------------------------------" + status_value.toString());
    String urlApi =
        "https://transporter.group/wp-json/wc/v1/order/$idInLocal/$saleFlag";
    print(urlApi);
    var datajson = await http.get(urlApi);
    var jsonDecoded = json.decode(datajson.body);
    print(jsonDecoded);
    // var jsonDecoded = [
    //   {'Customer_Name':'Luis Roy', 'Order_ID':'12', 'Order_Status':'processing'},
    //   {'Customer_Name':'Hen Ri', 'Order_ID':'112', 'Order_Status':'processing'},
    //   {'Customer_Name':'Wang Hua', 'Order_ID':'212', 'Order_Status':'processing'},
    //   {'Customer_Name':'Jai Ro', 'Order_ID':'312', 'Order_Status':'processing'},
    //   {'Customer_Name':'Jeffer Son', 'Order_ID':'412', 'Order_Status':'processing'},
    //   {'Customer_Name':'Luis Roy', 'Order_ID':'512', 'Order_Status':'processing'},
    //   {'Customer_Name':'Luis Roy', 'Order_ID':'612', 'Order_Status':'processing'},
    //   {'Customer_Name':'Hen Ri', 'Order_ID':'712', 'Order_Status':'processing'},
    //   {'Customer_Name':'Luis Roy', 'Order_ID':'812', 'Order_Status':'processing'},
    //   {'Customer_Name':'Luis Roy', 'Order_ID':'912', 'Order_Status':'processing'},
    //   {'Customer_Name':'Jai Ro', 'Order_ID':'1112', 'Order_Status':'processing'},
    //   {'Customer_Name':'Luis Roy', 'Order_ID':'2212', 'Order_Status':'processing'},
    //   {'Customer_Name':'Wang Hua', 'Order_ID':'2312', 'Order_Status':'processing'}
    // ];

    List<OrdersModel> tempListOrders = [];
    List<OrdersModel> tempListCompletedOrders = [];
    List<OrdersModel> newrequestOrders = [];

    if (jsonDecoded is List) {
      for (var index = 0; index < jsonDecoded.length; index++) {
        if (jsonDecoded[index]["Order_Status"] != "Completed" &&
            jsonDecoded[index]["Order_Status"] != "Cancelled" &&
            jsonDecoded[index]["Order_Status"] != "Done") {
          newrequestOrders.add(OrdersModel(
            Customer_Created: jsonDecoded[index]['Customer_Created'] ?? "",
            Customer_Email: jsonDecoded[index]['Customer_Email'] ?? "",
            Customer_FEUP_ID: jsonDecoded[index]['Customer_FEUP_ID'] ?? "",
            Customer_ID: jsonDecoded[index]['Customer_ID'] ?? "",
            Customer_Name: jsonDecoded[index]['Customer_Name'] ?? "",
            Customer_WP_ID: jsonDecoded[index]['Customer_WP_ID'] ?? "",
            Order_Customer_Notes:
                jsonDecoded[index]['Order_Customer_Notes'] ?? "",
            Order_Display: jsonDecoded[index]['Order_Display'] ?? "",
            Order_Email: jsonDecoded[index]['Order_Email'] ?? "",
            Order_External_Status:
                jsonDecoded[index]['Order_External_Status'] ?? "",
            Order_ID: jsonDecoded[index]['Order_ID'] ?? "",
            Order_Location: jsonDecoded[index]['Order_Location'] ?? "",
            Order_Name: jsonDecoded[index]['Order_Name'] ?? "",
            Order_Notes_Private:
                jsonDecoded[index]['Order_Notes_Private'] ?? "",
            Order_Notes_Public: jsonDecoded[index]['Order_Notes_Public'] ?? "",
            Order_Number: jsonDecoded[index]['Order_Number'] ?? "",
            Order_Payment_Completed:
                jsonDecoded[index]['Order_Payment_Completed'] ?? "",
            Order_Payment_Price:
                jsonDecoded[index]['Order_Payment_Price'] ?? "",
            Order_PayPal_Receipt_Number:
                jsonDecoded[index]['Order_PayPal_Receipt_Number'] ?? "",
            Order_Status: jsonDecoded[index]['Order_Status'] ?? "",
            Order_Status_Updated:
                jsonDecoded[index]['Order_Status_Updated'] ?? "",
            Order_Tracking_Link_Clicked:
                jsonDecoded[index]['Order_Tracking_Link_Clicked'] ?? "",
            Order_Tracking_Link_Code:
                jsonDecoded[index]['Order_Tracking_Link_Code'] ?? "",
            Order_View_Count: jsonDecoded[index]['Order_View_Count'] ?? "",
            Sales_Rep_Created: jsonDecoded[index]['Sales_Rep_Created'] ?? "",
            Sales_Rep_Email: jsonDecoded[index]['Sales_Rep_Email'] ?? "",
            Sales_Rep_First_Name:
                jsonDecoded[index]['Sales_Rep_First_Name'] ?? "",
            Sales_Rep_ID: jsonDecoded[index]['Sales_Rep_ID'] ?? "",
            Sales_Rep_Last_Name:
                jsonDecoded[index]['Sales_Rep_Last_Name'] ?? "",
            Sales_Rep_WP_ID: jsonDecoded[index]['Sales_Rep_WP_ID'] ?? "",
            WooCommerce_ID: jsonDecoded[index]['WooCommerce_ID'] ?? "",
            Zendesk_ID: jsonDecoded[index]['Zendesk_ID'] ?? "",
            Note: jsonDecoded[index]['Order_Notes_Public'] ?? "",
            Phone: jsonDecoded[index]['Phone'] ?? "",
            Final_Price: jsonDecoded[index]['Final_Price'] ?? "",
            Driver_Price: jsonDecoded[index]['Driver_Price'] ?? "",
            Customer_Price: jsonDecoded[index]['Customer_Price'] ?? "",
          ));
        }
      }
      for (var index = 0; index < jsonDecoded.length; index++) {
        if (jsonDecoded[index]['Order_Status'] == 'Completed' ||
            jsonDecoded[index]['Order_Status'] == 'Cancelled') {
          if (jsonDecoded[index]['Order_Status'] == 'Completed') {
            // jsonDecoded[index]['Order_Status'] = 'منجز';
            jsonDecoded[index]['Order_Status'] = 'Completed';
          } else if (jsonDecoded[index]['Order_Status'] == 'Cancelled') {
            // jsonDecoded[index]['Order_Status'] = 'ألغيت';
            jsonDecoded[index]['Order_Status'] = 'Cancelled';
          }
          tempListCompletedOrders.add(OrdersModel(
            Customer_Created: jsonDecoded[index]['Customer_Created'] ?? "",
            Customer_Email: jsonDecoded[index]['Customer_Email'] ?? "",
            Customer_FEUP_ID: jsonDecoded[index]['Customer_FEUP_ID'] ?? "",
            Customer_ID: jsonDecoded[index]['Customer_ID'] ?? "",
            Customer_Name: jsonDecoded[index]['Customer_Name'] ?? "",
            Customer_WP_ID: jsonDecoded[index]['Customer_WP_ID'] ?? "",
            Order_Customer_Notes:
                jsonDecoded[index]['Order_Customer_Notes'] ?? "",
            Order_Display: jsonDecoded[index]['Order_Display'] ?? "",
            Order_Email: jsonDecoded[index]['Order_Email'] ?? "",
            Order_External_Status:
                jsonDecoded[index]['Order_External_Status'] ?? "",
            Order_ID: jsonDecoded[index]['Order_ID'] ?? "",
            Order_Location: jsonDecoded[index]['Order_Location'] ?? "",
            Order_Name: jsonDecoded[index]['Order_Name'] ?? "",
            Order_Notes_Private:
                jsonDecoded[index]['Order_Notes_Private'] ?? "",
            Order_Notes_Public: jsonDecoded[index]['Order_Notes_Public'] ?? "",
            Order_Number: jsonDecoded[index]['Order_Number'] ?? "",
            Order_Payment_Completed:
                jsonDecoded[index]['Order_Payment_Completed'] ?? "",
            Order_Payment_Price:
                jsonDecoded[index]['Order_Payment_Price'] ?? "",
            Order_PayPal_Receipt_Number:
                jsonDecoded[index]['Order_PayPal_Receipt_Number'] ?? "",
            Order_Status: jsonDecoded[index]['Order_Status'] ?? "",
            Order_Status_Updated:
                jsonDecoded[index]['Order_Status_Updated'] ?? "",
            Order_Tracking_Link_Clicked:
                jsonDecoded[index]['Order_Tracking_Link_Clicked'] ?? "",
            Order_Tracking_Link_Code:
                jsonDecoded[index]['Order_Tracking_Link_Code'] ?? "",
            Order_View_Count: jsonDecoded[index]['Order_View_Count'] ?? "",
            Sales_Rep_Created: jsonDecoded[index]['Sales_Rep_Created'] ?? "",
            Sales_Rep_Email: jsonDecoded[index]['Sales_Rep_Email'] ?? "",
            Sales_Rep_First_Name:
                jsonDecoded[index]['Sales_Rep_First_Name'] ?? "",
            Sales_Rep_ID: jsonDecoded[index]['Sales_Rep_ID'] ?? "",
            Sales_Rep_Last_Name:
                jsonDecoded[index]['Sales_Rep_Last_Name'] ?? "",
            Sales_Rep_WP_ID: jsonDecoded[index]['Sales_Rep_WP_ID'] ?? "",
            WooCommerce_ID: jsonDecoded[index]['WooCommerce_ID'] ?? "",
            Zendesk_ID: jsonDecoded[index]['Zendesk_ID'] ?? "",
            Note: jsonDecoded[index]['Order_Notes_Public'] ?? "",
            Phone: jsonDecoded[index]['Phone'] ?? "",
            Final_Price: jsonDecoded[index]['Final_Price'] ?? "",
            Driver_Price: jsonDecoded[index]['Driver_Price'] ?? "",
            Customer_Price: jsonDecoded[index]['Customer_Price'] ?? "",
            Date_Order: jsonDecoded[index]['Date_Order'] ?? "",
          ));
        } else {
          if (jsonDecoded[index]['Order_Status'] == 'Processing') {
            // jsonDecoded[index]['Order_Status'] = 'معالجة';
            jsonDecoded[index]['Order_Status'] = 'Processing';

            tempListOrders.add(OrdersModel(
              Customer_Created: jsonDecoded[index]['Customer_Created'] ?? "",
              Customer_Email: jsonDecoded[index]['Customer_Email'] ?? "",
              Customer_FEUP_ID: jsonDecoded[index]['Customer_FEUP_ID'] ?? "",
              Customer_ID: jsonDecoded[index]['Customer_ID'] ?? "",
              Customer_Name: jsonDecoded[index]['Customer_Name'] ?? "",
              Customer_WP_ID: jsonDecoded[index]['Customer_WP_ID'] ?? "",
              Order_Customer_Notes:
                  jsonDecoded[index]['Order_Customer_Notes'] ?? "",
              Order_Display: jsonDecoded[index]['Order_Display'] ?? "",
              Order_Email: jsonDecoded[index]['Order_Email'] ?? "",
              Order_External_Status:
                  jsonDecoded[index]['Order_External_Status'] ?? "",
              Order_ID: jsonDecoded[index]['Order_ID'] ?? "",
              Order_Location: jsonDecoded[index]['Order_Location'] ?? "",
              Order_Name: jsonDecoded[index]['Order_Name'] ?? "",
              Order_Notes_Private:
                  jsonDecoded[index]['Order_Notes_Private'] ?? "",
              Order_Notes_Public:
                  jsonDecoded[index]['Order_Notes_Public'] ?? "",
              Order_Number: jsonDecoded[index]['Order_Number'] ?? "",
              Order_Payment_Completed:
                  jsonDecoded[index]['Order_Payment_Completed'] ?? "",
              Order_Payment_Price:
                  jsonDecoded[index]['Order_Payment_Price'] ?? "",
              Order_PayPal_Receipt_Number:
                  jsonDecoded[index]['Order_PayPal_Receipt_Number'] ?? "",
              Order_Status: jsonDecoded[index]['Order_Status'] ?? "",
              Order_Status_Updated:
                  jsonDecoded[index]['Order_Status_Updated'] ?? "",
              Order_Tracking_Link_Clicked:
                  jsonDecoded[index]['Order_Tracking_Link_Clicked'] ?? "",
              Order_Tracking_Link_Code:
                  jsonDecoded[index]['Order_Tracking_Link_Code'] ?? "",
              Order_View_Count: jsonDecoded[index]['Order_View_Count'] ?? "",
              Sales_Rep_Created: jsonDecoded[index]['Sales_Rep_Created'] ?? "",
              Sales_Rep_Email: jsonDecoded[index]['Sales_Rep_Email'] ?? "",
              Sales_Rep_First_Name:
                  jsonDecoded[index]['Sales_Rep_First_Name'] ?? "",
              Sales_Rep_ID: jsonDecoded[index]['Sales_Rep_ID'] ?? "",
              Sales_Rep_Last_Name:
                  jsonDecoded[index]['Sales_Rep_Last_Name'] ?? "",
              Sales_Rep_WP_ID: jsonDecoded[index]['Sales_Rep_WP_ID'] ?? "",
              WooCommerce_ID: jsonDecoded[index]['WooCommerce_ID'] ?? "",
              Zendesk_ID: jsonDecoded[index]['Zendesk_ID'] ?? "",
              Note: jsonDecoded[index]['Order_Notes_Public'] ?? "",
              Phone: jsonDecoded[index]['Phone'] ?? "",
              Final_Price: jsonDecoded[index]['Final_Price'] ?? "",
              Driver_Price: jsonDecoded[index]['Driver_Price'] ?? "",
              Customer_Price: jsonDecoded[index]['Customer_Price'] ?? "",
            ));
          }
        }
      }
    }

    totalPrice = 0.0;
    totalDriverPrice = 0.0;
    customerPrice = 0.0;
    processingLists = [];
    completedLists = [];
    cancelledLists = [];
    for (var i = 0; i < tempListCompletedOrders.length; i++) {
      if (tempListCompletedOrders[i].Order_Status != "Done") {
        processingLists.add(tempListCompletedOrders[i]);
      }
      if (tempListCompletedOrders[i].Order_Status == "Completed") {
        completedLists.add(tempListCompletedOrders[i]);
        totalPrice += double.parse(tempListCompletedOrders[i].Final_Price);
        totalDriverPrice +=
            double.parse(tempListCompletedOrders[i].Driver_Price) * percentage;
        customerPrice +=
            double.parse(tempListCompletedOrders[i].Customer_Price);
      }
    }
    for (var i = 0; i < tempListOrders.length; i++) {
      if (tempListOrders[i].Order_Status == "Cancelled") {
        cancelledLists.add(tempListOrders[i]);
      }
    }
    DateTime minDt;
    DateTime tempDt;
    for (var i = 0; i < tempListCompletedOrders.length; i++) {
      tempDt = DateTime.parse(tempListCompletedOrders[i].Date_Order);
      if (minDt == null) {
        minDt = tempDt;
      } else {
        if (minDt.difference(tempDt).inDays > 0) {
          minDt = tempDt;
        }
      }
    }
    print("mindate=====================");
    print(minDt);
    if (minDt == null) {
      minDt = DateTime.now();
    }
    dur = DateTime.now().difference(minDt).inDays + 1;
    fromDate = DateTime.now().subtract(Duration(days: dur));
    fromDate1 = DateTime.now().subtract(Duration(days: dur));

    // dur = 10;
    setState(() {
      dur = dur;
      listOrders = newrequestOrders;
      listCompletedOrders = tempListCompletedOrders;
      print('I am orderFlag ${this.orderFlag}');
      processingLists = processingLists;
      this.orderFlag = true;
      if (this.orderFlag) {
        filteredListOrders = listOrders;
      } else {
        filteredListOrders = [];
        completedLists = completedLists;
        totalPrice = totalPrice;
        totalDriverPrice = totalDriverPrice;
        companyMoney = totalPrice - totalDriverPrice;
        customerPrice = customerPrice;
        percentage = percentage;
      }
      
      lang_status = status_value;
      if(status_value == null){
        lang_status = 0;
      }
      setLanguage(lang_status);
    });
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          controller: _filter,
          textDirection: lang_status == 0 ? TextDirection.rtl : TextDirection.ltr,
          decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search), hintText: localization.getText("search")),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text(localization.getText("Status order"),
          textDirection: lang_status == 0 ? TextDirection.rtl :TextDirection.ltr,
        );
        filteredListOrders = listOrders;
        _filter.clear();
      }
    });
  }

  setAuthentication() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
//    await prefs.setString("user", user);
//    await prefs.setString("pass", idUser.toString());
    await prefs.setBool("isAuthentication", true);
    print("Home setAuthentication done");
  }

  @override
  void initState() {
    setState(() {
      idUser = widget.args[0];
      user = widget.args[1];
      // saleFlag = widget.args[2];
      // print('Home initState $saleFlag');
    });
    setAuthentication();
    getAppBarTitle();
    fetchApi();
    super.initState();
  }
  void setLanguage(int status) async{
    
    if(status == 1){
      Locale locale = Locale("en");
      localization = await DemoLocalizationsDelegate().load(locale);
    }
    if(status == 0 || status == null){
      Locale locale = Locale("ar");
      localization = await DemoLocalizationsDelegate().load(locale);
    }
    
  }

  Future<void> showLogoutDialog() async {
    
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            localization.getText("current user") + '$user',
            style: GoogleFonts.quicksand(),
            textDirection: lang_status == 0 ? TextDirection.rtl : TextDirection.ltr,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(localization.getText("go out"),
                  style: GoogleFonts.quicksand(),
                  textDirection: lang_status == 0 ? TextDirection.rtl : TextDirection.ltr,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(localization.getText("no"),
                style: GoogleFonts.quicksand(),
                textDirection: lang_status == 0 ? TextDirection.rtl : TextDirection.ltr,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(localization.getText("yeah"),
                style: GoogleFonts.quicksand(),
                textDirection: lang_status == 0 ? TextDirection.rtl : TextDirection.ltr,
              ),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setBool("isAuthentication", false);
                // await prefs.setBool("saleFlag", true);
                Navigator.pushReplacementNamed(context, Login.routeName);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showConfirmDialog(String id, String desc, int index) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'تؤكد',
              // 'Emphasizes',
              style: GoogleFonts.quicksand(),
              textDirection: TextDirection.rtl,
            ),
            content: SingleChildScrollView(
                child: ListBody(
              children: <Widget>[
                Text(
                  'هل تريد ان $desc ?',
                  // 'Do you want $desc?',
                  style: GoogleFonts.quicksand(),
                  textDirection: TextDirection.rtl,
                )
              ],
            )),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'لا',
                  // 'No',
                  style: GoogleFonts.quicksand(),
                  textDirection: TextDirection.rtl,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                  child: Text(
                    'نعم',
                    // 'Yeah',
                    style: GoogleFonts.quicksand(),
                    textDirection: TextDirection.rtl,
                  ),
                  onPressed: () {
                    if (desc == 'complete' || desc == 'cancel') {
                      List<OrdersModel> _temp = [];
                      setState(() {
                        if (desc == 'complete') {
                          filteredListOrders[index].Order_Status = 'منجز';
                        } else if (desc == 'cancel') {
                          filteredListOrders[index].Order_Status = 'ألغيت';
                        }
                        listCompletedOrders.add(filteredListOrders[index]);
                      });
                      for (int i = 0; i < filteredListOrders.length; i++) {
                        if (i != index) {
                          _temp.add(filteredListOrders[i]);
                        }
                      }
                      setState(() {
                        filteredListOrders = _temp;
                      });
                    }
                    onSomeMethod(id, desc);
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      title: _appBarTitle, //_appBarTitle,
      actions: lang_status == 1 ? <Widget>[
        new IconButton(
              icon: _searchIcon,
              onPressed: _searchPressed,
        )
        // currentIndex == 0 || currentIndex == 3
        //   ? new IconButton(
        //       icon: _searchIcon,
        //       onPressed: _searchPressed,
        //     )
        //   : null,
      ] : null,
      leading: lang_status == 0 ? new IconButton(
              icon: _searchIcon,
              onPressed: _searchPressed,
        ) : null
      
    );
  }

  void checkList(bool orderFlag) {
    if (_searchText.isNotEmpty) {
      if (orderFlag) {
        List<OrdersModel> tempList = [];
        print("triger111(home)");
        for (int i = 0; i < listOrders.length; i++) {
          if (listOrders[i]
                  .Order_Number
                  .toLowerCase()
                  .contains(_searchText.toLowerCase()) &&
              listOrders[i].Order_Status != "Done") {
            tempList.add(listOrders[i]);
          }
        }
        filteredListOrders = tempList;
      } else {
        List<OrdersModel> tempList = [];
        print("triger111(home)");
        for (int i = 0; i < listCompletedOrders.length; i++) {
          if (listCompletedOrders[i]
                  .Order_Number
                  .toLowerCase()
                  .contains(_searchText.toLowerCase()) &&
              listCompletedOrders[i].Order_Status != "Done") {
            tempList.add(listCompletedOrders[i]);
          }
        }
        filteredListOrders = tempList;
      }
    }
  }

  Widget _buildList() {
    checkList(this.orderFlag);
    for (int i = 0; i < filteredListOrders.length; i++) {
      print("xxxxx");
      print(filteredListOrders[i].Order_Status);
    }
    print("triger222(home)");
    return ListView.builder(
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.only(bottom: 10),
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 10),
                  child: saleFlag == true
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Ink(
                              decoration: const ShapeDecoration(
                                color: Colors.lightBlue,
                                shape: CircleBorder(),
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.phone,
                                  size: 25,
                                ),
                                color: Colors.white,
                                tooltip:
                                    '${filteredListOrders[index].Phone.toString()}',
                                onPressed: () {
                                  _launchURL(
                                      context,
                                      filteredListOrders[index]
                                          .Phone
                                          .toString());
                                },
                              ),
                            )
                          ],
                        )
                      : Container(),
                ),
                Text(
                  localization.getText("client name") + "${filteredListOrders[index].Customer_Name.toString().toUpperCase()}",
                  style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
                  textDirection: lang_status == 0 ? TextDirection.rtl : TextDirection.ltr,
                ),
                Text(
                  localization.getText("status") + "${filteredListOrders[index].Order_Status.toString()}",
                  style: GoogleFonts.quicksand(color: Colors.grey),
                  textDirection: lang_status == 0 ? TextDirection.rtl : TextDirection.ltr,
                ),
                Text(
                  localization.getText("id") + "${filteredListOrders[index].Order_Number.toString()}",
                  style: GoogleFonts.quicksand(color: Colors.grey),
                  textDirection: lang_status == 0 ? TextDirection.rtl : TextDirection.ltr,
                ),
                Text(
                  localization.getText("nb") + "${filteredListOrders[index].Note.toString()}",
                  style: GoogleFonts.quicksand(color: Colors.grey),
                  textDirection: lang_status == 0 ? TextDirection.rtl : TextDirection.ltr,
                ),
                Text(
                  localization.getText("final price")+ "${filteredListOrders[index].Final_Price.toString()}",
                  style: GoogleFonts.quicksand(color: Colors.grey),
                  textDirection: lang_status == 0 ? TextDirection.rtl : TextDirection.ltr,
                ),
                Container(
                    margin: EdgeInsets.all(5.0),
                    child: saleFlag == true
                        ? Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: this.orderFlag == true
                                    ? <Widget>[
                                        FlatButton(
                                          padding: EdgeInsets.all(8.0),
                                          color: Colors.blue,
                                          onPressed: () {
                                            showConfirmDialog(
                                                filteredListOrders[index]
                                                    .Order_ID,
                                                'process',
                                                index);
                                            // onProcessed(
                                            //     listOrders[index].Order_ID);
                                          },
                                          child: Text(localization.getText("delayed"),
                                            style: GoogleFonts.quicksand(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                            textDirection: lang_status == 0 ? TextDirection.rtl : TextDirection.ltr,
                                          ),
                                        ),
                                        FlatButton(
                                          padding: EdgeInsets.all(8.0),
                                          color: Colors.green,
                                          onPressed: () {
                                            showConfirmDialog(
                                                filteredListOrders[index]
                                                    .Order_ID,
                                                'complete',
                                                index);
                                            // onCanceled(
                                            //     listOrders[index].Order_ID);
                                          },
                                          child: Text(localization.getText("complete"),
                                            style: GoogleFonts.quicksand(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                            textDirection: lang_status == 0 ? TextDirection.rtl : TextDirection.ltr,
                                          ),
                                        ),
                                        FlatButton(
                                          padding: EdgeInsets.all(8.0),
                                          color: Colors.red,
                                          onPressed: () {
                                            showConfirmDialog(
                                                filteredListOrders[index]
                                                    .Order_ID,
                                                'cancel',
                                                index);
                                            // onCanceled(
                                            //     listOrders[index].Order_ID);
                                          },
                                          child: Text(localization.getText("canceled"),
                                            style: GoogleFonts.quicksand(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                            textDirection: lang_status == 0 ? TextDirection.rtl : TextDirection.ltr,
                                          ),
                                        ),
                                      ]
                                    : <Widget>[],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: Expanded(
                                        flex: 7,
                                        child: TextField(
                                          // controller: _initNote,
                                          onChanged: (text) {
                                            tempNote = text;
                                          },
                                          decoration: InputDecoration(
                                            // icon: Icon(Icons.note_add, color: Colors.green,),
                                            // border: OutlineInputBorder(),
                                            hintText: localization.getText("general note"),
                                          ),
                                        ),
                                      )),
                                  Expanded(
                                    flex: 2,
                                    child: FlatButton(
                                        padding: EdgeInsets.all(8.0),
                                        color: Colors.pink,
                                        onPressed: () {
                                          if (tempNote.isNotEmpty) {
                                            String orderId =
                                                filteredListOrders[index]
                                                    .Order_ID
                                                    .toString();
                                            savNote(context, tempNote, orderId);
                                            print(tempNote);
                                            setState(() {
                                              tempNote = '';
                                              // _initNote.clear();
                                            });
                                          }
                                        },
                                        child: Icon(
                                          Icons.save,
                                          size: 25,
                                          color: Colors.white,
                                        )),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: FlatButton(
                                        padding: EdgeInsets.all(8.0),
                                        color: Colors.pink[500],
                                        onPressed: () {
                                          Navigator.of(context).push(
                                              createRoute(
                                                  filteredListOrders[index]));
                                        },
                                        child: Text(localization.getText("show details"),
                                          style: GoogleFonts.quicksand(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                          textDirection: lang_status == 0 ? TextDirection.rtl : TextDirection.ltr,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          )
                        : Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: FlatButton(
                                  padding: EdgeInsets.all(8.0),
                                  color: Colors.pink[500],
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        createRoute(filteredListOrders[index]));
                                  },
                                  child: Text(localization.getText("order details"),
                                    style: GoogleFonts.quicksand(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                    textDirection: lang_status == 0 ? TextDirection.rtl : TextDirection.ltr,
                                  ),
                                ),
                              )
                            ],
                          ))
              ],
            ),
          ),
        );
      },
      itemCount: filteredListOrders.length,
    );
  }
  Widget buildDrawer(BuildContext context){
    return new Drawer(
      child: new ListView(
          children: <Widget>[
            new DrawerHeader(
              // accountName: Text('User Name'),
              // accountEmail: Text('Email@provider.com'),
              // currentAccountPicture: GestureDetector(
              //   child: new CircleAvatar(
              //     backgroundColor: Colors.white,
              //     child: Icon(
              //       Icons.person,
              //       color: Colors.black,
              //     ),
              //   ),
                
              // ),
              child: Column(
                crossAxisAlignment: lang_status == 0 ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(top: 20)),
                    Container(
                      width: 50, height: 50,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Text(
                      'User Name',
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Text(
                      'Email@provider.com',
                    ),
                  ],
              ),
              decoration: new BoxDecoration(color: Colors.blue,),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => AboutPage(args:[0])));
              },
              child: ListTile(
                title: Text(localization == null ? 'About us' : localization.getText("About us"),
                  textDirection: lang_status == 0 ? TextDirection.rtl : TextDirection.ltr
                ),
                leading: lang_status == 1 ? Icon(
                  Icons.home,
                ): null,
                trailing: lang_status == 0 ? Icon(
                  Icons.home,
                ): null
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => AboutPage(args:[2])));
              },
              child: ListTile(
                title: Text(localization == null ? 'call us' : localization.getText("call us"),
                  textDirection: lang_status == 0 ? TextDirection.rtl : TextDirection.ltr
                ),
                leading: lang_status == 1 ? Icon(
                  Icons.call,
                ): null,
                trailing: lang_status == 0 ? Icon(
                  Icons.call,
                ): null
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => AboutPage(args:[1])));
              },
              child: ListTile(
                title: Text(localization == null ? 'Live chat' : localization.getText("Live chat"),
                  textDirection: lang_status == 0 ? TextDirection.rtl : TextDirection.ltr
                ),
                leading: lang_status == 1 ? Icon(
                  Icons.account_circle,
                ): null,
                trailing: lang_status == 0 ? Icon(
                  Icons.account_circle,
                ) : null
              ),
            ),
            InkWell(
              onTap: () {
                _selectLanguage();
              },
              child: ListTile(
                title: Text(localization == null ? 'setting' : localization.getText("setting"),
                  textDirection: lang_status == 0 ? TextDirection.rtl : TextDirection.ltr
                ),
                leading: lang_status == 1 ? Icon(
                  Icons.settings,
                ): null,
                trailing: lang_status == 0 ? Icon(
                  Icons.settings,
                ) : null
              ),
            ),
            InkWell(
              onTap: () {showLogoutDialog();},
              child: ListTile(
                title: Text(localization == null ? 'Logout' : localization.getText("Logout"),
                  textDirection: lang_status == 0 ? TextDirection.rtl : TextDirection.ltr
                ),
                leading: lang_status == 1 ? Icon(
                  Icons.account_circle,
                ): null,
                trailing: lang_status == 0 ? Icon(
                  Icons.account_circle,
                ) : null
              ),
            ),
            
          ],
        ),
    );
  }
  Future<String> _selectLanguage() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState2) {
              return AlertDialog(
                title: Text('Setting Language'),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context, null);
                    },
                    child: Text('CANCEL'),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context, ringTone[_radioValue]);
                      changeLanguage();
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
                content: Container(
                  width: double.minPositive,
                  height: 300,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: ringTone.length,
                    itemBuilder: (BuildContext context, int index) {
                      return RadioListTile(
                        value: index,
                        groupValue: _radioValue,
                        title: Text(ringTone[index]),
                        onChanged: (val) {
                          setState2(() {
                            _radioValue = val;
                          });
                        },
                      );
                    },
                  ),
                ),
              );
            },
          );
        });
  }
  changeLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("lang_status", _radioValue);
    if(_radioValue == 1){
      Locale locale = Locale("en");
      localization = await delegate.load(locale);
      print("localization is: " + localization.getText("lang"));
    }
    if(_radioValue == 0){
      Locale locale = Locale("ar");
      localization = await delegate.load(locale);
      print("localization is: " + localization.getText("lang"));
    }
    _appBarTitle = new Text(localization.getText("Order Count"),
            textDirection: TextDirection.rtl,
          );
    setState(() {
      lang_status = _radioValue;
       
    });
  }
  
  @override
  Widget build(BuildContext context) {
    print("triger333(home)");
    
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: _buildBar(context),
      drawer: lang_status == 1 ? buildDrawer(context) : null,
      endDrawer: lang_status == 0 ? buildDrawer(context) : null,
      body: RefreshIndicator(
        onRefresh: () async {
          fetchApi();
        },
        child: filteredListOrders.length != 0
            ? Container(padding: EdgeInsets.all(10), child: _buildList())
            : completedLists.length != 0
                ? DashboardPage(args: [
                    dur,
                    fromDate,
                    endDate,
                    totalPrice,
                    totalDriverPrice,
                    companyMoney,
                    listCompletedOrders,
                    completedLists,
                    customerPrice,
                    percentage,
                    saleFlag
                  ])
                : cancelledLists.length != 0
                    ? CancelDashboardPage(args: [
                        dur,
                        fromDate1,
                        endDate1,
                        listCompletedOrders,
                        cancelledLists
                      ])
                    : Center(
                        child: Text(localization == null ? 'Empty' : localization.getText("empty"),
                          style: GoogleFonts.quicksand(
                              color: Colors.grey,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                          textDirection: lang_status == 0 ? TextDirection.rtl : TextDirection.ltr,
                        ),
                      ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex, // this will be set when a new tab is tapped
        onTap: onTabTapped,

        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.new_releases),
            title: new Text(localization == null ? 'New requests' : localization.getText('new_requests'),
                  textDirection: lang_status == 0 ? TextDirection.rtl : TextDirection.ltr,
                  ),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.cancel),
            title: new Text(localization == null ? 'Cancelled' : localization.getText('Cancelled'),
                  textDirection: lang_status == 0 ? TextDirection.rtl : TextDirection.ltr,
                  ),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.dashboard),
            title: new Text(localization == null ? 'complate' : localization.getText('complate'),
                  textDirection: lang_status == 0 ? TextDirection.rtl : TextDirection.ltr,
                  ),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.restore_from_trash),
            title: new Text(localization == null ? 'Old Request' : localization.getText('Old Request'),
                  textDirection: lang_status == 0 ? TextDirection.rtl : TextDirection.ltr,
                  )
            
            )
        ],
      ),
    );
  }
}
