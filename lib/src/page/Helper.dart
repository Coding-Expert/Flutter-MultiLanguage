import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testapp/src/model/OrdersModel.dart';
import 'package:testapp/src/page/Details.dart';
import 'package:http/http.dart' as http;

Route createRoute(OrdersModel filteredListOrders) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        Details(args: [filteredListOrders]),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}



void onSomeMethod(String id, String desc) async {
  switch (desc) {
    case 'complete':
      {
        var hello = await http.get(
            "https://transporter.group/wp-json/wc/v1/orderstatus/$id/Completed");
        print(
            "https://transporter.group/wp-json/wc/v1/orderstatus/$id/complete");
      }
      break;
    case 'cancel':
      {
        var hello = await http.get(
            "https://transporter.group/wp-json/wc/v1/orderstatus/$id/Cancelled");
        print("https://transporter.group/wp-json/wc/v1/orderstatus/$id/cancel");
      }
      break;

    case 'process':
      {
        var hello = await http.get(
            "https://transporter.group/wp-json/wc/v1/orderstatus/$id/Processing");
        print(
            "https://transporter.group/wp-json/wc/v1/orderstatus/$id/process");
      }
      break;
  }
}

void savNote(BuildContext context, String note, String id) async {
  String url = 'https://transporter.group/wp-json/wc/v1/note';
  var response = await http.post(url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'orderId': id, 'save_note': note}));
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int lang_status = prefs.getInt("lang_status");
  if (response.body == "1") {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(
        ((){
          if(lang_status == 0){
            return "The note is saved.";
          }
          else{
            return "يتم حفظ الملاحظة.";
          }
        }()),
        textDirection: TextDirection.rtl,
      ),
    ));
  }
}


