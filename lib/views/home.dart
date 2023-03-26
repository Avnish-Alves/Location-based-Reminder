


import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show  rootBundle;

import '../controller/auth_controller.dart';




class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GoogleMapController? googleMapController;
  static const CameraPosition _initialCameraPosition = CameraPosition(
      target: LatLng(19.99159198514629, 72.74366205572922),
      zoom : 14.4746);

  Set<Marker> markers = {};

  String? _mapStyle;

  AuthController authController = Get.find<AuthController>();

  late LatLng destination;
  late LatLng source;
  final Set<Polyline> _polyline = {};

  List<String> list = <String>[
    '**** **** **** 8789',
    '**** **** **** 8921',
    '**** **** **** 1233',
    '**** **** **** 4352'
  ];







  @override
  void initState() {
    super.initState();




    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });

  }







  GoogleMapController? myMapController;





  @override
  Widget build(BuildContext context){


    return Scaffold(
      body: Stack(
        children: [
          Center(

            child: GoogleMap(initialCameraPosition: _initialCameraPosition,
              markers: markers,
              zoomControlsEnabled: false,
              onMapCreated: (GoogleMapController controller){


                myMapController = controller;
                myMapController!.setMapStyle(_mapStyle);


              },
            ),
          ),
          buildProfileTile(),
          buildTextFieldSource(),
          buildTextFieldForSource(),

          buildBottomSheet(),
          buildNotificationIcon(),
        ],
      ),
      floatingActionButton:buildCurrentLocationIcon(

      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Future<Position> _determinePosition() async  {

    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if(!serviceEnabled){
      return throw(Exception('Location services are disabled'));
    }

    permission = await Geolocator.checkPermission();

    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();

      if(permission == LocationPermission.denied){
        return throw("Location permission denied");
      }
    }

    if(permission == LocationPermission.deniedForever){
      return throw('Location permissions are permanently denied');
    }

    Position position = await Geolocator.getCurrentPosition();
    return position;



  }

  Widget buildProfileTile(){
    return Positioned(
      top:0,
      left: 0,
      right: 0,
        child: Container(
          width: Get.width,
          height: Get.width*0.5,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(color: Colors.white10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/person.png'),
                    fit: BoxFit.fill
                  ),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: 'Where would you like',
                          style:
                          TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 18)),
                    ]),
                  ),
                  Text(
                    "  to set your Task?",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )
                ],
              )
            ],
          ),
        )
    );
  }

  TextEditingController sourceController = TextEditingController();

  Widget buildTextFieldSource() {
    return Positioned(
      top: 170,
      left: 20,
      right: 20,
      child: Container(
        width: Get.width,
        height: 50,
        padding: EdgeInsets.only(left: 15),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 4,
                  blurRadius: 10)
            ],
            borderRadius: BorderRadius.circular(8)),
        child: TextFormField(
          onTap: () async {



          },
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            hintText: 'Enter Your Tasks:',
            hintStyle: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Icon(
                Icons.search,
              ),
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget buildTextFieldForSource() {
    return Positioned(
      top: 230,
      left: 20,
      right: 20,
      child: Container(
        width: Get.width,
        height: 50,
        padding: EdgeInsets.only(left: 15),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 4,
                  blurRadius: 10)
            ],
            borderRadius: BorderRadius.circular(8)),
        child: TextFormField(
          controller: sourceController,
          readOnly: true,
          onTap: () async {

            Get.bottomSheet(Container(
              width: Get.width,
              height: Get.height*0.5,
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(8),topRight: Radius.circular(8)),
                    color: Colors.white
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  
                  const SizedBox(
                    height: 10,
                  ),
                  Text("Select Your Location",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),

                  const SizedBox(
                    height: 20,
                  ),
                  Text("Home Address",style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
              const SizedBox(
                height: 10,
              ),
                  Container(
                    width: Get.width,
                    height: 50,
                    padding:  EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow:[
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          spreadRadius: 4,
                          blurRadius: 10
                        )
                      ]
                    ),
                    child: Row(
                      children: [
                        Text("Dahanu",style: TextStyle(color: Colors.black,fontSize: 12,fontWeight: FontWeight.w600),),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text("Work/School Address",style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: Get.width,
                    height: 50,
                    padding:  EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow:[
                          BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              spreadRadius: 4,
                              blurRadius: 10
                          )
                        ]
                    ),
                    child: Row(
                      children: [
                        Text("Palghar",style: TextStyle(color: Colors.black,fontSize: 12,fontWeight: FontWeight.w600),),
                      ],
                    ),
                  )
                ],
              ),
            ));

          },
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            hintText: 'Choose your Location:',
            hintStyle: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Icon(
                Icons.search,
              ),
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }






  Widget buildCurrentLocationIcon() => SizedBox.fromSize(
    size: Size.square(45),
    child: FloatingActionButton(

      child:
      Icon(Icons.my_location),
      backgroundColor: Colors.blueGrey,


      onPressed: ()async{

        Position position = await _determinePosition();

        myMapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(position.latitude, position.longitude),zoom: 14)));


        markers.clear();

        markers.add(Marker(markerId: const MarkerId('currentLocation'),position: LatLng(position.latitude, position.longitude)));

        setState(() {

        });

      },

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(50))
      ),

    ),
  );













  Widget buildNotificationIcon() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 30, left: 8),
        child: CircleAvatar(
          radius: 20,
          backgroundColor: Colors.white,
          child: Icon(
            Icons.notifications,
            color: Color(0xffC3CDD6),
          ),
        ),
      ),
    );
  }

  Widget buildBottomSheet() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: Get.width * 0.7,
        height: 24,
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 4,
                  blurRadius: 10)
            ],
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(12), topLeft: Radius.circular(12))),
        child: Center(
          child: Container(
            width: Get.width * 0.6,
            height: 4,
            color: Colors.black45,
          ),
        ),
      ),
    );
  }




}

