import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late GoogleMapController mapController;
  LatLng? _center;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  void _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verificar si el servicio de ubicación está habilitado
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Mostrar diálogo para habilitar servicios de ubicación
      return;
    }

    // Verificar permisos de ubicación
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Mostrar diálogo de permisos
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Mostrar diálogo para ir a la configuración y habilitar permisos de ubicación manualmente
      return;
    }

    // Obtener la posición del usuario
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _center = LatLng(position.latitude, position.longitude);
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Geo Visor A&S',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigoAccent,
        centerTitle: true,
      ),
      body: _center != null
          ? GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center!,
          zoom: 11.0,
        ),
      )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
