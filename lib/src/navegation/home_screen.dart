import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart'; // Importa el plugin de geocoding


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late GoogleMapController mapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Position? _currentPosition;
  String? _currentAddress;

  void initState() {
    super.initState();
    _getCurrentLocation();
    _getMarkersFromFirebase(); // Nuevo método para obtener marcadores de Firebase
  }

  void _getMarkersFromFirebase() async {
    // Recuperar la colección "reporte" de Firebase
    QuerySnapshot reportes = await FirebaseFirestore.instance.collection('reporte').get();

    // Iterar sobre los documentos en la colección
    reportes.docs.forEach((doc) {
      // Obtener las coordenadas del documento
      List<dynamic> coordenadas = doc['coordenadas'];

      // Crear un nuevo marcador con las coordenadas del documento
      Marker marker = Marker(
        markerId: MarkerId(doc.id),
        position: LatLng(coordenadas[0], coordenadas[1]),
        infoWindow: InfoWindow(title: 'Reporte', snippet: 'Descripción del reporte'),
      );


      // Agregar el marcador al conjunto de marcadores
      setState(() {
        markers[MarkerId(doc.id)] = marker;
      });
    });
  }


  void _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    final address = await _getAddressFromLatLng(position);
    setState(() {
      _currentPosition = position;
      _currentAddress = address;
    });
  }

  Future<String> _getAddressFromLatLng(Position position) async {
    final coordinates = LatLng(position.latitude, position.longitude); // Usa LatLng
    final List<Placemark> placemarks = await placemarkFromCoordinates(coordinates.latitude, coordinates.longitude); // Usa placemarkFromCoordinates
    final Placemark place = placemarks[0];
    return "${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}";
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  // Navegar al perfil


  @override
  Widget build(BuildContext context) {
    LatLng initialPosition = _currentPosition != null
        ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
        : LatLng(0, 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Geo Visor A&S',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigoAccent,
        centerTitle: true,
      ),

      body: _currentPosition != null
          ? Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: initialPosition,
              zoom: 16.0,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Latitud: ${_currentPosition!.latitude.toStringAsFixed(6)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Longitud: ${_currentPosition!.longitude.toStringAsFixed(6)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Dirección: $_currentAddress',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () {

        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
