import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapUI extends StatefulWidget {
  const MapUI({Key? key}) : super(key: key);

  @override
  State<MapUI> createState() => _MapUIState();
}

class _MapUIState extends State<MapUI> {
  TextEditingController queryplace = new TextEditingController(text: '');
  String apiKey = 'AIzaSyBa0THvu9jAa4yRrS6wyfRfOxR1Eusw-y0';
  String query = 'ตลาดต้นสัก สนามบินน้ำ นนทบุรี';
  List<dynamic> _places = [];
  List<String> descriptions = [];

  Future<String> getPlaceId() async {
    print("query : ${query}");
    String url =
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$query&inputtype=textquery&fields=place_id&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      String placeId = data['candidates'][0]['place_id'];
      print("place_id : $placeId");
      return placeId;
    } else {
      throw Exception('Failed to get place ID');
    }
  }

  Future<void> fetchPlaces(String input) async {
    final apiKey = "AIzaSyBa0THvu9jAa4yRrS6wyfRfOxR1Eusw-y0";
    final url = Uri.parse(
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&types=geocode&key=$apiKey");

    final response = await http.get(url);
    descriptions.clear();

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      setState(() {
        _places = decodedData['predictions'];
        for (var prediction in _places) {
          // Accessing each prediction's description
          String description = prediction['description'];
          descriptions.add(description);
          print(descriptions);
        }
      });
    } else {
      setState(() {
        _places = [];
      });
      throw Exception('Failed to load places');
    }
  }

  Future<Map<String, double>> getPlaceLatLng() async {
    try {
      String placeId = await getPlaceId();
      // เรียกใช้ getPlaceId() เพื่อรับ placeId
      String url =
          'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=geometry&key=$apiKey';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        Map<String, dynamic> location = data['result']['geometry']['location'];
        double lat = location['lat'];
        double lng = location['lng'];
        print("lat: ${lat}");
        return {'latitude': lat, 'longitude': lng};
      } else {
        throw Exception('Failed to get place details');
      }
    } catch (e) {
      throw Exception('Failed to get place details: $e');
    }
  }

  TextEditingController location = new TextEditingController(text: '');
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  static const keyapi =
      "AIzaSyA8i4wXHk5WLC5sUhb4pB70QylmaH9_qTU"; // Replace with your Google Maps API Key
  LatLng _center = LatLng(13.866509628739887, 100.48989832608599);
  LatLng _point1 = LatLng(13.866509628739887, 100.48989832608599);
  LatLng _point2 = LatLng(13.865301350742063, 100.48216111732361);

  @override
  void initState() {
    super.initState();
  }

  Future<Position> _getLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {});
        return Future.error("Permission denied");
      }
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _center = LatLng(position.latitude, position.longitude);
      _point1 = LatLng(position.latitude, position.longitude);
    });

    _onMapCreated();

    return position;
  }

  void _onMapCreated() {
    _markers.add(
      Marker(
        markerId: MarkerId("point1"),
        position: _point1,
        infoWindow: InfoWindow(
          title: 'จุดที่ 1',
        ),
      ),
    );
    // _markers.add(
    //   Marker(
    //     markerId: MarkerId("point2"),
    //     position: _point2,
    //     infoWindow: InfoWindow(
    //       title: 'จุดที่ 2',
    //     ),
    //   ),
    // );
  }

  Future<List<LatLng>> decodePolyline(String encoded) {
    List<LatLng> decoded = [];
    int index = 0;
    int len = encoded.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      double latitude = lat / 1E5;
      double longitude = lng / 1E5;
      decoded.add(LatLng(latitude, longitude));
    }

    return Future.value(decoded);
  }

  Future<void> _getPolyline() async {
    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${_point1.latitude},${_point1.longitude}&destination=${_point2.latitude},${_point2.longitude}&key=${keyapi}';

    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      List<LatLng> routeCoords = [];
      List<dynamic> routes = jsonData['routes'];
      for (var route in routes) {
        String points = route['overview_polyline']['points'];
        List<LatLng> decodedCoords = await decodePolyline(points);
        routeCoords.addAll(decodedCoords);
      }

      setState(() {
        _polylines.clear();
        _polylines.add(Polyline(
          polylineId: PolylineId("route1"),
          color: Colors.blue,
          width: 3,
          points: routeCoords,
        ));
      });
    } else {
      throw Exception('Failed to load polyline');
    }
  }

  void _goToCenter() async {
    if (_controller.isCompleted) {
      GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newLatLng(_center));
    } else {
      // Handle case when future hasn't completed yet
      print("Controller is not yet available");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              _onMapCreated();
              controller.animateCamera(CameraUpdate.newLatLng(_center));
            },
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 15.0,
            ),
            markers: _markers,
            polylines: _polylines,
          ),
          Visibility(
            visible: !(descriptions.length == 0),
            child: Positioned(
              top: MediaQuery.of(context).size.height * 0.09,
              left: MediaQuery.of(context).size.width * 0.06,
              right: MediaQuery.of(context).size.width * 0.06,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.6,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: descriptions.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            queryplace.text = "${descriptions[index]}";
                            print('You tapped on ${descriptions[index]}');
                            setState(() {
                              descriptions.clear();
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: ListTile(
                              title: Text(descriptions[index]),
                            ),
                          ),
                        );
                      },
                    )),
              ),
            ),
          ), //

          Padding(
            padding: const EdgeInsets.only(top: 50, left: 20, right: 75),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // สีของเงา
                    spreadRadius: 5, // การกระจายของเงา
                    blurRadius: 7, // ความเบลอของเงา
                    offset: Offset(0, 10), // ตำแหน่งของเงา
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.blueGrey.shade200, width: 1.0),
                      borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.blue.withOpacity(0.8), width: 2.0),
                      borderRadius: BorderRadius.circular(10)),
                ),
                onChanged: (value) {
                  setState(() {
                    fetchPlaces(value);
                  });
                  print(value);
                },
                controller: queryplace,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 58, left: 287),
            child: ElevatedButton(
              onPressed: () async {
                try {
                  query = "${queryplace.text}";
                  Map<String, double> placeLatLng = await getPlaceLatLng();
                  setState(() {
                    _point2 = LatLng(
                        placeLatLng['latitude']!, placeLatLng['longitude']!);
                    _markers.add(
                      Marker(
                        markerId: MarkerId("point2"),
                        position: _point2,
                        infoWindow: InfoWindow(
                          title: 'จุดที่ 2',
                        ),
                      ),
                    );
                    _center = LatLng(
                        placeLatLng['latitude']!, placeLatLng['longitude']!);
                    _goToCenter();
                    _getPolyline();
                  });
                } catch (e) {
                  print('Error: $e');
                }
              },
              child: Text(
                "GO!",
                style: GoogleFonts.kanit(color: Colors.black),
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shadowColor: Colors.black // เปลี่ยนสีพื้นหลังของปุ่ม
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
