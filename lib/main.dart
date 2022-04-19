//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dataModel.dart';
import 'createPage.dart';
import 'locale/language.dart';
import 'locale/app_localizations_delegate.dart';

SharedPreferences? prefs;

Future<void> main() async {
  prefs = await SharedPreferences.getInstance();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        const AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: [
        const Locale('en'),
        const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant', countryCode: 'TW')
      ],
      onGenerateTitle: (context) => Language.of(context).appTitle,
      debugShowCheckedModeBanner: false,
//      title: 'Golfer Group',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Colors.blue,
//        accentColor: Colors.white,
          visualDensity: VisualDensity.adaptivePlatformDensity),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

enum gendre { Male, Female }
final String maleGolfer = 'https://images.unsplash.com/photo-1494249120761-ea1225b46c05?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=713&q=80';
final String femaleGolfer = 'https://images.unsplash.com/photo-1622819219010-7721328f050b?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=415&q=80';
String? _golferAvatar;

class _MyHomePageState extends State<MyHomePage> {
  int _currentPageIndex = 0;
  int _golferID = 0, _gID = 1;
  String _name = '', _phone = '';
  gendre _sex = gendre.Male;
  double _handicap = 18;
  bool isRegistered = false, isUpdate = false;
  var _golferDoc;
//  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    _golferID = prefs!.getInt('golferID') ?? 0;
    FirebaseFirestore.instance.collection('Golfers')
      .where('uid', isEqualTo: _golferID)
      .get().then((value) {
        value.docs.forEach((result) {
          _golferDoc = result.id;
          var items = result.data();
          _name = items['name'];
          _phone = items['phone'];
          _sex = items['sex'] == 1 ? gendre.Male : gendre.Female;
          setState(() => isRegistered = true);
          _currentPageIndex = 1;
        });
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> appTitle = [
      Language.of(context).golferInfo,
      Language.of(context).groups, //"Groups",
      Language.of(context).activities, //"Activities",
      Language.of(context).golfCourses, //"Golf courses",
      Language.of(context).myScores, //"My Scores",
      Language.of(context).groupActivity //"Group Activities"
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle[_currentPageIndex]),
      ),
      body: Center(
          child: _currentPageIndex == 0 ? registerBody()
               : _currentPageIndex == 1 ? groupBody()
               : _currentPageIndex == 2 ? activityBody()
               : _currentPageIndex == 3 ? golfCourseBody()
               : _currentPageIndex == 4 ? myScoreBody()
               : _currentPageIndex == 5 ? groupActivityBody(_gID): null
      ),
      drawer: isRegistered ? golfDrawer() : null,
      floatingActionButton: (_currentPageIndex > 0 && _currentPageIndex < 4) || (_currentPageIndex == 5)
          ? FloatingActionButton(
              //mini: false,
              onPressed: () => doBodyAdd(_currentPageIndex),
              child: const Icon(Icons.add),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Drawer golfDrawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(_name),
            accountEmail: Text(_phone),
            currentAccountPicture: GestureDetector(
                onTap: () {
                  setState(() => isUpdate = true);
                  _currentPageIndex = 0;
                  Navigator.of(context).pop();
                },
                child: CircleAvatar(backgroundImage: NetworkImage(_golferAvatar ?? maleGolfer))),
            decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.fill, image: NetworkImage("https://images.unsplash.com/photo-1622482594949-a2ea0c800edd?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=774&q=80"))),
            onDetailsPressed: () {
              setState(() => isUpdate = true);
              _currentPageIndex = 0;
              Navigator.of(context).pop();
            },
          ),
          ListTile(
              title: Text(Language.of(context).groups),
              leading: Icon(Icons.group),
              onTap: () {
                setState(() => _currentPageIndex = 1);
                Navigator.of(context).pop();
              }),
          ListTile(
              title: Text(Language.of(context).activities),
              leading: Icon(Icons.sports_golf),
              onTap: () {
                setState(() => _currentPageIndex = 2);
                Navigator.of(context).pop();
              }),
          ListTile(
              title: Text(Language.of(context).golfCourses),
              leading: Icon(Icons.golf_course),
              onTap: () {
                setState(() => _currentPageIndex = 3);
                Navigator.of(context).pop();
              }),
          ListTile(
              title: Text(Language.of(context).myScores),
              leading: Icon(Icons.format_list_numbered),
              onTap: () {
                setState(() => _currentPageIndex = 4);
                Navigator.of(context).pop();
              }),
          ListTile(
              title: Text(Language.of(context).logOut),
              leading: Icon(Icons.exit_to_app),
              onTap: () {
                setState(() {
                  isRegistered = isUpdate = false;
                  _name = '';
                  _phone = '';
                  _golferID = 0;
                });
                _currentPageIndex = 0;
                Navigator.of(context).pop();
              }),
        ],
      ),
    );
  }

  ListView registerBody() {
    final logo = Hero(
      tag: 'golfer',
      child: CircleAvatar(backgroundImage: NetworkImage(_golferAvatar ?? maleGolfer), radius: 140),
    );
//    final logo2 = Image.file(path:

    final golferName = TextFormField(
      initialValue: _name,
//      key: Key(_name),
      showCursor: true,
      onChanged: (String value) => setState(() => _name = value),
      //keyboardType: TextInputType.name,
      decoration: InputDecoration(labelText: Language.of(context).name, hintText: 'Real Name:', icon: Icon(Icons.person), border: UnderlineInputBorder()),
    );

    final golferPhone = TextFormField(
      initialValue: _phone,
//      key: Key(_phone),
      onChanged: (String value) => setState(() => _phone = value),
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(labelText: Language.of(context).mobile, icon: Icon(Icons.phone), border: UnderlineInputBorder()),
    );
    final golferSex = Row(children: <Widget>[
      Flexible(
          child: RadioListTile<gendre>(
              title: Text(Language.of(context).male),
              value: gendre.Male,
              groupValue: _sex,
              onChanged: (gendre? value) => setState(() {
                    _sex = value!;
                    _golferAvatar = maleGolfer;
                  }))),
      Flexible(
          child: RadioListTile<gendre>(
              title: Text(Language.of(context).female),
              value: gendre.Female,
              groupValue: _sex,
              onChanged: (gendre? value) => setState(() {
                    _sex = value!;
                    _golferAvatar = femaleGolfer;
                  }))),
    ], mainAxisAlignment: MainAxisAlignment.center);
    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        shadowColor: Colors.lightBlueAccent.shade100,
        elevation: 5.0,
        child: MaterialButton(
            minWidth: 200.0,
            height: 45.0,
            color: Colors.green,
            child: Text(
              isUpdate ? Language.of(context).modify : Language.of(context).register,
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            ),
            onPressed: () {
              if (isUpdate) {
                  if (_name != '' && _phone != '') {
                    FirebaseFirestore.instance.collection('Golfers').doc(_golferDoc).update({
                      "name": _name,
                      "phone": _phone,
                      "sex": _sex == gendre.Male ? 1 : 2,
                    });
                    _currentPageIndex = 1;
                    setState(() => isUpdate = false);
                  }
                } else {
                  if (_name != '' && _phone != '') {
                    FirebaseFirestore.instance.collection('Golfers')
                    .where('name', isEqualTo: _name)
                    .where('phone', isEqualTo: _phone).get().then((value) {
                      value.docs.forEach((result) {
                        var items = result.data();
                        _golferDoc = result.id;
                        _golferID = items['uid'];
                        _sex = items['sex'] == 1 ? gendre.Male : gendre.Female;
                        print(_name + '(' + _phone + ') already registered! ($_golferID)');
                      });
                    }).whenComplete(() {
                      if (_golferID == 0) {
                        _golferID = uuidTime();

                        FirebaseFirestore.instance.collection('Golfers').add({
                          "name": _name,
                          "phone": _phone,
                          "sex": _sex == gendre.Male ? 1 : 2,
                          "uid": _golferID
                        });
                      }
                      prefs!.setInt('golferID', _golferID);
                      _currentPageIndex = 1;
                      setState(() => isRegistered = true);
                    });
                  }
                }
            }),
      ),
    );
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.only(left: 24.0, right: 24.0),
      children: <Widget>[
        SizedBox(
          height: 8.0,
        ),
        logo,
        SizedBox(
          height: 24.0,
        ),
        SizedBox(
          height: 24.0,
        ),
        golferName,
        SizedBox(
          height: 8.0,
        ),
        golferPhone,
        SizedBox(
          height: 8.0,
        ),
        golferSex,
        SizedBox(
          height: 8.0,
        ),
        Text(isRegistered ? Language.of(context).handicap + ": $_handicap" : '', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(
          height: 10.0,
        ),
        loginButton
      ],
    );
  }

  Future<bool?> showApplyDialog(bool applying) {
    return showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Hint"),
            content: Text(applying ? 'You have applied already, wait for it.' : 'You should apply the group first'),
            actions: <Widget>[
              TextButton(child: Text(applying ? "OK" : "Apply"), onPressed: () => Navigator.of(context).pop(!applying)),
              TextButton(child: Text("Cancel"), onPressed: () => Navigator.of(context).pop(false))
            ],
          );
        });
  }

  Future<bool?> grantApplyDialog(String name) {
    return showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Reply"),
            content: Text(name + ' is applying this group!'),
            actions: <Widget>[
              TextButton(child: Text("OK"), onPressed: () => Navigator.of(context).pop(true)),
              TextButton(child: Text("Reject"), onPressed: () => Navigator.of(context).pop(false))
            ],
          );
        });
  }

  Widget? groupBody() {

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('GolferClubs').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        } else {
          return ListView(
            children: snapshot.data!.docs.map((doc) {
            if ((doc.data()! as Map)["Name"] == null) {
              return const LinearProgressIndicator();
            } else {
//              Future<String> managers = golferNames((doc.data()! as Map)["managers"] as List)!;
              return Card(child: ListTile(
                title: Text((doc.data()! as Map)["Name"], style: TextStyle(fontSize: 20)),
                subtitle: Text(Language.of(context).region + (doc.data()! as Map)["region"] + "\n" + 
//                Language.of(context).manager + (managers as String) + "\n" + 
                Language.of(context).members + ((doc.data() as Map)["members"] as List<dynamic>).length.toString()),
                leading: Image.network("https://www.csu-emba.com/img/port/22/10.jpg"), /*Icon(Icons.group), */
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () async {
                  _gID = (doc.data()! as Map)["gid"] as int;
                  if (await isMember(_gID, _golferID)) {
                    FirebaseFirestore.instance.collection('ApplyQueue')
                      .where('uid', isEqualTo: _golferID)
                      .where('gid', isEqualTo: _gID).get().then((value) {
                        value.docs.forEach((result) =>
                          FirebaseFirestore.instance.collection('ApplyQueue').doc(result.id).delete()
                        );
                      });  
                    setState(() => _currentPageIndex = 5);
                  } else {
                    bool? apply = await showApplyDialog((await isApplying(_gID, _golferID)) == 1);
                    if (apply!) {
                      // fill the apply waiting queue
                      FirebaseFirestore.instance.collection('ApplyQueue').add({
                        "uid": _golferID,
                        "gid": _gID,
                        "response": "waiting"
                      });
                    }
                  }
                },
              ));
            }
            }).toList(),
          );
        }
      });
  }

  Widget? groupActivityBody(int gID) {
    DateTime today = DateTime.now();
    Timestamp deadline = Timestamp.fromDate(DateTime(today.year, today.month, today.day));
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('ClubActivities').where('gid', isEqualTo: gID).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        } else {
          return ListView(
            children: snapshot.data!.docs.map((doc) {
              if ((doc.data()! as Map)["teeOff"] == null || (doc.data()! as Map)["teeOff"].compareTo(deadline) < 0 ) {
                return LinearProgressIndicator();
              } else {
              return Card(child: ListTile(
                title: FutureBuilder(
                  future: courseName((doc.data()! as Map)['cid'] as int),
                  builder: (context, snapshot2) {
                    if (!snapshot2.hasData)
                      return const LinearProgressIndicator();
                    else
                      return Text(snapshot2.data!.toString(), style: TextStyle(fontSize: 20));
                  }),
                subtitle: Text(Language.of(context).teeOff + (doc.data()! as Map)['teeOff']!.toDate().toString().substring(0, 16) + '\n' +
                  Language.of(context).max + (doc.data()! as Map)['max'].toString() + '\t' + 
                  Language.of(context).now + ((doc.data()! as Map)['golfers'] as List<dynamic>).length.toString() + "\t" + 
                  Language.of(context).fee + (doc.data()! as Map)['fee'].toString()),
                leading: FutureBuilder(
                  future: coursePhoto((doc.data()! as Map)['cid'] as int),
                  builder: (context, snapshot3) {
                    if (!snapshot3.hasData)
                      return const CircularProgressIndicator();
                    else
                      return Image.network(snapshot3.data!.toString());
                  }),                
/*                Image.network(coursePhoto((doc.data()! as Map)["cid"] as int)!),*/
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () async {
                  Navigator.push(context, showActivityPage(doc, _golferID, await groupName(gID)!, await isManager(gID, _golferID)))
                  .then((value) async {
                    var glist = doc.get('golfers');
                    var name = await golferName(_golferID);
                    if (value == 1) {
                      glist.add({
                        'uid': _golferID,
                        'name': name,
                        'appTime': Timestamp.now(),
                        'scores': []
                      });
                      FirebaseFirestore.instance.collection('ClubActivities').doc(doc.id).update({'golfers': glist});
                    } else if (value == -1) {
                      glist.removeWhere((item) => item['uid'] == _golferID);
                      FirebaseFirestore.instance.collection('ClubActivities').doc(doc.id).update({'golfers': glist});
                    }                    
                  });
                }
              ));}                
            }).toList()
          );
        }
      }
    );
  }

  Widget activityBody() {
    Timestamp deadline = Timestamp.fromDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day));
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('GolferActivities').where('teeOff', isGreaterThan: deadline).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        } else {         
          return ListView(
            children: snapshot.data!.docs.map((doc) {
              if ((doc.data()! as Map)["teeOff"] == null) {
                return LinearProgressIndicator();
              } else {
              return Card(child: ListTile(
                title: FutureBuilder(
                  future: courseName((doc.data()! as Map)['cid'] as int),
                  builder: (context, snapshot2) {
                    if (!snapshot2.hasData)
                      return const LinearProgressIndicator();
                    else
                      return Text(snapshot2.data!.toString(), style: TextStyle(fontSize: 20));
                  }),
                subtitle: Text(Language.of(context).teeOff + ((doc.data()! as Map)['teeOff']).toDate().toString().substring(0, 16) + '\n' +
                  Language.of(context).max + (doc.data()! as Map)['max'].toString() + '\t' + 
                  Language.of(context).now + ((doc.data()! as Map)['golfers'] as List).length.toString() + "\t" + 
                  Language.of(context).fee + (doc.data()! as Map)['fee'].toString()),
                leading: FutureBuilder(
                  future: coursePhoto((doc.data()! as Map)['cid'] as int),
                  builder: (context, snapshot3) {
                    if (!snapshot3.hasData)
                      return const CircularProgressIndicator();
                    else
                      return Image.network(snapshot3.data!.toString(), fit: BoxFit.fitHeight);
                  }),
                /*Image.network(coursePhoto((doc.data()! as Map)["cid"] as int)!),*/
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () async {  
                  Navigator.push(context, showActivityPage(doc, _golferID, await golferName((doc.data()! as Map)['uid'] as int)!, _golferID == (doc.data()! as Map)['uid'] as int))
                  .then((value) async {
                    var glist = doc.get('golfers');
                    var name = await golferName(_golferID);
                    if (value == 1) {
                      glist.add({
                        'uid': _golferID,
                        'name': name,
                        'appTime': Timestamp.now(),
                        'scores': []
                      });
                      FirebaseFirestore.instance.collection('GolferActivities').doc(doc.id).update({'golfers': glist});
                    } else if (value == -1) {
                      glist.removeWhere((item) => item['uid'] == _golferID);
                      FirebaseFirestore.instance.collection('GolferActivities').doc(doc.id).update({'golfers': glist});
                    }
                  });
                }
              )); 
              }               
            }).toList()
          );
        }
      }
    );

  }

  Widget? golfCourseBody() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('GolfCourses').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        } else {         
          return ListView(
            children: snapshot.data!.docs.map((doc) {
              if ((doc.data()! as Map)["photo"] == null) {
                return LinearProgressIndicator();
              } else {
              return Card(child: ListTile(
                leading: Image.network((doc.data()! as Map)["photo"]),
                title: Text((doc.data()! as Map)["region"] + ' ' + (doc.data()! as Map)["name"], style: TextStyle(fontSize: 20)),
                subtitle: Text((((doc.data()! as Map)["zones"]).length * 9).toString() + ' Holes'), 
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () {
                  bool? _zone0 = true, _zone1 = true, _zone2 = false, _zone3 = false;
                  if (((doc.data()! as Map)["zones"]).length > 2) {
                    showDialog(context: context, builder: (context) {return  StatefulBuilder(
                      builder: (context, setState) {
                        return AlertDialog(
                          title: const Text('Select 2 courses'),
                          actions: [
                            CheckboxListTile(value: _zone0, title: Text((doc.data()! as Map)["zones"][0]['name']), onChanged: (bool? value) {setState(() => _zone0 = value);}),
                            CheckboxListTile(value: _zone1, title: Text((doc.data()! as Map)["zones"][1]['name']), onChanged: (bool? value) {setState(() => _zone1 = value);}),
                            CheckboxListTile(value: _zone2, title: Text((doc.data()! as Map)["zones"][2]['name']), onChanged: (bool? value) {setState(() => _zone2 = value);}),
                            ((doc.data()! as Map)["zones"]).length == 3 ? SizedBox(height: 6) :
                            CheckboxListTile(value: _zone3, title: Text((doc.data()! as Map)["zones"][3]['name']), onChanged: (bool? value) {setState(() => _zone3 = value);}),
                            Row(children: [
                            TextButton(child: Text("OK"), onPressed: () => Navigator.of(context).pop(true)),
                            TextButton(child: Text("Cancel"), onPressed: () => Navigator.of(context).pop(false))])
                          ],
                        );
                      }
                    );}
                    ).then((value) {
                      int zone0, zone1;
                      zone0 = _zone0! ? 0 : _zone1! ? 1 : 2;
                      zone1 = _zone3! ? 3 : _zone2! ? 2 : 1;
                      if (value) Navigator.push(context, newScorePage(doc, _name, zone0: zone0, zone1: zone1));
                    });
                  }
                  else
                    Navigator.push(context, newScorePage(doc, _name));
                },
              ));}
            }).toList()
          );
        }
      }
    );
  }

  ListView myScoreBody() {
    loadMyActivities();
    if (myActivities != null)
    (myActivities as List).forEach((element) {
      
    });
    return ListView();
  }

  void doBodyAdd(int index) async {
    switch (index) {
      case 1:
        Navigator.push(context, newGroupPage(_golferID)).then((ret) {
          if (ret ?? false) setState(() => index = 1);
        });
        break;
      case 2:
        Navigator.push(context, newActivityPage(false, _golferID, _golferID)).then((ret) {
          if (ret ?? false) setState(() => index = 2);
        });
        break;
      case 3:
        Navigator.push(context, newGolfCoursePage()).then((ret) {
          if (ret ?? false) setState(() => index = 3);
        });
        break;
      case 5:
        if (await isManager(_gID, _golferID))  {
          FirebaseFirestore.instance.collection('ApplyQueue')
            .where('gid', isEqualTo: _gID)
            .where('response', isEqualTo: 'waiting').get().then((value) {
              value.docs.forEach((result) async {
                // grant or refuse the apply of e['uid']
                var e = result.data();
                bool? ans = await grantApplyDialog(await golferName(e['uid'] as int)!);
                if (ans!) {
                  FirebaseFirestore.instance.collection('ApplyQueue').doc(result.id).update({'response': 'OK'});
                  addMember(_gID, e['uid'] as int);
                } else
                  FirebaseFirestore.instance.collection('ApplyQueue').doc(result.id).update({'response': 'No'});
                print(e);
              });
          });
        }
        Navigator.push(context, newActivityPage(true, _gID, _golferID)).then((ret) {
          if (ret ?? false) setState(() => index = 5);
        });
        break;
    }
  }
}
