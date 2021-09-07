import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nb_utils/nb_utils.dart';
import 'dart:convert';
import 'package:prokit_flutter/JobTune/constructor/server.dart';
import 'package:http/http.dart' as http;
import 'package:prokit_flutter/JobTune/gig-guest/views/index/views/JTServiceListCategory.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/index/JTDashboardWidgetUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/searching-result/JTSearchingResultUser.dart';
import 'package:prokit_flutter/defaultTheme/model/CategoryModel.dart';
import 'package:prokit_flutter/main.dart';
import 'package:prokit_flutter/main/utils/AppColors.dart';

class JTDashboardWidgetNomad extends StatefulWidget {
  static String tag = '/JTDashboardWidgetNomad';

  @override
  _JTDashboardWidgetNomadState createState() => _JTDashboardWidgetNomadState();
}

class _JTDashboardWidgetNomadState extends State<JTDashboardWidgetNomad> {
  PageController pageController = PageController();
  List<Widget> pages = [];
  List<CategoryModel> categories = [];

  int selectedIndex = 0;
  var formKey = GlobalKey<FormState>();
  var searchCont = TextEditingController();

  // functions starts //

  List profile = [];
  Future<void> checkProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    if(lgid != "null") {
      http.Response response = await http.get(
          Uri.parse(
              server + "jtnew_user_selectprofile&lgid=" + lgid),
          headers: {"Accept": "application/json"}
      );

      this.setState(() {
        profile = json.decode(response.body);
      });

      print(profile[0]["city"]+profile[0]["state"]+profile[0]["country"]);
      checkCategory(profile[0]["city"],profile[0]["state"],profile[0]["country"]);
    }
    else {
      readCategory();
    }
  }

  Future<void> checkCategory(city,state,country) async {
    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_user_selectavailablecategory&city="+city
                +"&state="+state
                +"&country="+country
        ),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      category = json.decode(response.body);
    });

    for(var m=0;m<category.length;m++) {
      categories.add(CategoryModel(name: category[m]["category"], icon: 'images/defaultTheme/category/Man.png'));
    }
  }

  List category = [];
  Future<void> readCategory() async {
    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_provider_selectcategory"),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      category = json.decode(response.body);
    });

    for(var m=0;m<category.length;m++) {
      categories.add(CategoryModel(name: category[m]["category"], icon: 'images/defaultTheme/category/Man.png'));
    }
  }

  List clocking = [];
  Future<void> readClocking() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_provider_selectstandby&id=" + lgid),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      clocking = json.decode(response.body);
    });
  }

  // functions ends //


  @override
  void initState() {
    super.initState();
    this.checkProfile();
    this.readClocking();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: (clocking.length > 0) ? 500.0 : 240.0,
                floating: true,
                pinned: true,
                snap: false,
                automaticallyImplyLeading : false,
                backgroundColor: appStore.appBarColor,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Stack(
                            children: [
                              Container(
                                height: 150,
                                decoration: BoxDecoration(
                                  color: appColorPrimary,
                                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                                ),
                              ).visible(false),
                              Column(
                                children: [
                                  10.height,
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Form(
                                      key: formKey,
                                      child: TextFormField(
                                        controller: searchCont,
                                        style: primaryTextStyle(),
                                        decoration: InputDecoration(
                                          labelText: 'Search',
                                          suffixIcon: IconButton(
                                            onPressed: (){
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => JTSearchingResultUser(
                                                  searchkey: searchCont.text,
                                                )),
                                              );
                                            },
                                            icon: Icon(Icons.search),
                                          ),
                                          contentPadding: EdgeInsets.all(16),
                                          labelStyle: secondaryTextStyle(),
                                          border: OutlineInputBorder(),
                                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: Color(0xFF0A79DF))),
                                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appStore.textSecondaryColor!)),
                                        ),
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.next,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          10.height,
                          Text(' Services Categories', style: boldTextStyle()).paddingAll(8),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.only(right: 8, top: 8),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: categories.map((e) {
                                return Container(
                                  width: isMobile ? 100 : 120,
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(shape: BoxShape.circle, color: appColorPrimary),
                                        child: Image.asset(e.icon!, height: 30, width: 30, color: white),
                                      ),
                                      4.height,
                                      Text(
                                          e.name!,
                                          style: primaryTextStyle(size: 12),
                                          maxLines: 1,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis
                                      ),
                                    ],
                                  ),
                                ).onTap(() {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => JTServiceListCategory(
                                      searchkey: e.name!,
                                    )),
                                  );
                                });
                              }).toList(),
                            ),
                          ),
                          25.height,
                          Text('    Featured', style: boldTextStyle()).paddingBottom(8),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: Container(
              height: 500,
          ),
        )
    );
  }
}