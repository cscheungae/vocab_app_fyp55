import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vocab_app_fyp55/components/Chip/MultiSelectChip.dart';
import 'package:vocab_app_fyp55/components/Chip/styles.dart';
import 'package:vocab_app_fyp55/components/RegisterForm.dart';
import 'package:vocab_app_fyp55/model/user.dart';
import 'package:vocab_app_fyp55/services/AddressMiddleWare.dart';
import 'package:vocab_app_fyp55/state/DatabaseNotifier.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final int _numPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<String> GenresList = [
    "business",
    "entertainment",
    "general",
    "health",
    "science",
    "sports",
    "technology"
  ];
  List<DropdownMenuItem<String>>  langList = [
    DropdownMenuItem(
      value: "gb",
      child: Text("British", style: TextStyle(color: Colors.white70),),
    ),
    DropdownMenuItem(
      value: "us",
      child: Text("United States", style: TextStyle(color: Colors.white70),),
    )
  ];

  // states
  List<String> selectedGenresList = List();
  String selectedLang = "gb";
  double trackThres = 3;
  double zipfThres = 4;


  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.green : Colors.black38,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Get Started", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Colors.white),), centerTitle: true, backgroundColor: Colors.black87,),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(
                  flex: 18,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          child: PageView(
                            physics: ClampingScrollPhysics(),
                            controller: _pageController,
                            onPageChanged: (int page) {
                              setState(() {
                                _currentPage = page;
                              });
                            },
                            children: <Widget>[
                              SingleChildScrollView(
                                child: Padding(
                                  padding: EdgeInsets.all(25),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Center(
                                        child: Image(
                                          image: AssetImage(
                                            'assets/images/news.png',
                                          ),
                                          height: 150.0,
                                          width: 150.0,
                                        ),
                                      ),
                                      SizedBox(height: 30.0),
                                      Text(
                                        'Article Categories',
                                        style: kTitleStyle,
                                      ),
                                      SizedBox(height: 5.0),
                                      Text(
                                        'Readings will be fetched from the internet based on your preference for you.',
                                        style: kSubtitleStyle,
                                      ),
                                      SizedBox(height: 20.0),
                                      MultiSelectChip(
                                        GenresList,
                                        onSelectionChanged: (selectedList) {
                                          setState(() {
                                            selectedGenresList = selectedList;
                                          });
                                        },
                                      ),
                                      SizedBox(height: 25.0),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text("Language", style: TextStyle(fontSize: 18, color: Colors.white70),),
                                          DropdownButton(
                                            style: TextStyle(color: Colors.white70),
                                            hint: Text(
                                              "Select Language",
                                              style: TextStyle(color: Colors.white70),
                                            ),
                                            value: selectedLang,
                                            items: langList,
                                            onChanged: (String lang) {
                                              setState(() {
                                                selectedLang = lang;
                                              });
                                            },
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SingleChildScrollView(
                                child: Padding(
                                  padding: EdgeInsets.all(25.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Center(
                                        child: Image(
                                          image: AssetImage(
                                            'assets/images/onboarding1.png',
                                          ),
                                          height: 150.0,
                                          width: 150.0,
                                        ),
                                      ),
                                      SizedBox(height: 30.0),
                                      Text(
                                        'Threshold',
                                        style: kTitleStyle,
                                      ),
                                      SizedBox(height: 15.0),
                                      Text(
                                        'Tracked word will be prepared as Flashcard when its tracked frequency exceeds user-defined threshold or its zipfs value are lower than the user-specied one',
                                        style: kSubtitleStyle,
                                      ),
                                      SizedBox(height: 25.0),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text("Track \nFrequency", style: TextStyle(fontSize: 18),),
                                          Slider(
                                            activeColor: Colors.green,
                                            min: 1,
                                            max: 5,
                                            value: trackThres,
                                            divisions: 4,
                                            onChanged: (newThreshold) {
                                              setState(() => trackThres = newThreshold);
                                            },
                                            label: "${trackThres.toInt()}",
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 15.0),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text("Zipf", style: TextStyle(fontSize: 18),),
                                          GestureDetector(
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (_) => AlertDialog(
                                                    title: Text("Zipfs"),
                                                    content: SingleChildScrollView(
                                                      child: Container(
                                                        child: Column(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: <Widget>[
                                                            Text("Each word has it own zipf value. Words with the highest value 7 are common words, the lowest value 1 are rare"),
                                                            DataTable(
                                                              columns: [
                                                                DataColumn(label: Text("Zipf")),
                                                                DataColumn(label: Text("Examples"))
                                                              ],
                                                              rows: [
                                                                DataRow(cells: [
                                                                  DataCell(Text("1")),
                                                                  DataCell(Text("antifungal"))
                                                                ]),
                                                                DataRow(cells: [
                                                                  DataCell(Text("2")),
                                                                  DataCell(Text("doorkeeper"))
                                                                ]),
                                                                DataRow(cells: [
                                                                  DataCell(Text("3")),
                                                                  DataCell(Text("beanstalk"))
                                                                ]),
                                                                DataRow(cells: [
                                                                  DataCell(Text("4")),
                                                                  DataCell(Text("offensive")                                                              )
                                                                ]),
                                                                DataRow(cells: [
                                                                  DataCell(Text("5")),
                                                                  DataCell(Text("basically"))
                                                                ]),
                                                                DataRow(cells: [
                                                                  DataCell(Text("6")),
                                                                  DataCell(Text("great"))
                                                                ]),
                                                                DataRow(cells: [
                                                                  DataCell(Text("7")),
                                                                  DataCell(Text("you"))
                                                                ]),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  barrierDismissible: true,
                                                );
                                              },
                                              child: Icon(Icons.info_outline)
                                          ),
                                          Slider(
                                            activeColor: Colors.green,
                                            min: 1,
                                            max: 7,
                                            value: zipfThres,
                                            divisions: 6,
                                            onChanged: (newThreshold) {
                                              setState(() => zipfThres = newThreshold);
                                            },
                                            label: "${zipfThres.toInt()}",
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(25.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Center(
                                      child: Image(
                                        image: AssetImage(
                                          'assets/images/onboarding2.png',
                                        ),
                                        height: 150.0,
                                        width: 150.0,
                                      ),
                                    ),
                                    SizedBox(height: 30.0),
                                    Text(
                                      'Let\'s get started',
                                      style: kTitleStyle,
                                    ),
                                    SizedBox(height: 15.0),
                                    Text(
                                      'Lorem ipsum dolor sit amet, consect adipiscing elit, sed do eiusmod tempor incididunt ut labore et.',
                                      style: kSubtitleStyle,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _currentPage != _numPages - 1
                    ? Expanded(
                  child: Align(
                    alignment: FractionalOffset.bottomRight,
                    child: FlatButton(
                      onPressed: () {
                        _pageController.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.ease,
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'Next',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 22.0,
                            ),
                          ),
                          SizedBox(width: 10.0),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.black,
                            size: 30.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                    : Text(''),
                Flexible(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _buildPageIndicator(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: _currentPage == _numPages - 1
          ? Container(
        height: 50.0,
        width: double.infinity,
        color: Colors.green,
        child: GestureDetector(
          child: Center(
            child: FlatButton(
              onPressed: () async {
                Toast.show("Processing ...", context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM, backgroundColor: Colors.white70);
                try {
                  // update to the local storage
                  final dbHelper = Provider.of<DatabaseNotifier>(context, listen: false).dbHelper;
                  // read the user
                  List<User> users = await dbHelper.readAllUser();
                  // get the userid
                  User user = users[0];
                  // update the user
                  user.setTrackThres(trackThres.toInt());
                  user.setWordFreqThres(zipfThres.toInt());
                  user.setRegion(selectedLang);
                  user.setGenres(selectedGenresList.isNotEmpty ? selectedGenresList : GenresList);
                  // by using the userid, update the preference
                  await dbHelper.updateUser(user);
                  // update to the server
                  Map<String, String> headers = {
                    'Content-type': 'application/json'
                  };
                  http.Response response = await http.post(
                      AddressMiddleWare.address + "/user/update",
                      headers: headers,
                      body: jsonEncode({
                        "uid": user.uid,
                        "password": user.password,
                        "preference": jsonEncode({
                          "trackThres": user.trackThres,
                          "wordFreqThres": user.wordFreqThres,
                          "region": selectedLang,
                          "genres": selectedGenresList.isNotEmpty ? selectedGenresList : GenresList,
                        })
                      })
                  );
                  if(response.statusCode == 200) {
                    Toast.show("Success", context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM, backgroundColor: Colors.green);
                    Navigator.pushReplacementNamed(context, '/');
                  } else {
                    throw new Exception(response.body);
                  }
                } on Exception catch(err) {
                  print("Store User to SQLite/ server Error: $err");
                  Toast.show("Error: ${err.toString()}", context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM, backgroundColor: Colors.red);
                }
              },
              child: Text(
                'Start',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
      )
          : Text(''),
    );
  }
}
