import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/data/image_path.dart';
import 'package:weather_app/services/location_provider.dart';
import 'package:weather_app/services/weather_service_provider.dart';
import 'package:weather_app/util/appText.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    final locationprovider = Provider.of<LocationProvider>(
      context,
      listen: false,
    );
    locationprovider.determineLocation().then((_) {
      var city = locationprovider.currentLocationName!.locality;
      if (city != null) {
        Provider.of<WeatherServiceProvider>(
          context,
          listen: false,
        ).fetchWeatherDataByCity(city.toString());
      }
    });

    super.initState();
  }

  TextEditingController _cityController = new TextEditingController();

  @override
  void dispose() {
    _cityController.dispose();
    print("hi");
    super.dispose();
  }

  bool _isclicked = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final locationprovider = Provider.of<LocationProvider>(context);
    final weatherProvider = Provider.of<WeatherServiceProvider>(context);

    int sunriseTimestamp = weatherProvider.weather?.sys?.sunrise ?? 0;
    int sunsetTimestamp = weatherProvider.weather?.sys?.sunset ?? 0;
    int timezone = weatherProvider.weather?.timezone!.toInt() ?? 0;

    DateTime sunriseTime = DateTime.fromMillisecondsSinceEpoch(
      (sunriseTimestamp + timezone) * 1000,
      isUtc: true,
    );
    DateTime sunsetTime = DateTime.fromMillisecondsSinceEpoch(
      (sunsetTimestamp + timezone) * 1000,
      isUtc: true,
    );

    // Format as AM/PM
    String formattedSunrise = DateFormat.jm().format(sunriseTime);
    String formattedSunset = DateFormat.jm().format(sunsetTime);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 60, left: 20, right: 20),
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage(
                background[weatherProvider.weather?.weather![0].main ??
                        "N/A"] ??
                    "assets/images/clouds.jpg",
              ),
            ),
          ),
          child: Stack(
            children: [
              _isclicked
                  ? Positioned(
                      left: 20,
                      right: 20,
                      top: 50,
                      child: Container(
                        height: 50,
                        child: Row(
                          children: [
                            Container(
                              width: 300,
                              height: 70,
                              child: SizedBox(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: _cityController,
                                        decoration: InputDecoration(
                                          labelText: "City",
                                          labelStyle: TextStyle(
                                            color: Colors.white,
                                          ),
                                          //hintText: "Search a city",
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.white,
                                            ),
                                          ),

                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.search),
                                      onPressed: () {
                                        weatherProvider.fetchWeatherDataByCity(
                                          _cityController.text,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SizedBox(height: 10),
              Container(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Consumer<LocationProvider>(
                        builder: (context, LocationProvider, child) {
                          var locationCity;
                          if (locationprovider.currentLocationName != null) {
                            locationCity =
                                LocationProvider.currentLocationName!.locality;
                          } else {
                            locationCity = "Unknown City";
                          }

                          return Row(
                            children: [
                              Icon(Icons.location_pin, color: Colors.red),
                              SizedBox(width: 12),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AbsText(locationCity, color: Colors.white),
                                  AbsText(
                                    DateFormat.jm()
                                        .format(DateTime.now())
                                        .toString(),
                                    size: 12,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _isclicked = !_isclicked;
                        });
                      },
                      icon: Icon(Icons.search, color: Colors.white, size: 30),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment(0, -.60),
                child: Image.asset(
                  imagePath[weatherProvider.weather?.weather![0].main ??
                          "N/A"] ??
                      "assets/images/default.png",
                  height: 200,
                  width: 200,
                ),
              ),
              Align(
                alignment: Alignment(0, 0),
                child: Container(
                  //width: 130,
                  height: 150,
                  child: Column(
                    children: [
                      AbsText(
                        "${weatherProvider.weather?.main?.temp!.toStringAsFixed(0) ?? "--"}\u00B0C",
                        size: 32,
                        color: Colors.white,
                        fw: FontWeight.bold,
                      ),
                      AbsText(
                        weatherProvider.weather?.weather![0].main ?? "--",
                        size: 26,
                        color: Colors.white,
                        fw: FontWeight.w500,
                      ),

                      AbsText(
                        weatherProvider.weather?.name ?? "--",
                        size: 20,
                        color: Colors.white,
                        fw: FontWeight.w500,
                      ),
                      AbsText(
                        DateFormat.jm().format(DateTime.now()).toString() ??
                            "--",
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment(0, .70),
                child: Container(
                  height: 150,
                  //width: 150,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(0, 0, 0, 0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                "assets/images/maxtemp.svg",
                                height: 40,
                                width: 40,
                              ),
                              // Icon(
                              //   Icons.thermostat,
                              //   color: const Color.fromARGB(255, 238, 41, 27),
                              //   size: 35,
                              // ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AbsText(
                                    "Max Temp",
                                    color: Colors.white,
                                    fw: FontWeight.w500,
                                  ),
                                  AbsText(
                                    "${weatherProvider.weather?.main!.tempMax!.toStringAsFixed(0) ?? "--"}\u00B0C",
                                    color: Colors.white,
                                    fw: FontWeight.w500,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(width: 30),
                          Row(
                            children: [
                              SvgPicture.asset(
                                "assets/images/mintemp.svg",
                                height: 40,
                                width: 40,
                              ),
                              // Icon(
                              //   Icons.thermostat,
                              //   color: const Color.fromARGB(255, 79, 176, 255),
                              //   size: 35,
                              // ),
                              Column(
                                //mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AbsText(
                                    "Min Temp",
                                    color: Colors.white,
                                    fw: FontWeight.w500,
                                  ),
                                  AbsText(
                                    "${weatherProvider.weather?.main!.tempMin!.toStringAsFixed(0) ?? "--"}\u00B0C",
                                    color: Colors.white,
                                    fw: FontWeight.w500,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment(0, 0.50),
                        child: Divider(
                          color: Colors.blueGrey,
                          thickness: 5,
                          indent: 50,
                          endIndent: 50,
                        ),
                      ),
                      Align(
                        alignment: Alignment(0, .5),
                        child: Container(
                          height: 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            //crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.sunny,
                                    color: Colors.orange,
                                    size: 35,
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AbsText(
                                        "Sun Rise",
                                        color: Colors.white,
                                        fw: FontWeight.w500,
                                      ),
                                      AbsText(
                                        formattedSunrise,
                                        color: Colors.white,
                                        fw: FontWeight.w500,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(width: 30),
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/images/moon.png",
                                    height: 50,
                                    width: 50,
                                  ),
                                  // Icon(
                                  //   Icons.cloud,
                                  //   color: const Color.fromARGB(
                                  //     255,
                                  //     77,
                                  //     89,
                                  //     255,
                                  //   ),
                                  //   size: 35,
                                  // ),
                                  SizedBox(width: 10),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AbsText(
                                        "Sun Set",
                                        color: Colors.white,
                                        fw: FontWeight.w500,
                                      ),
                                      AbsText(
                                        formattedSunset,
                                        color: Colors.white,
                                        fw: FontWeight.w500,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
