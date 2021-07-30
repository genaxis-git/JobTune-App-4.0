import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prokit_flutter/defaultTheme/model/DTAddressListModel.dart';
import 'package:prokit_flutter/defaultTheme/model/DTProductModel.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTAddressScreen.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTPaymentScreen.dart';
import 'package:prokit_flutter/defaultTheme/utils/DTDataProvider.dart';
import 'package:prokit_flutter/defaultTheme/utils/DTWidgets.dart';
import 'package:prokit_flutter/main/utils/AppColors.dart';
import 'package:prokit_flutter/main/utils/AppWidget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../main.dart';
import 'CartListView.dart';
// import '../JTDrawerWidget.dart';

// ignore: must_be_immutable
class DTOrderSummaryScreen extends StatefulWidget {
  static String tag = '/DTOrderSummaryScreen';
  // List<DTProductModel> data;

  // DTOrderSummaryScreen(this.data);

  final String productid;
  final String providerid;
  final String name;
  final String category;
  final String price;
  final String additionalfee;
  final String totalprice;
  final String description;
  final String expected;
  final String availableday;
  final String location;
  final String productphoto;
  final String postdate;

  const DTOrderSummaryScreen({
    Key? key,
    required this.productid,
    required this.providerid,
    required this.name,
    required this.category,
    required this.price,
    required this.additionalfee,
    required this.totalprice,
    required this.description,
    required this.expected,
    required this.availableday,
    required this.location,
    required this.productphoto,
    required this.postdate,
  });

  @override
  DTOrderSummaryScreenState createState() => DTOrderSummaryScreenState();
}

class DTOrderSummaryScreenState extends State<DTOrderSummaryScreen> {
  var expectedDelivery = '';

  //List<DTProductModel> data = getCartProducts();

  int subTotal = 0;
  int totalAmount = 0;
  int shippingCharges = 0;
  int mainCount = 0;

  String? name = 'Austin';
  String? address = '381, Shirley St. Munster, New York';
  String? address2 = 'United States - 10005';

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    DateTime dateTime = DateTime.now();
    expectedDelivery =
        '${dateTime.day} ${getMonth(dateTime.month)}, ${dateTime.year}';

