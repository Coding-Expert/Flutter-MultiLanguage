import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testapp/src/page/Home.dart';
import 'package:testapp/src/model/DemoLocalization.dart';


class AboutPage extends StatefulWidget{
  final args;
  AboutPage({this.args});
  @override
  AboutPageState createState() => AboutPageState();
}

class AboutPageState extends State<AboutPage>{

  int lang_status = -1;
  int menu_page = -1;
  String url = "";
  DemoLocalizations localization;

  @override
  void initState(){
    super.initState();
    setState(() {
      menu_page = widget.args[0];
      if(menu_page == 0){
        url = 'https://transporter.group/elements/pages/about/';
      }
      if(menu_page == 1){
        
        url = 'https://tawk.to/chat/5cae2080d6e05b735b41e871/default';
      }
      if(menu_page == 2){
        url = 'https://transporter.group/elements/pages/contact/';
      }
    });
    
    getLangStatus();
    
  }

  @override
  Widget build(BuildContext context){
    var padding = MediaQuery.of(context).padding;
    return Scaffold(
      appBar: buildAppBar(context),
      body: 
        new ConstrainedBox(
          constraints: new BoxConstraints(),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - padding.bottom,
            child: WebView(
              initialUrl: url,
              javascriptMode: JavascriptMode.unrestricted,
            ),
          )
          
        ),
        
    );
  }

  Widget buildAppBar(BuildContext context){
    print("current language: " + lang_status.toString());
    return AppBar(
      backgroundColor: Colors.blue,
      title: Text(
        ((){
          // if(lang_status == 0 || lang_status == null){
            if(menu_page == 0){
              return localization.getText("About us");
            }
            if(menu_page == 1){
              return localization.getText("Live chat");
            }
            if(menu_page == 2){
              return localization.getText("call us");
            }
          
        }()), style: TextStyle(color: Colors.white),
        textDirection: lang_status == 0 ? TextDirection.rtl : TextDirection.ltr,
      ),
      centerTitle: true,
      leading: new IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  
                }
              ),
    );
  }

  void getLangStatus() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int value = prefs.getInt("lang_status");
    setState(() {
      lang_status = value;
    });
    if(lang_status == 1){
      Locale locale = Locale("en");
      localization = await DemoLocalizationsDelegate().load(locale);
    }
    if(lang_status == 0 || lang_status == null){
      Locale locale = Locale("ar");
      localization = await DemoLocalizationsDelegate().load(locale);
    }
  }
}