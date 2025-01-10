import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // Asegúrate de que la base de datos esté correctamente inicializada
  static Future<Database> openDatabaseConnection() async {
    return openDatabase(
      'your_database.db', // Cambia esta ruta según sea necesario
      version: 1,
      onCreate: (Database db, int version) async {
        // Aquí puedes crear las tablas si no existen
        await db.execute('''
          CREATE TABLE lugar_interes (
            id_lugar_interes INTEGER PRIMARY KEY,
            activo BIT NOT NULL,
            descripcion VARCHAR(255) NOT NULL,
            fecha_alta DATE NOT NULL,
            imagen VARCHAR NOT NULL,
            nombre_lugar VARCHAR(255) NOT NULL,
            puntuacion_media_lugar DOUBLE,
            id_tipo_lugar INTEGER NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE coordenadas (
            id_coordenadas INTEGER PRIMARY KEY,
            latitud DOUBLE NOT NULL,
            longitud DOUBLE NOT NULL,
            id_lugar_interes INTEGER NOT NULL,
            id_ruta INTEGER NOT NULL,
            FOREIGN KEY (id_lugar_interes) REFERENCES lugar_interes(id_lugar_interes)
          )
        ''');
      },
    );
  }

  // Función para obtener lugares con sus coordenadas
  static Future<List<Map<String, dynamic>>> fetchPlacesWithCoordinates(Database db) async {
    return await db.rawQuery('''
      SELECT Places.id, Places.name, Coordinates.latitude, Coordinates.longitude
      FROM Places
      INNER JOIN Coordinates ON Places.id = Coordinates.place_id
    ''');
  }
}
