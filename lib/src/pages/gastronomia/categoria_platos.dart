import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

const kContainerColor = Color.fromRGBO(45, 45, 45, 1);
const kBackgroundOverlayColor = Color.fromRGBO(32, 29, 29, 0.9);
const kImageHeight = 150.0;
const kPadding = 10.0;
const kTitleTextStyle = TextStyle(
  color: Colors.white,
  fontFamily: 'Roboto',
  fontWeight: FontWeight.w300,
  fontSize: 24,
  decoration: TextDecoration.none,
);

class CategoriaPlatos extends StatelessWidget {
  final String category;
  final VoidCallback onClose;
  final ValueChanged<String> onPlatilloSelected;

  const CategoriaPlatos({
    super.key,
    required this.category,
    required this.onClose,
    required this.onPlatilloSelected,
  });

  Future<List<Map<String, dynamic>>> _loadDishes() async {
    final String response = await rootBundle.loadString('assets/gastronomia.json');
    final data = json.decode(response);
    final categoryData = data['categories'].firstWhere((cat) => cat['name'] == category);
    return List<Map<String, dynamic>>.from(categoryData['dishes']);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _loadDishes(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final dishes = snapshot.data!;

        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: size.height * 0.65,
            decoration: BoxDecoration(
              color: kBackgroundOverlayColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Container(
                    width: 100,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: onClose,
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          category,
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                            fontSize: 22,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: dishes.length,
                    itemBuilder: (context, index) {
                      final dish = dishes[index];
                      return _buildDishExpansionTile(context, dish);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDishExpansionTile(BuildContext context, Map<String, dynamic> dish) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Container(
        decoration: BoxDecoration(
          color: kContainerColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: ExpansionTile(
          collapsedIconColor: Colors.white,
          iconColor: Colors.white,
          title: Text(
            dish['name'],
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w300,
              fontSize: 20,
            ),
          ),
          children: [
            _buildImage(dish['image']),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Ingredientes:'),
                  Text(
                    dish['ingredients'],
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildSectionTitle('Receta:'),
                  Text(
                    dish['recipe'],
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String imagePath) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: Image.asset(
        imagePath,
        width: double.infinity,
        height: kImageHeight,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }
}
