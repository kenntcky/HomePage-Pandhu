import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'dart:math' show cos, sqrt, asin;
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

import '../local_widgets/detail_eq.dart';
import '../local_widgets/infosr.dart';
import '../local_widgets/tsunami_potential.dart';

const String BMKG_API_URL = 'https://data.bmkg.go.id/DataMKG/TEWS/autogempa.json';

class Googlemapflutter extends StatefulWidget {
  const Googlemapflutter({super.key});

  @override
  State<Googlemapflutter> createState() => _GooglemapflutterState();
}

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}

class _GooglemapflutterState extends State<Googlemapflutter> {


    Position? _currentPosition;
    BitmapDescriptor customIcon = BitmapDescriptor.defaultMarker;
    Map<String, dynamic>? gempaData;
    double? gempaDistance;
    List<double>? gempaCoordinates;
    Map<String, double>? coordinates;

    @override
    void initState() {
      customMarker();
      super.initState();
      readData();
      getGempaCoordinates();
      getGempaHumanReadableAddress();
      _getPositionAndCalculateDistance();
    }

    void customMarker() {
      BitmapDescriptor.asset(
        const ImageConfiguration(),
        "assets/icons/marker.png"
        ).then((icon) {
          setState(() {
            customIcon = icon;
          });
        }
      );
    }

    Future<void> readData() async {
      DatabaseReference ref = FirebaseDatabase.instance.ref();

      ref.orderByKey().limitToLast(1).onValue.listen((DatabaseEvent event) async{
        final data = event.snapshot.value;
        if (data != null) {
          // The returned data will be a map where the key is the timestamp
          // and the value is the earthquake data.
          Map<String, dynamic> dataMap = Map<String, dynamic>.from(data as Map);

          // Extract the latest earthquake data
          String latestKey = dataMap.keys.first;
          Map<String, dynamic> latestEarthquake = Map<String, dynamic>.from(dataMap[latestKey]['Infogempa']['gempa']);

          setState(() {
            gempaData = latestEarthquake;
          });
          getGempaCoordinates();
        }
      });
    }

    void getGempaCoordinates() async {
      if (gempaData == null) {
        return;
      }

      String coordinatesBMKG = gempaData!['Coordinates'];

      // Convert string coordinates dari BMKG API ke array
      List<String> parts = coordinatesBMKG.split(',');
      var gempaCoordinatesx = List<double>.filled(2, 0);

      if (parts.length == 2) {
        gempaCoordinatesx[0] = double.parse(parts[0].trim());
        gempaCoordinatesx[1] = double.parse(parts[1].trim());
      }

      setState(() {
        gempaCoordinates = gempaCoordinatesx;
      });
    }

    Future<double> calculateGempaDistance(latitude, longitude) async {
      if (gempaData == null || _currentPosition == null) return 0.0;

      return calculateDistance(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        latitude,
        longitude,
      );
    }

    void getGempaHumanReadableAddress() async {
      if (gempaCoordinates == null) {
        return;
      }

      List<Placemark> placemarks = await placemarkFromCoordinates(-4.12,129.79);
      print(placemarks);
      Placemark placemark = placemarks[0];


}

    void _getPositionAndCalculateDistance() async {
      try {
        Position position = await _determinePosition();
        List<Placemark> placemarks = await placemarkFromCoordinates(gempaCoordinates![0], gempaCoordinates![1]);
        print(placemarks);
        setState(() {
          _currentPosition = position;
        });

        double distance = await calculateGempaDistance(gempaCoordinates![0], gempaCoordinates![1]);
        setState(() {
          gempaDistance = distance;
        });
      } catch (e) {
        print('Error: $e');
      }
    }

    double calculateDistance(lat1, lon1, lat2, lon2) {
      var p = 0.017453292519943295;
      var c = cos;
      var a = 0.5 - c((lat2 - lat1) * p)/2 +
          c(lat1 * p) * c(lat2 * p) *
              (1 - c((lon2 - lon1) * p))/2;
      return 12742 * asin(sqrt(a));
    }

  @override
  Widget build(BuildContext context) {
      // print("Data Gempa: ${gempaData!['Coordinates']}");
    return Scaffold(
      body: gempaCoordinates == null && gempaData == null && gempaDistance == null
        ? Center(child: CircularProgressIndicator()) // Show loading if data is not yet available
        : Stack(
        children: [
          Container(
            child: GoogleMap(initialCameraPosition: CameraPosition(
              target: LatLng(gempaCoordinates![0], gempaCoordinates![1]),
              zoom : 2
            ),
            markers: {
              Marker(markerId: MarkerId('1'),
              position: LatLng(gempaCoordinates![0], gempaCoordinates![1]),
              anchor: const Offset(0.5, 0.5),
              draggable: true,
              icon: customIcon,
              )
            }
            ),
          ),
          Container(
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  AppBar(
                    toolbarHeight: 78,
                    title : Text('Informasi Gempa'),
                    leading: Icon(Icons.arrow_back),
                    centerTitle: true,
                  ),
                ],
              ),
            ),
          ),
          Container(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            height: 140,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              color: Colors.white
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      infosr(
                                        satuangempa: gempaData!['Magnitude'],
                                        icongempa: 'assets/icons/sr.png',
                                        namabawah: 'Magnitudo',
                                      ),
                                      Container(
                                        width: 1,
                                        height: 70,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFCCCCCC)
                                          // color: Colors.black
                                          ),
                                        ),
                                      infosr(
                                        satuangempa: 'Mijen',
                                        icongempa: 'assets/icons/location.png',
                                        namabawah: 'Kota Semarang',
                                      ),
                                      Container(
                                        width: 1,
                                        height: 70,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFCCCCCC)
                                          // color: Colors.black
                                          ),
                                        ),
                                      infosr(
                                        satuangempa: gempaData!['Kedalaman'],
                                        icongempa: 'assets/icons/map.png',
                                        namabawah: 'Kedalaman',
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  TsunamiPotential()
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 195,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(24))
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  DetailEq(
                                    headline: "Waktu",
                                    detailicon: "assets/icons/clock.png",
                                    detaildata: "${gempaData!['Tanggal']}, ${gempaData!['Jam']}"
                                    ),

                                  DetailEq(
                                    headline: "Koordinat",
                                    detailicon: "assets/icons/coordinate.png",
                                    detaildata: "${gempaData!['Lintang']}, ${gempaData!['Bujur']}"
                                    ),

                                  DetailEq(
                                    headline: "Jarak",
                                    detailicon: "assets/icons/distance.png",
                                    detaildata: gempaDistance != null
                                        ? "${gempaDistance!.toStringAsFixed(2)} km"
                                        : 'Memuat...'
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Color(0xFFF6643C),
                            borderRadius: BorderRadius.all(Radius.circular(12))
                          ),
                          child: 
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Lebih lanjut',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              Container(
                                width: 24,
                                height: 24,
                                child: Image.asset("assets/icons/arrow-right.png",
                                fit: BoxFit.fill,
                                )
                                )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      );
  }
}
