import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vilaexplorer/l10n/app_localizations.dart';
import 'package:vilaexplorer/service/weather_service.dart';
import 'package:vilaexplorer/src/pages/homePage/menu_principal.dart';
import 'package:vilaexplorer/src/pages/search/search_delegate.dart';

class AppBarCustom extends StatelessWidget {
  final Weather? weatherData;
  const AppBarCustom({
    super.key,
    this.weatherData,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 120.h,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      elevation: 0,
      title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _contentAppBar(context),
          ),
          _searchBar(context),
        ],
      ),
    );
  }

  List<Widget> _contentAppBar(BuildContext context) {
    return <Widget>[
      Container(
        padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.h),
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 24, 24, 24),
            borderRadius: BorderRadius.all(Radius.circular(15.r))),
        child: GestureDetector(
          onTap: () async {
            return showModalBottomSheet(
              backgroundColor: Colors.transparent,
              context: context,
              isScrollControlled: true,
              isDismissible: true,
              enableDrag: true,
              sheetAnimationStyle: AnimationStyle(
                  duration: Duration(milliseconds: 400),
                  reverseDuration: Duration(milliseconds: 300)),
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
      Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: Color.fromRGBO(32, 29, 29, 0.9),
          borderRadius: BorderRadius.all(Radius.circular(20.r)),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          child: Row(
            children: [
              Text(
                weatherData?.nombreLugar ?? 'Not vailabe',
                style: TextStyle(
                  fontFamily: 'assets/fonts/Poppins-ExtraLight.ttf',
                  fontSize: 20.sp,
                ),
              ),
            ],
          ),
        ),
      ),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 24, 24, 24),
          borderRadius: BorderRadius.all(Radius.circular(20.r)),
        ),
        child: Row(
          children: [
            Icon(
              getWeatherIcon(weatherData?.estadoClimatico ?? ''),
              color: Colors.white,
              size: 24.r,
            ),
            SizedBox(width: 8.w),
            Text(
              weatherData?.temperatura != null 
                ? '${(weatherData!.temperatura - 273.15).round()}°' 
                : 'Error°',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      )
    ];
  }

   IconData getWeatherIcon(String estadoClimatico) {
    switch (estadoClimatico.toLowerCase()) {
      case 'clear':
        return Icons.wb_sunny; // Soleado
      case 'clouds':
        return Icons.cloud; // Nublado
      case 'rain':
        return Icons.umbrella; // Lluvioso
      case 'snow':
        return Icons.ac_unit; // Nevado
      default:
        return Icons.help; // Desconocido
    }
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
              flex: 5,
              child: TextField(
                onTap: () => showSearch(
                  context: context,
                  delegate: LugarDeInteresDelegate(),
                  maintainState: true,
                  useRootNavigator: true
                ),
                decoration: InputDecoration(
                  hintText:
                      AppLocalizations.of(context)!.translate('mp_search'),
                  hintStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                ),
                style: TextStyle(color: Colors.white),
              ),
            ),
            Expanded(
              child: Icon(Icons.search, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
