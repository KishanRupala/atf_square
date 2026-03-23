import 'dart:convert';

import 'package:atf_square/model/menu/PlaceOrderResponseModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';

import '../../constant/api_end_point.dart';
import '../../constant/colors.dart';
import '../../model/menu/MenuScreenResponseModel.dart';
import '../../model/common_model.dart';
import '../../network/base_class.dart';
import '../../utils/app_utils.dart';
import '../../widgets/common_widget.dart';
import '../../widgets/dotted_border_container.dart';
import '../../widgets/no_internet.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  BaseState<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends BaseState<MenuScreen> with TickerProviderStateMixin {

  int? parentExpandedIndex;
  int? childExpandedIndex;

  List<AllDayMenu> listAllDayMenu = [];
  List<MorningMenu> listMorningMenu = [];

  List<CartItemModel> listCart = [];

  bool _isLoading = false;

  TextEditingController numberController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  Map<int, GlobalKey> morningMenuCategoryKeys = {};
  Map<int, GlobalKey> allDayMenuCategoryKeys = {};
  Map<String,String> selectedVariation = {};
  Map<String,String> selectedPreference = {};
  Map<String, Set<String>> selectedMultipleAddOns = {};
  Map<String, num> mapPrice = {};
  // Map<String, bool> onClickPlusButton = {};
  // Map<String, bool> onClickMinusButton = {};

  bool showMenu = false;
  late AnimationController _controller;

  @override
  void initState() {
    _fetchMenuData();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 280),
    );

    super.initState();
  }

  void morningMenuScrollTo(int index) {
    setState(() {
      parentExpandedIndex = 0;
      childExpandedIndex = index;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final key = morningMenuCategoryKeys[index];
      if (key?.currentContext != null) {
        Scrollable.ensureVisible(
          key!.currentContext!,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          alignment: 0.1,
        );
      }
    });
  }

  void allDayMenuScrollTo(int index) {
    setState(() {
      parentExpandedIndex = 1;
      childExpandedIndex = index;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final key = allDayMenuCategoryKeys[index];
      if (key?.currentContext != null) {
        Scrollable.ensureVisible(
          key!.currentContext!,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          alignment: 0.1,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: !isOnline ? MyNoInternetWidget(() {}) : SafeArea(
            child:_isLoading ? Center(child: CircularProgressIndicator(color: brandColor)) : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0,right: 12,top: 96),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(child: Image.asset("assets/images/logo.png",width: 144,height: 165,)),
                    const Gap(16),
                    menuSectionWidget(
                      keyMap: morningMenuCategoryKeys,
                      categoryImg: "breakfast_menu.jpg",
                      list: listMorningMenu,
                      title: "Morning Menu",
                      isExpanded: parentExpandedIndex == 0,
                      onTap: () {
                        setState(() {
                          parentExpandedIndex =
                          parentExpandedIndex == 0 ? null : 0;
                          childExpandedIndex = null;
                        });
                      },
                      childExpandedIndex: childExpandedIndex,
                      onChildTap: (index) {
                        setState(() {
                          childExpandedIndex =
                          childExpandedIndex == index ? null : index;
                        });
                      },
                    ),

                    /// SECOND
                    menuSectionWidget(
                      keyMap: allDayMenuCategoryKeys,
                      categoryImg: "all_day_menu_image.jpg",
                      list: listAllDayMenu,
                      title: "All Day Menu",
                      isExpanded: parentExpandedIndex == 1,
                      onTap: () {
                        setState(() {
                          parentExpandedIndex =
                          parentExpandedIndex == 1 ? null : 1;
                          childExpandedIndex = null;
                        });
                      },
                      childExpandedIndex: childExpandedIndex,
                      onChildTap: (index) {
                        setState(() {
                          childExpandedIndex =
                          childExpandedIndex == index ? null : index;
                        });
                      },
                    ),
                    const Gap(16)
                  ],
                ),
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: Visibility(
            visible : !showMenu && _isLoading == false && isOnline == true,
            child: _buildMenuCartFAB(showMenuList: false)
          ),
        ),
        if(showMenu)
        Positioned.fill(
          child: Container(
            color: black.withValues(alpha: 0.5),
          ),
        ),

        if(showMenu)
          Scaffold(
            backgroundColor: Colors.transparent,
            body: GestureDetector(behavior: HitTestBehavior.opaque,onTap: () async {
                 await _controller.reverse(); // CLOSE
                 setState(() => showMenu = false);
              },
            ),
             floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: Visibility(
                visible : showMenu && _isLoading == false && isOnline == true,
                child: _buildMenuCartFAB(showMenuList: true)
            ),
          )
      ],
    );
  }

  Widget _buildMenuCartFAB({required bool showMenuList,}) {
    bool isCartVisible = getTotalQty() > 0;
    return Padding(
      padding: const EdgeInsets.only(right: 12.0,bottom: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [

          if (showMenuList)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: _animatedMenu(context),
            ),
          AnimatedPadding(
            duration: const Duration(milliseconds: 300),
            padding: EdgeInsets.only(bottom: isCartVisible ? 12 : 6),
            child: SizedBox(
              height: 60,
              width: 60,
              child: FloatingActionButton(
                heroTag: "menuButton",
                backgroundColor: Colors.black,

                onPressed: () async {
                  if (_controller.isCompleted) {
                    await _controller.reverse(); // CLOSE
                    setState(() => showMenu = false);
                  } else {
                    setState(() => showMenu = true);
                    _controller.forward(); // OPEN
                  }
                },

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    showMenu
                        ? Image.asset(
                      "assets/images/ic_close.png",
                      height: 16,
                      width: 14,
                      color: white,
                    )
                        : Image.asset(
                      "assets/images/ic_menu.png",
                      height: 16,
                      width: 16,
                    ),
                    const Gap(4),
                    Text(
                      "Menu",
                      style: TextStyle(
                        fontSize: 12,
                        letterSpacing: 0,
                        color: white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// CART BUTTON
          if (isCartVisible)
            Container(
              margin: const EdgeInsets.only(top: 8,),
              width: 96,
              height: 52,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF231F1F), Color(0xFF111111)],
                ),
                borderRadius: BorderRadius.circular(50),
              ),
              child: FloatingActionButton(
                heroTag: "cartScreen",
                backgroundColor: Colors.transparent,
                elevation: 0,
                onPressed: openCartDialog,
                child: Text(
                  "Cart (${getTotalQty()})",
                  style: TextStyle(
                    fontSize: 16,
                    color: white,
                    letterSpacing: 0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _animatedMenu(BuildContext context) {
    final mediaQuerySize =    MediaQuery.of(context).size;

    final animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );
     return Align(
       alignment: Alignment.bottomRight,
       child: SizeTransition(
         sizeFactor: animation,
         axisAlignment: -1,
         child: Container(
           height: mediaQuerySize.height * 0.6,
           margin: EdgeInsets.only( left: mediaQuerySize.width * 0.2,),
           padding: EdgeInsets.only(left: 16,right: 16),
           decoration: getCommonCardWithoutShadow(black),
           child:SingleChildScrollView(
             physics: AlwaysScrollableScrollPhysics(),
             child: Column(
               crossAxisAlignment: .start,
               children: [
                 const Gap(16),
                 Text("Morning Menu ",style: getRegularTextStyle(color: white,fontSize: 18),),
                 const Gap(10),
                 _commonMenuList(list: listMorningMenu, onTab: (index) async {
                     await _controller.reverse();
                     setState((){
                       showMenu = false;
                     });
                     morningMenuScrollTo(index);
                 }),
                 const Gap(8),
                 Text("All Day Menu",style: getRegularTextStyle(color: white,fontSize: 18),),
                 const Gap(10),
                 _commonMenuList(list:listAllDayMenu, onTab: (index) async {
                   await _controller.reverse();
                   setState((){
                     showMenu = false;
                   });
                   allDayMenuScrollTo(index);
                 }),
                 const Gap(16),
               ],
             ),
           )
         ),
       ),
     );
       }

  Widget _commonMenuList({required List<dynamic> list,required Function(int) onTab}) {
    return ListView.builder(
       itemCount: list.length,
       physics: const NeverScrollableScrollPhysics(),
       shrinkWrap: true,
       padding: EdgeInsets.only(left: 8),
       itemBuilder: (context, index) {
       final listItem = list[index];
       return GestureDetector(
         behavior: HitTestBehavior.opaque,
         onTap: ()=>onTab(index),
         child: Container(
           padding: EdgeInsets.only(bottom: 10),
           child: Row(
             children: [
               Expanded(child: Text(listItem.categoryName ?? "-",style: getRegularTextStyle(color: gray,fontSize: 16),)),
               Text('${listItem.products?.length ?? 0}',style: getRegularTextStyle(color: gray,fontSize: 16),),
             ],
           ),
         ),
       );
     },);
  }



  Widget menuSectionWidget({
    required String title,
    required bool isExpanded,
    required Function() onTap,
    required int? childExpandedIndex,
    required Function(int) onChildTap,
    required List<dynamic> list,
    required String categoryImg,
    required Map<int,GlobalKey> keyMap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      decoration: getCommonCard(bgColor: bgDarkWhite),
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: isExpanded ? 224 : 160,
              child: ClipRRect(
                borderRadius: !isExpanded
                    ? BorderRadius.circular(kCardCornerRadius)
                    : BorderRadius.only(
                  topLeft: Radius.circular(kCardCornerRadius),
                  topRight: Radius.circular(kCardCornerRadius),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        "assets/images/$categoryImg",
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        color: black.withValues(alpha: 0.4),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 24,
                      right: 24,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(title,
                                style: getBoldTextStyle(fontSize: 24, color: white)),
                          ),
                          Visibility(
                            visible: !isExpanded,
                            child: Text("+",
                              style: getRegularTextStyle(fontSize: 36, color: white),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          if (isExpanded)
            ListView.builder(
              itemCount: list.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(8),
              controller: _scrollController,
              itemBuilder: (context, index) {

                final key = keyMap[index] ??= GlobalKey();

                bool isChildExpanded = childExpandedIndex == index;
               final item = list[index];
               List<Products> products = item.products ?? [];
                final pairs = getPairs(products);
                return Container(
                  key: key,
                  margin: EdgeInsets.only(bottom: 8),
                  decoration: getCommonCard(),
                  child: Column(
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => onChildTap(index),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 600),
                          height: 108,
                          child: ClipRRect(
                            borderRadius: !isChildExpanded ? BorderRadiusGeometry.circular(kCardCornerRadius) : BorderRadius.only(topLeft: Radius.circular(kCardCornerRadius),topRight: Radius.circular(kCardCornerRadius)),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: CachedNetworkImage(
                                    imageUrl: "${item.categoryImage ?? ""}&h=500&zc=2",
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        Image.asset("assets/images/placeholder_banner_img.png", fit: BoxFit.cover),
                                    errorWidget: (context, url, error) {
                                      return Image.asset(
                                        "assets/images/placeholder_banner_img.png",
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  )
                                ),
                                Positioned(
                                  bottom: 20,
                                  left: 24,
                                  right: 24,
                                  child: SizedBox(
                                    height: 34,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Expanded(child: Text(item.categoryName ?? "-",style: getBoldTextStyle(fontSize: 24,color: white),)),
                                        Visibility(
                                          visible: !isChildExpanded,
                                          child: Text("+",style: getRegularTextStyle(fontSize: 30,color: white)))
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      /// GRID

                      if (isChildExpanded)
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: pairs.length,
                          itemBuilder: (context, index) {
                             final pair  = pairs[index];
                            return IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [

                                  /// LEFT ITEM
                                  Expanded(child: _commonMenuBannerItemWidget(pair[0],index)),
                                  /// RIGHT ITEM
                                  if (pair.length > 1)
                                    Expanded(child: _commonMenuBannerItemWidget(pair[1],index))
                                  else
                                    Expanded(child: Container()),
                                ],
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                );
              },
            )
        ],
      ),
    );
  }


  Widget _commonMenuBannerItemWidget(Products productsItem,int index) {

    final String productId = productsItem.productId.toString();

    return Container(
        margin: EdgeInsets.only(left: 8,right: 8,bottom: 8,top: 8),
        child: StatefulBuilder(
            builder: (BuildContext context,
                StateSetter itemSetState) {
             // bool isOnClickMinusButton = onClickMinusButton[productId] ?? false;
             // bool isOnClickPlusButton = onClickPlusButton[productId] ?? false;

              num selectedPrice = mapPrice[productId] ?? productsItem.price ?? 0;

              final selectedSet = selectedMultipleAddOns[productId] ?? {};

              String selectedVariationName = selectedVariation[productId] ?? "Regular";
              String selectedPref = selectedPreference[productId] ?? "Regular";

              int? cartItemIndex = getCartItemIndex(productsItem.productId ?? "", selectedPref, selectedVariationName, selectedSet);

              return  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 160,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(kBorderRadius),
                      child: CachedNetworkImage(
                        imageUrl: "${productsItem.productImage ?? ""}&h=500&zc=2",
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            Image.asset("assets/images/product_paceholder_img.png", fit: BoxFit.cover),
                        errorWidget: (context, url, error) {
                          return Image.asset(
                              "assets/images/product_paceholder_img.png",
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                  ),
                  const Gap(8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                            productsItem.productName ?? "",
                          style: getMediumTextStyle(fontSize: 16),
                        ),
                      ),
                      Visibility(
                        visible: productsItem.swaminarayanAvailable == 1,
                        child: Container(
                          margin: EdgeInsets.only(left: 8),
                          child: Image.asset(
                            "assets/images/ic_swami_narayan.png",
                            height: 20,
                          ),
                        )
                      ),
                      Visibility(
                       visible: productsItem.jainAvailable == 1,
                       child: Container(
                         margin: EdgeInsets.only(left: 8),
                         child: Image.asset(
                             "assets/images/ic_jain.png",
                           height: 20,
                         ),
                       ) ),
                      Visibility(
                        visible: productsItem.preOrder == 1,
                        child: Container(
                          margin: EdgeInsets.only(left: 8),
                          child: Image.asset(
                              "assets/images/pre_order_img.png",
                            height: 14,
                          ),
                        )
                      )
                    ],
                  ),
                  Visibility(
                    visible: productsItem.description != "",
                    child: Container(margin: EdgeInsets.only(top: 8),child: Text(productsItem.description ?? "",style: getRegularTextStyle(color: gray,fontSize: 14),))),
                  Spacer(),

                  ///extras:
                  Visibility(
                    visible: productsItem.multipleAddons?.isNotEmpty ?? false,
                    child: Container(
                      margin: EdgeInsets.only(top: 8),
                      child: ForSideDashedBorderBox(
                        backgroundColor: Color(0xfffafafa),
                        padding: EdgeInsets.only(top: 10,right: 10,left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Extras:",style: getRegularTextStyle(color: Color(0xff8c8686),fontSize: 12)),
                            const Gap(8),
                             ...List.generate(productsItem.multipleAddons?.length ?? 0,(index) {
                                  final multiple = productsItem.multipleAddons![index];
                                  final multiAddonName = multiple.multipleAddonName ?? "";
                                  final isSelected = selectedSet.contains(multiAddonName);
                                 return GestureDetector(
                                   behavior: HitTestBehavior.opaque,
                                   onTap: () {
                                   itemSetState(() {
                                     selectedMultipleAddOns.putIfAbsent(productId, () => <String>{});
                                       if (selectedMultipleAddOns[productId]!.contains(multiAddonName)) {
                                         selectedMultipleAddOns[productId]!.remove(multiAddonName);
                                         mapPrice[productId] = selectedPrice - ( multiple.multipleAddonPrice ?? 0);
                                       } else {
                                         selectedMultipleAddOns[productId]!.add(multiAddonName);
                                         mapPrice[productId] =selectedPrice + (multiple.multipleAddonPrice ?? 0);
                                       }
                                     });
                                   },
                                   child: Container(
                                     margin: const EdgeInsets.only(bottom: 8),
                                     child: Row(
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       children: [
                                         Image.asset(
                                           isSelected
                                               ? "assets/images/ic_selected_checkbox.png"
                                               : "assets/images/ic_checkbox.png",
                                           color:isSelected ? brandColor : gray,
                                           height: 16,
                                           width: 16,
                                         ),
                                         const Gap(8),
                                         Expanded(
                                           child: RichText(
                                             text: TextSpan(
                                               children: [
                                                 TextSpan(
                                                   text: "${multiple.multipleAddonName ?? ""} ",
                                                   style: getRegularTextStyle(
                                                     fontSize: 12,
                                                     color: isSelected ? black : darkGray,
                                                   ),
                                                 ),
                                                 TextSpan(
                                                   text: "+ ₹${multiple.multipleAddonPrice ?? 0}",
                                                   style: getRegularTextStyle(
                                                     fontSize: 12,
                                                     color:darkGray,
                                                   )
                                                 ),
                                               ],
                                             ),
                                           ),
                                         )
                                       ],
                                     ),
                                   ),
                                 );
                                },
                              )
                          ],
                        ),
                      ),
                    ),
                  ),
                  ///jain

                  Visibility(
                    visible: productsItem.jainAvailable == 1 || productsItem.swaminarayanAvailable == 1,
                    child: Container(margin: EdgeInsets.only(top: 8,bottom: 4),child: Text("Preference:",style: getRegularTextStyle(color: gray,fontSize: 12)))),

                  Visibility(
                    visible: productsItem.jainAvailable == 1 || productsItem.swaminarayanAvailable == 1,
                    child: Wrap(
                      children: [
                        GestureDetector(
                          onTap: () {
                            itemSetState(() {
                              selectedPreference[productId] = "Regular";
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.only(left: 8,right: 8,top: 4,bottom: 6),
                            margin: EdgeInsets.only(right: 8,bottom: 8),

                            decoration: BoxDecoration(
                                borderRadius: BorderRadiusGeometry.circular(25),
                                border: Border.all(color:selectedPref == "Regular" ? black : gray,width: 1),
                                color:   selectedPref == "Regular" ? black : Colors.transparent
                            ),
                            child: Text(
                                "Regular",
                              style: getRegularTextStyle(fontSize: 12,color:  selectedPref == "Regular" ? white : black),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: productsItem.jainAvailable == 1,
                          child: GestureDetector(
                            onTap: () {
                              itemSetState(() {
                                selectedPreference[productId] = "Jain";
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.only(left: 8,right: 8,top: 4,bottom: 6),
                              margin: EdgeInsets.only(right: 8,bottom: 8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadiusGeometry.circular(25),
                                  border:  Border.all(color: selectedPref == "Jain" ? black : gray,width: 1),
                                  color:   selectedPref == "Jain" ? black : Colors.transparent
                              ),
                              child: Text(
                                  "Jain",
                                style: getRegularTextStyle(fontSize: 12,color:   selectedPref == "Jain" ? white : black ),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: productsItem.swaminarayanAvailable == 1,
                          child: GestureDetector(
                            onTap: () {
                              print("cklick");
                              itemSetState(() {
                                selectedPreference[productId] = "Swaminarayan";
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.only(left: 8,right: 8,top: 4,bottom: 6),
                              margin: EdgeInsets.only(right: 8,bottom: 8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadiusGeometry.circular(25),
                                  border: Border.all(color:selectedPref == "Swaminarayan"? black : gray,width: 1),
                                  color:   selectedPref == "Swaminarayan" ? black : Colors.transparent
                              ),
                              child: Text(
                                "Swaminarayan",
                                style: getRegularTextStyle(fontSize: 12,color: selectedPref == "Swaminarayan" ? white : black ),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ),

                  Visibility(
                    visible: productsItem.productVariations?.isNotEmpty ?? false,
                    child: Container(margin:EdgeInsets.only(top: 8,bottom: 6),
                      child: Text("Add-ons:",style: getRegularTextStyle(color: gray,fontSize: 12)))),

                  Visibility(
                    visible: productsItem.productVariations?.isNotEmpty ?? false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            itemSetState(() {
                              selectedVariation[productId] = "Regular";
                              mapPrice[productId] = productsItem.price ?? 0;
                            });
                          },
                          child: Row(
                            children: [
                              Image.asset(
                                selectedVariationName == "Regular"
                                    ? "assets/images/ic_radio.png"
                                    : "assets/images/ic_unSelected_radio.png",
                                color:   selectedVariationName == "Regular" ? null : gray,
                                height: 16,
                                width: 16,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                  "Regular",
                                style: getRegularTextStyle(
                                  fontSize: 12,
                                  color:  darkGray ,
                                ),
                              ),
                            ],
                          ),
                        ),
                        for (var variation in productsItem.productVariations!)
                          GestureDetector(
                            onTap: () {
                              itemSetState(() {
                                selectedVariation[productId] = variation.variationName!;
                                mapPrice[productId] = variation.price ?? 0;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 4),
                              child: Row(
                                children: [
                                  Image.asset(
                                    selectedVariationName == variation.variationName
                                        ? "assets/images/ic_radio.png"
                                        : "assets/images/ic_unSelected_radio.png",
                                    color:  selectedVariationName == variation.variationName ? null : gray,
                                    height: 16,
                                    width: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                        "${variation.variationName ?? ""} + ₹${(variation.price ?? 0) - (productsItem.price ?? 0)}",
                                      style: getRegularTextStyle(fontSize: 12,color: darkGray, ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  Visibility(
                    visible: productsItem.atfSpecial == 1,
                    child: Container(
                      margin: EdgeInsets.only(top: 8),
                      child: Image.asset(
                          "assets/images/atf_special.png",
                        height: 30,
                      ),
                    )
                  ),

                  if(productsItem.price == "" || productsItem.price == null)
                    Container(margin: EdgeInsets.only(top: 8,bottom: 8),child: Text("Coming Soon",style: getRegularTextStyle(color: gray),))
                  else
                    Container(
                      margin: EdgeInsets.only(top: 8),
                      child:Row(
                        children: [
                          Expanded(
                            child: Text("₹$selectedPrice",
                                style: getRegularTextStyle(fontSize: 16)),
                          ),
                          const Gap(8),
                          if(cartItemIndex != null)
                            Container(
                              height: 34,
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              decoration:getCommonCardWithoutShadow(bgSmoke,borderRadius: 50)
                              ,child: Row(
                              children: [
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: (){
                                    setState(() {
                                      if (listCart[cartItemIndex].quantity > 1) {
                                        listCart[cartItemIndex].quantity--;
                                      // onClickMinusButton[productId] = true;
                                      // onClickPlusButton[productId] = false;
                                      } else {
                                        listCart.removeAt(cartItemIndex);
                                        // onClickPlusButton[productId] = false;
                                        // onClickMinusButton[productId] = false;
                                      }
                                    });
                                  },
                                  child: Container(
                                    height : 28,
                                    width: 28,
                                    decoration: getCommonCard(shape: BoxShape.circle,bgColor: white),
                                    child: Center(child: Text("−",style: getRegularTextStyle(fontSize: 18,color: black),)),
                                  ),
                                ),
                                const Gap(12),
                                Text(listCart[cartItemIndex].quantity.toString(),style: getRegularTextStyle(fontSize: 14,color: black),),
                                const Gap(12),
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: (){
                                    setState(() {
                                        listCart[cartItemIndex].quantity++;
                                      });
                                  },child: Container(
                                  height : 28,
                                  width: 28,
                                  decoration: getCommonCard(shape: BoxShape.circle,bgColor: white),
                                  child: Center(child: Text("+",style: getRegularTextStyle(fontSize: 18,color: black),)),
                                ),
                                ),
                              ],
                            ),
                           )
                          else
                            SizedBox(
                              height: 34,
                              width: 70,
                              child: getCommonButton("ADD", false, () async {
                                  setState(() {
                                  listCart.add(CartItemModel(id: productId, product: productsItem, quantity: 1, preference:selectedPref , addOn: selectedVariationName, price: selectedPrice, multipleAddonName: selectedMultipleAddOns[productId]?.toList() ?? []));

                                  if(productsItem.multipleAddons?.isNotEmpty ?? false){
                                     selectedMultipleAddOns.remove(productId);
                                      mapPrice[productId] = productsItem.price ?? 0;
                                  }
                                });
                              }),
                            ),
                        ],
                      ),
                    ),
                ],
              );
            }
        ),
      );
  }

  openCartDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter sheetSetState) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.85,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: listCart.isEmpty ?
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    getBottomSheetHeaderWithButton(context, "Your Cart"),
                    const Gap(32),
                     Image.asset("assets/images/ic_empty_cart.png",height: 32,width: 32,),
                    const Gap(16),
                    Text("Your cart is empty",style: getRegularTextStyle(fontSize: 18,),),
                    const Gap(4),
                    Text("Add items to start ordering 🍽️",style: getRegularTextStyle(fontSize: 16,),),
                    const Gap(42),
                    Row(
                      children: [
                        Expanded(child: getCommonButton("Clear Cart", false, (){},bgColor: clearCartBtnBgColor,textColor: black,textPadding: EdgeInsets.only(left: 6,right: 6,top: 6,bottom: 6))),
                        const Gap(12),
                        Expanded(child: getCommonButton("Place Order", false, (){},bgColor: black,textPadding: EdgeInsets.only(left: 6,right: 6,top: 6,bottom: 6))),
                      ],
                    )
                  ],
                )
                : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    getBottomSheetHeaderWithButton(context, "Your Cart"),
                    const Gap(16),
                    Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: listCart.length,
                        physics: BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 20),
                        itemBuilder: (context, index) {
                          final item = listCart[index];
                          return DashedBorderBox(
                            showTop: index == 0 ? false : true,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                          Text("${item.product.productName ?? "-"} "
                                              "${item.multipleAddonName.isNotEmpty ?"- ${item.multipleAddonName.join(", ")}" : "" }"
                                              "${item.addOn == "Regular" ? "" : "- ${item.addOn}"} "
                                              "${item.preference == "Regular" ? "" :"(${item.preference})"} ",style: getRegularTextStyle(fontSize: 16),),
                                      const Gap(4),
                                      Text("Qty: ${item.quantity}",style: getRegularTextStyle(fontSize: 14,color: gray),),
                                    ],
                                  ),
                                ),
                                const Gap(8),
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    setState(() {
                                     listCart.removeAt(index);
                                    });
                                    sheetSetState((){});
                                  },
                                    child: Image.asset("assets/images/ic_delete.png",height: 22,width: 22,))
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const Gap(4),
                    DashedBorderBox(
                      showTop: true,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            Text("Total",style: getSemiBoldTextStyle(fontSize: 18),),
                          const Gap(8),
                          Text("₹${getAmountTotal()}",style: getSemiBoldTextStyle(fontSize: 18),)
                        ],
                      ),
                    ),
                    const Gap(14),
                    Row(
                      children: [
                        Expanded(child: getCommonButton("Clear Cart", false, (){
                          setState(() {
                          listCart.clear();
                          Navigator.pop(context);
                          });
                          sheetSetState((){});
                        },bgColor: clearCartBtnBgColor,textColor: black,textPadding: EdgeInsets.only(left: 6,right: 6,top: 6,bottom: 6))),
                        const Gap(12),
                        Expanded(child: getCommonButton("Place Order", false, (){
                          Navigator.pop(context);
                          openOrderDialog();
                        },bgColor: black,textPadding: EdgeInsets.only(left: 6,right: 6,top: 6,bottom: 6))),
                      ],
                    )
                  ],
                ),
              ),
            );
          }
        );
      },
    );
  }

  openOrderDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        bool _placeOrderLoading = false;
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter sheetSetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),

              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.85,
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        getBottomSheetHeaderWithButton(context, "Place Order"),
                        const Gap(6),
                        TextFormField(
                          keyboardType: TextInputType.name,
                          controller: nameController,
                          onTapOutside: (value) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          decoration: const InputDecoration(
                            hintText: "Enter Your Name",
                          ),
                        ),
                        const Gap(16),
                        TextFormField(
                          keyboardType: TextInputType.phone,
                          controller: numberController,
                          onTapOutside: (value) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          decoration: const InputDecoration(
                            hintText: "Enter Mobile number",
                          ),
                        ),
                        const Gap(16),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          controller: noteController,
                          maxLines: 2,
                          onTapOutside: (value) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          decoration: const InputDecoration(
                            alignLabelWithHint: true,
                            hintText: "Restaurant notes (optional)",
                          ),
                        ),
                        const Gap(16),
                        Row(
                          children: [
                            Expanded(
                              child: getCommonButton(
                                "Cancel",
                                false,
                                    () {
                                  Navigator.pop(context);
                                  numberController.clear();
                                  noteController.clear();
                                },
                                bgColor: clearCartBtnBgColor,
                                textColor: black,
                                textPadding: const EdgeInsets.only(left: 6,right: 6,top: 6,bottom: 6),
                              ),
                            ),
                            const Gap(12),
                            Expanded(
                              child: getCommonButton(
                                "Order on WhatsApp",
                                _placeOrderLoading,
                                    () async {

                                   if(nameController.text.isEmpty){
                                     showToast("Name is required", context);
                                   }else
                                   if(numberController.value.text.isEmpty){
                                     showToast("Mobile number is required", context);
                                   }else if(numberController.text.length != 10){
                                     showToast("Mobile number must be 10 digits", context);
                                   }else{
                                     sheetSetState((){
                                       _placeOrderLoading = true;
                                     });
                                      // final apiListItem = prepareCartItemsForApi();
                                     bool result = await _callPaceOrderApi();
                                     if(result){

                                     sheetSetState((){
                                       _placeOrderLoading = false;
                                     });
                                     bool isLaunched = await openWhatsApp("917304730633",generateWhatsAppMessage());
                                     if (isLaunched) {
                                       Navigator.pop(context);
                                       setState(() {
                                       listCart.clear();
                                       });
                                     }else{
                                       showToast("Cannot open WhatsApp", context);
                                     }
                                     }
                                   }
                                },
                                bgColor: black,
                                textPadding: const EdgeInsets.only(left: 2,right: 2,top: 6,bottom: 6),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  String generateWhatsAppMessage() {
    String message = "Hello, I want to order:\n\n";

    int index = 1;

    for (var item in listCart) {
    message +=
      "$index. ${item.product.productName ?? "-"} "
          "${item.multipleAddonName.isNotEmpty ?"- ${item.multipleAddonName.join(", ")}" : "" }"
          "${item.addOn == "Regular" ? "" : "- ${item.addOn}"} "
          "${item.preference == "Regular" ? "" :"(${item.preference})"} "
            "- Qty: ${item.quantity}\n";
      index++;
    }
    if(noteController.text.isNotEmpty){
    message += "\nNote: ${noteController.text.trim()}";
    }
    message += "\nCustomer Mobile: ${numberController.text.trim()}";

    return message;
  }

  num getAmountTotal() {
    return listCart.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  int getTotalQty() {
    return listCart.fold(0, (sum, item) => sum + item.quantity);
  }

  int? getCartItemIndex(
      String productId,
      String pref,
      String variation,
      Set<String> selectedSet,
      ) {
    for (int i = 0; i < listCart.length; i++) {
      final item = listCart[i];

      if (item.id == productId &&
          item.preference == pref &&
          item.addOn == variation &&
          setEquals(item.multipleAddonName.toSet(), selectedSet)) {
        return i;
      }
    }
    return null;
  }

  _fetchMenuData() async {
    if (isOnline) {
      try {
        setState(() {
          _isLoading = true;
        });

        HttpWithMiddleware http = logger();
        final url = Uri.parse(apiMenuItems);

        final  Map<String, String> jsonBody = {
          "location_id": "3",
        };

        final response = await http.post(url,body: jsonBody,);
        final statusCode = response.statusCode;
        final body = response.body;
        Map<String, dynamic> user = jsonDecode(body);
        var dataResponse = MenuScreenResponseModel.fromJson(user);

        print("Display status code : $statusCode");

        if (statusCode == 200 && dataResponse.success == 1) {
          listAllDayMenu = dataResponse.menuData?.allDayMenu ?? [];
          listMorningMenu = dataResponse.menuData?.morningMenu ?? [];
          listCart = sessionManager.getCartList();
          setState(() {
            _isLoading = false;
          });
        } else {
          showToast(dataResponse.message, context);
          setState(() {
            _isLoading = false;
          });
        }
      } catch (error) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
        print("Failed to fetch  menu items : $error");
      }
    } else {
      noInterNet(context);
    }
  }

  Future<bool> _callPaceOrderApi() async {
    if (isOnline) {
      try {

        HttpWithMiddleware http = logger();
        final url = Uri.parse(apiPlaceOrder);

        final  Map<String, String> jsonBody = {
          "location_id": "3",
          "customer_name": nameController.text,
          "customer_contact_no":numberController.text,
          "order_type":"DINE_IN",
          "is_preorder":"0",
          "items":jsonEncode(prepareCartItemsForApi()),
        };
print(jsonBody);
        final response = await http.post(url,body: jsonBody,);
        final statusCode = response.statusCode;
        final body = response.body;
        Map<String, dynamic> user = jsonDecode(body);
        var dataResponse = PlaceOrderResponseModel.fromJson(user);

        print("Display status code : $statusCode");

        if (statusCode == 200 && dataResponse.success == 1) {

          return true;
        } else {
          showToast(dataResponse.message, context);
          return false;

        }
      } catch (error) {
        print("Failed to placeOrder : $error");
          return false;
      }
    } else {
      noInterNet(context);
      return false;
    }
  }


  List<List<Products>> getPairs(List<Products> list) {
    List<List<Products>> pairs = [];

    for (int i = 0; i < list.length; i += 2) {
      if (i + 1 < list.length) {
        pairs.add([list[i], list[i + 1]]);
      } else {
        pairs.add([list[i]]);
      }
    }

    return pairs;
  }


  @override
  void castStatefulWidget() {
    widget is MenuScreen;
  }


  @override
  void dispose() {
    _controller.dispose();
    sessionManager.setCartList(listCart);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused) {
      sessionManager.setCartList(listCart);
      print("set list cart to session paused method${listCart.length}");
    }

    if (state == AppLifecycleState.detached) {
      sessionManager.setCartList(listCart);
      print("set list cart to session detached method ${listCart.length}");
    }

    if (state == AppLifecycleState.inactive) {
      sessionManager.setCartList(listCart);
      print("All in active <><><> ${listCart}");
    }
    if (state == AppLifecycleState.hidden) {
      sessionManager.setCartList(listCart);
      print("App hidden che <><> ${listCart}");
    }

    if (state == AppLifecycleState.resumed) {
      setState(() {
      listCart = sessionManager.getCartList();
        print("list cart from session resumed method${listCart}");
      });
    }
  }


  List<Map<String, dynamic>> prepareCartItemsForApi() {
    return listCart.map((cartItem) {
      String variationId = "";

      if (cartItem.addOn != "Regular") {
        final variation = cartItem.product.productVariations
            ?.firstWhere(
              (v) => v.variationName == cartItem.addOn,
          orElse: () => ProductVariations(),
        );

        variationId = variation?.variationId?.toString() ?? "";
      }

      List<Map<String, dynamic>> addons = [];

      for (var addonName in cartItem.multipleAddonName) {
        final addon = cartItem.product.multipleAddons?.firstWhere(
              (a) => a.multipleAddonName == addonName,
          orElse: () => MultipleAddons(),
        );

        if (addon != null) {
          addons.add({
            "name": addon.multipleAddonName ?? "",
            "price": addon.multipleAddonPrice?.toString() ?? "0",
            "qty": "1",
          });
        }
      }

      return {
        "item_id": cartItem.product.productId ?? "",
        "variation_id": variationId,
        "qty": cartItem.quantity.toString(),
        "addons": addons,
        "jain_available":cartItem.preference== "Jain" ?  1 : 0,
        "swaminarayan_available":cartItem.preference== "Swaminarayan" ?  1 : 0,
      };
    }).toList();
  }

}