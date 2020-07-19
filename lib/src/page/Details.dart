import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testapp/src/model/DemoLocalization.dart';

class Details extends StatefulWidget {
  final args;
  Details({Key key, this.args}) : super(key: key);
  @override
  _DetailPageState createState() => _DetailPageState(args: this.args);
}
class _DetailPageState extends State<Details> {
  var args;
  _DetailPageState({this.args});
  int lang_status = 0;
  DemoLocalizationsDelegate delegate = new DemoLocalizationsDelegate();
  DemoLocalizations localization;


  @override
  void initState(){
    super.initState();
    setState(() {
      getLangStatus();
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


  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        centerTitle: true,
        title: new Text(localization.getText("order details"),
          textDirection: lang_status == 0 ? TextDirection.rtl : TextDirection.ltr,
        ),
      ),
      body: Card(
        color: Colors.grey[100],
        margin: EdgeInsets.all(10),
        child: Container(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    localization.getText("request name") + "${args[0].Order_Name.toString()}",
                    style: Theme.of(context).textTheme.headline,
                    textDirection: lang_status == 0 ? TextDirection.rtl : TextDirection.ltr,
                  ),
                  Text(
                    localization.getText("id") + "${args[0].Order_Number.toString()}",
                    style: Theme.of(context).textTheme.headline,
                    textDirection: lang_status == 0 ? TextDirection.rtl : TextDirection.ltr,
                  ),
                  Text(
                    localization.getText("customer area") + "${args[0].Order_Location.toString()}",
                    style: Theme.of(context).textTheme.headline,
                    textDirection: lang_status == 0 ? TextDirection.rtl : TextDirection.ltr,
                  ),
                  Text(
                    localization.getText("Status order") + "${args[0].Order_Status.toString()}",
                    style: Theme.of(context).textTheme.headline,
                    textDirection: lang_status == 0 ? TextDirection.rtl : TextDirection.ltr,
                  ),
                  Text(
                    localization.getText("final price") + "${args[0].Final_Price.toString()}",
                    style: Theme.of(context).textTheme.headline,
                    textDirection: lang_status == 0 ? TextDirection.rtl : TextDirection.ltr,
                  ),
                  Text(
                    localization.getText("customer price") + "${args[0].Customer_Price.toString()}",
                    style: Theme.of(context).textTheme.headline,
                    textDirection: lang_status == 0 ? TextDirection.rtl : TextDirection.ltr,
                  ),
                  Text(
                    localization.getText("driver price") + "${args[0].Driver_Price.toString()}",
                    style: Theme.of(context).textTheme.headline,
                    textDirection: lang_status == 0 ? TextDirection.rtl : TextDirection.ltr,
                  ),
                  Text(
                    localization.getText("nb") + "${args[0].Note.toString()}",
                    style: Theme.of(context).textTheme.headline,
                    textDirection: lang_status == 0 ? TextDirection.rtl : TextDirection.ltr,
                  ),
                  Text(
                    localization.getText("client name") + "${args[0].Customer_Name.toString()}",
                    style: Theme.of(context).textTheme.headline,
                    textDirection: lang_status == 0 ? TextDirection.rtl : TextDirection.ltr,
                  ),
                  Text(
                    localization.getText("customer phone") + "${args[0].Phone.toString()}",
                    style: Theme.of(context).textTheme.headline,
                    textDirection: lang_status == 0 ? TextDirection.rtl : TextDirection.ltr,
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
