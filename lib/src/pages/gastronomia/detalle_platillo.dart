import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vilaexplorer/l10n/app_localizations.dart';
import 'package:vilaexplorer/models/gastronomia/plato.dart';

const kButtonBackgroundColorSelected = Color.fromRGBO(32, 29, 29, 0.9);
const kButtonBackgroundColorUnselected = Color.fromRGBO(45, 45, 45, 1);
const kButtonTextStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.w300,
  fontSize: 18,
  decoration: TextDecoration.none,
);
const kIngredientesTextStyle = TextStyle(
  fontSize: 16,
  color: Colors.white,
  fontWeight: FontWeight.w300,
  decoration: TextDecoration.none,
);
const kTituloTextStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontSize: 22,
  decoration: TextDecoration.none,
);

class DetallePlatillo extends StatefulWidget {
  static const String route = 'DetallePlato';

  const DetallePlatillo({
    super.key,
  });

  @override
  _DetallePlatilloState createState() => _DetallePlatilloState();
}

class _DetallePlatilloState extends State<DetallePlatillo> {
  bool showIngredientes = true;
  late Plato _plato;

  // @override
  // Widget build(BuildContext context) {
  //   _plato = ModalRoute.of(context)!.settings.arguments as Plato;
  //   final size = MediaQuery.sizeOf(context);

  //   return Align(
  //     alignment: Alignment.bottomCenter,
  //     child: Container(
  //       height: size.height * 0.65,
  //       width: size.width,
  //       decoration: const BoxDecoration(
  //         color: Color.fromRGBO(32, 29, 29, 0.9),
  //         borderRadius: BorderRadius.only(
  //           topLeft: Radius.circular(20),
  //           topRight: Radius.circular(20),
  //         ),
  //       ),
  //       child: Column(
  //         children: [
  //           Padding(
  //             padding: const EdgeInsets.all(10.0),
  //             child: Stack(
  //               children: [
  //                 Align(
  //                   alignment: Alignment.centerLeft,
  //                   child: IconButton(
  //                     icon:
  //                         const Icon(Icons.arrow_back, color: Colors.white),
  //                     onPressed: () => Navigator.pop(context),
  //                   ),
  //                 ),
  //                 Align(
  //                   alignment: Alignment.center,
  //                   child: Text(
  //                     _plato.nombre,
  //                     style: kTituloTextStyle,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 15.0),
  //             child: ClipRRect(
  //               borderRadius: BorderRadius.circular(15),
  //               child: Image.asset(
  //                 'assets/images_gastronomia/paella-valenciana.jpg',
  //                 height: 200,
  //                 width: double.infinity,
  //                 fit: BoxFit.cover,
  //               ),
  //             ),
  //           ),
  //           const SizedBox(height: 10),
  //           _buildButtonRow(size),
  //           Expanded(
  //             child: Padding(
  //               padding: const EdgeInsets.all(20.0),
  //               child: SingleChildScrollView(
  //                 child: showIngredientes
  //                     ? _buildIngredientes()
  //                     : _buildReceta(),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildButtonRow(Size size) {
  //   return Container(
  //     padding: EdgeInsets.symmetric(vertical: 8.h),
  //     margin: EdgeInsets.symmetric(
  //         horizontal: 14.w),
  //     decoration: BoxDecoration(
  //       color: const Color.fromARGB(255, 55, 55, 55),
  //       borderRadius: BorderRadius.circular(20.r),
  //     ),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //       children: [
  //         _buildToggleButton(
  //           AppLocalizations.of(context)!.translate('ingredients'),
  //           showIngredientes,
  //           () {
  //             setState(() {
  //               showIngredientes = true;
  //             });
  //           },
  //         ),
  //         _buildToggleButton(
  //           AppLocalizations.of(context)!.translate('recipe'),
  //           !showIngredientes,
  //           () {
  //             setState(() {
  //               showIngredientes = false;
  //             });
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildToggleButton(
  //     String text, bool isSelected, VoidCallback onPressed) {
  //   return Expanded(
  //     child: GestureDetector(
  //       onTap: onPressed,
  //       child: Container(
  //         padding: EdgeInsets.symmetric(
  //             vertical: 10.h,
  //             horizontal: 10.w),
  //         margin: EdgeInsets.symmetric(
  //             horizontal: isSelected
  //                 ? 5.w
  //                 : 0),
  //         decoration: BoxDecoration(
  //           color: isSelected
  //               ? Colors.grey[700]
  //               : const Color.fromARGB(255, 55, 55, 55),
  //           borderRadius: BorderRadius.circular(17),
  //         ),
  //         alignment: Alignment.center,
  //         child: Text(
  //           text,
  //           style: kButtonTextStyle,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildIngredientes() {
  //   return Text(
  //     _plato.ingredientes,
  //     style: kIngredientesTextStyle,
  //   );
  // }

  // Widget _buildReceta() {
  //   return Text(
  //     _plato.receta,
  //     style: kIngredientesTextStyle,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    _plato = ModalRoute.of(context)!.settings.arguments as Plato;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(icon: Icon(Icons.favorite_border, color: Colors.white,), onPressed: () {})
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _plato.nombre,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text(_plato.descripcion, style: TextStyle(color: Colors.white),),
                      Spacer(),
                      Icon(Icons.star, color: Colors.amber),
                      Text("${_plato.puntuacionMediaPlato}"),
                    ],
                  ),
                  SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      _plato.imagen!,
                      width: double.infinity,
                      height: constraints.maxWidth * 0.6,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          "assets/no-image.jpg",
                          height: constraints.maxWidth * 0.6,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Text("Receta", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      Spacer(),
                      Icon(Icons.access_time, size: 18, color: Colors.white,),
                      Text("15 min"),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(_plato.receta, style: TextStyle(color: Colors.white),),
                  SizedBox(height: 16),
                  Text("Add extra Ingredients",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  SizedBox(height: 8),
                  ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      _buildIngredientItem("Mushroom", "50 gm", 0.40, context),
                      _buildIngredientItem(
                          "Mayonnaise", "1/4 cup", 0.20, context),
                      _buildIngredientItem(
                          "Peeled boiled egg", "1 egg", 0.50, context),
                      _buildIngredientItem(
                          "Lemon juice", "10 ml", 0.30, context),
                    ],
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      minimumSize: Size(double.infinity, 50),
                    ),
                    onPressed: () {},
                    child: Text("Add to Cart",
                        style: TextStyle(color: Colors.black)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildIngredientItem(
      String name, String quantity, double price, BuildContext context,
      {int quantityCount = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: Colors.grey.shade200, radius: 20),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                Text("$quantity - \$$price", style: TextStyle(color: Colors.white),),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                  icon: Icon(Icons.remove_circle_outline, color: Colors.white,), onPressed: () {}),
              Text("$quantityCount", style: TextStyle(color: Colors.white),),
              IconButton(
                  icon: Icon(Icons.add_circle_outline, color: Colors.white), onPressed: () {}),
            ],
          ),
        ],
      ),
    );
  }
}