    // calculate();
  }

  // calculate() async {
  //   subTotal = 0;
  //   shippingCharges = 0;
  //   totalAmount = 0;

  //   widget.data.forEach((element) {
  //     subTotal += (element.discountPrice ?? element.price)! * element.qty!;
  //   });

  //   shippingCharges = (subTotal * 10).toInt() ~/ 100;
  //   totalAmount = subTotal + shippingCharges;

  //   setState(() {});
  // }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    Widget addressView() {
      return Container(
        padding: EdgeInsets.all(8),
        decoration: boxDecorationRoundedWithShadow(8,
            backgroundColor: appStore.appBarColor!),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(name!, style: boldTextStyle(size: 18)),
                    10.width,
                    Container(
                      child: Text('Home', style: secondaryTextStyle()),
                      padding: EdgeInsets.only(left: 8, right: 8),
                      decoration: BoxDecoration(
                          color:
                              Theme.of(context).dividerColor.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ],
                ),
                // Icon(Icons.phone, color: appColorPrimary).onTap(() {
                //   launch('tel:+913972847376');
                // }),
              ],
            ),
            Text(address!, style: primaryTextStyle()),
            Text(address2!, style: primaryTextStyle()),
            6.height,
            Text('Change', style: secondaryTextStyle()).onTap(() async {
              DTAddressListModel? data =
                  await DTAddressScreen().launch(context);

              if (data != null) {
                name = data.name;
                address = data.addressLine1;
                address2 = data.addressLine2;

                setState(() {});
              }
            }),
          ],
        ),
      );
    }

    Widget itemTitle() {
      return Row(
        children: [
          Divider().expand(),
          10.width,
          Text('Item', style: boldTextStyle(), maxLines: 1).center(),
          10.width,
          Divider().expand(),
        ],
      );
    }

    Widget itemView() {
      return Container(
        decoration: boxDecorationRoundedWithShadow(8,
            backgroundColor: appStore.appBarColor!),
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              width: 100,
              child: Image.network(
                "https://jobtune.ai/gig/JobTune/assets/img/" +
                    widget.productphoto,
                fit: BoxFit.fitHeight,
                height: 180,
                width: context.width(),
              ),
            ),
            12.width,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.name,
                    style: primaryTextStyle(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                4.height,
                Row(
                  children: [
                    priceWidget(widget.price.toInt()),
                    // 8.width,
                    // priceWidget(widget.price.toInt(), applyStrike: true),
                  ],
                ),
                8.height,
                // Container(
                //   decoration: boxDecorationWithRoundedCorners(
                //     borderRadius: BorderRadius.circular(4),
                //     backgroundColor: appColorPrimaryDark,
                //   ),
                //   padding: EdgeInsets.all(4),
                //   child: Row(
                //     mainAxisSize: MainAxisSize.min,
                //     children: [
                //       Icon(Icons.remove, color: whiteColor).onTap(() {
                //         var qty = data.qty!;
                //         if (qty <= 1) return;
                //         var q = qty - 1;
                //         data.qty = q;

                //         calculate();
                //       }),
                //       6.width,
                //       Text(data.qty.toString(),
                //           style: boldTextStyle(color: whiteColor)),
                //       6.width,
                //       Icon(Icons.add, color: whiteColor).onTap(() {
                //         mainCount = data.qty! + 1;
                //         data.qty = mainCount;

                //         calculate();
                //       }),
                //     ],
                //   ),
                // ).visible(widget.mIsEditable.validate(value: true)),
              ],
            ).expand(),
          ],
        ),
      );
    }

    Widget deliveryDateAndPayBtn() {
      return Column(
        children: [
          Row(
            children: [
              Icon(Feather.truck, size: 26, color: appColorPrimary),
              10.width,
              Text('Expected Delivery - $expectedDelivery',
                      style: boldTextStyle(), maxLines: 1)
                  .expand(),
            ],
          ),
          20.height,
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(12),
            decoration: boxDecorationRoundedWithShadow(8,
                backgroundColor: appColorPrimary),
            child: Text('Continue to Pay', style: boldTextStyle(color: white)),
          ).onTap(() {
            DTPaymentScreen().launch(context);
          }),
        ],
      ).paddingAll(8);
    }

    Widget mobileWidget() {
      return SingleChildScrollView(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                addressView(),
                20.height,
                itemTitle(),
                8.height,
              ],
            ).paddingAll(8),
            itemView(),
            20.height,
            totalAmountWidget(widget.price.toInt(),
                widget.additionalfee.toInt(), widget.totalprice.toInt()),
            Divider(height: 20),
            deliveryDateAndPayBtn(),
          ],
        ),
      );
    }

    Widget webWidget() {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.all(8),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  16.height,
                  addressView(),
                  16.height,
                  itemTitle(),
                  16.height,
                  CartListView(mIsEditable: false, isOrderSummary: true),
                ],
              ),
            ),
          ).expand(flex: 60),
          VerticalDivider(width: 0),
          Container(
            margin: EdgeInsets.all(16),
            child: Column(
              children: [
                20.height,
                totalAmountWidget(widget.price.toInt(),
                    widget.additionalfee.toInt(), widget.totalprice.toInt()),
                Divider(height: 20),
                deliveryDateAndPayBtn(),
              ],
            ),
          ).expand(flex: 40),
        ],
      );
    }

    return Scaffold(
      appBar: appBar(context, 'Order Summary'),
      // drawer: JTDrawerWidget(),
      body: ContainerX(
        mobile: mobileWidget(),
        web: webWidget(),
      ),
    );
  }
}
