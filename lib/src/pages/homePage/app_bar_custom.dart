import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vilaexplorer/l10n/app_localizations.dart';
import 'package:vilaexplorer/src/pages/homePage/menu_principal.dart';

class AppBarCustom extends StatelessWidget {
  const AppBarCustom({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
          toolbarHeight: 120.h,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black87.withOpacity(0),
          foregroundColor: Colors.white,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: _contentAppBar(context),
              ),
              _searchBar(context),
            ],
          ),
    );
  }

  List<Widget> _contentAppBar(BuildContext context) {
    return <Widget>[
      Padding(
        padding: EdgeInsets.only(left: 5.w, right: 10.w),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.h),
          decoration: BoxDecoration(color: Color.fromARGB(255, 24, 24, 24),
              borderRadius: BorderRadius.all(Radius.circular(15.r))),
          child: GestureDetector(
            onTap: () async {
              return showModalBottomSheet(
                backgroundColor: Colors.transparent,
                context: context,
                sheetAnimationStyle: AnimationStyle(duration: Duration(milliseconds: 400)),
                builder: (BuildContext context) {
                  return MenuPrincipal();
                },
              );
            },
            child: Container(
              height: 42.h,
              width: 50.w,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 24, 24, 24),
                  borderRadius: BorderRadius.all(Radius.circular(12.r))),
              child: Icon(
                Icons.menu,
                size: 30.r,
              ),
            ),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(right: 50.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
          decoration: BoxDecoration(
            color: Color.fromRGBO(32, 29, 29, 0.9),
            borderRadius: BorderRadius.all(Radius.circular(20.r)),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: MySvgWidget(path: 'lib/icon/location.svg'),
                ),
                Text(
                  AppLocalizations.of(context)!.translate('villajoyosa'),
                  style: TextStyle(
                    fontFamily: 'assets/fonts/Poppins-ExtraLight.ttf',
                    fontSize: 20.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      Spacer(),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 24, 24, 24),
          borderRadius:
              BorderRadius.all(Radius.circular(20.r)), // Redondear el borde
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 5.w),
              child: MySvgWidget(path: "lib/icon/sol_icon.svg", height: 20.h),
            ),
            Text(AppLocalizations.of(context)!.translate('weather_number')),
          ],
        ),
      ),
    ];
  }

  Widget _searchBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 5.w, top: 5, bottom: 5.h),
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(32, 29, 29, 0.9),
          borderRadius: BorderRadius.all(Radius.circular(30.r)),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.translate('mp_search'),
                  hintStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                ),
                style: TextStyle(color: Colors.white),
              ),
            ),
            IconButton(
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: () {
                // Add search functionality here
              },
            ),
          ],
        ),
      ),
    );
  }
}