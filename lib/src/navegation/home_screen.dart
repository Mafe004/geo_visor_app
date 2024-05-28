import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

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

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _getMarkersFromFirebase(); // Obtener marcadores de Firebase
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
    final coordinates = LatLng(position.latitude, position.longitude);
    final List<Placemark> placemarks = await placemarkFromCoordinates(coordinates.latitude, coordinates.longitude);
    final Placemark place = placemarks[0];
    return "${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}";
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<double> _getMarkerColor(String userId) async {
    final userDoc = await FirebaseFirestore.instance.collection('Usuarios').doc(userId).get();
    if (userDoc.exists) {
      return BitmapDescriptor.hueBlue;
    }
    final entityDoc = await FirebaseFirestore.instance.collection('DatosEntidad').doc(userId).get();
    if (entityDoc.exists) {
      return BitmapDescriptor.hueGreen;
    }
    return BitmapDescriptor.hueRed; // Default color if userId not found in either collection
  }

  Future<void> _getMarkersFromFirebase() async {
    QuerySnapshot reportes = await FirebaseFirestore.instance.collection('Reportes').get();

    for (var doc in reportes.docs) {
      GeoPoint? geoPoint = doc['coordenadas'];
      String userId = doc['userId'];

      if (geoPoint != null) {
        final markerColor = await _getMarkerColor(userId);
        Marker marker = Marker(
          markerId: MarkerId(doc.id),
          position: LatLng(geoPoint.latitude, geoPoint.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(markerColor),
          onTap: () {
            _showMarkerDetails(doc);
          },
        );

        setState(() {
          markers[MarkerId(doc.id)] = marker;
        });
      }
    }
  }

  void _showMarkerDetails(DocumentSnapshot doc) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Detalles del Reporte',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text('Ubicación: ${doc['ubicacion']}'),
              Text('Descripción: ${doc['Descripcion']}'),
              Text('Usuario: ${doc['userId']}'),
              // Puedes agregar más detalles aquí
            ],
          ),
        );
      },
    );
  }

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
            markers: Set<Marker>.of(markers.values), // Mostrar los marcadores en el mapa
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
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Entidad',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Usuario',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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
          // Acción para realizar al presionar el botón flotante
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
