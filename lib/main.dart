import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dataModel.dart';
import 'CreatePage.dart';
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
  var _golferDoc, _groupDoc;
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
          child: _currentPageIndex == 0 ? RegisterBody()
               : _currentPageIndex == 1 ? GroupBody()
               : _currentPageIndex == 2 ? ActivityBody()
               : _currentPageIndex == 3 ? GolfCourseBody()
               : _currentPageIndex == 4 ? MyScoreBody()
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

  ListView RegisterBody() {
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
                        _golferID = DateTime.now().millisecondsSinceEpoch;

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
        Text(isRegistered ? Language.of(context).handicap + ": ${_handicap}" : '', style: TextStyle(fontWeight: FontWeight.bold)),
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
              FlatButton(child: Text(applying ? "OK" : "Apply"), onPressed: () => Navigator.of(context).pop(!applying)),
              FlatButton(child: Text("Cancel"), onPressed: () => Navigator.of(context).pop(false))
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
              FlatButton(child: Text("OK"), onPressed: () => Navigator.of(context).pop(true)),
              FlatButton(child: Text("Reject"), onPressed: () => Navigator.of(context).pop(false))
            ],
          );
        });
  }

  Widget? GroupBody() {

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('GolferClubs').snapshots(),
      builder: (context, snapshot) {
        print('group builder');
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        } else {
          return ListView(
            children: snapshot.data!.docs.map((doc) {
              print((doc.data()! as Map)["Name"]);
              return Card(child: ListTile(
                title: Text((doc.data()! as Map)["Name"], style: TextStyle(fontSize: 20)),
                subtitle: Text(Language.of(context).region + (doc.data()! as Map)["region"]), // + "\n" + 
//                Language.of(context).manager + golferNames((doc.data()! as Map)["managers"] as List<int>)! + "\n" + 
//                Language.of(context).members + ((doc.data()! as Map)["members"] as List<int>).length.toString()),
                leading: Image.network("https://www.csu-emba.com/img/port/22/10.jpg"), /*Icon(Icons.group), */
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () async {
                  _gID = (doc.data()! as Map)["gid"] as int;
                  _groupDoc = doc.id;
                  if (isMember(_gID, _golferID)) {
                    setState(() => _currentPageIndex = 5);
                  } else {
                    bool? apply = await showApplyDialog(isApplying(_gID, _golferID) == 1);
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
            }).toList(),
          );
        }
      });
  }

  ListView groupActivityBody(int gID) {
    int eidx = 0;
    List<int> map = [];
    for (var e in groupActivities) {
      if (e["gid"] as int == gID) {
        map.add(eidx);
      }
      eidx++;
    }
    var listView = ListView.separated(
      itemCount: map.length,
      itemBuilder: (context, index) => ListTile(
          title: Text(courseName(groupActivities.elementAt(map[index])["cid"] as int)!, style: TextStyle(fontSize: 20)),
          subtitle: Text(Language.of(context).teeOff + groupActivities.elementAt(map[index])["tee off"].toString() + '\n' + Language.of(context).max + groupActivities.elementAt(map[index])["max"].toString() + '\t' + Language.of(context).now + (groupActivities.elementAt(map[index])["golfers"] as List).length.toString() + "\t" + Language.of(context).fee + groupActivities.elementAt(map[index])["fee"].toString()),
          leading: Image.network(coursePhoto(groupActivities.elementAt(map[index])["cid"] as int)!),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {
            Navigator.push(context, showActivityPage(groupActivities.elementAt(index), _golferID, groupName(gID)!, isManager(gID, _golferID)));
          }),
      separatorBuilder: (context, index) => Divider(),
    );

    return listView;
  }

  ListView ActivityBody() {
    var listView = ListView.separated(
      itemCount: golferActivities.length,
      itemBuilder: (context, index) => ListTile(
          title: Text(courseName(golferActivities.elementAt(index)["cid"] as int)!, style: TextStyle(fontSize: 20)),
          subtitle: Text(Language.of(context).teeOff + golferActivities.elementAt(index)["tee off"].toString() + '\n' + Language.of(context).max + golferActivities.elementAt(index)["max"].toString() + '\t' + Language.of(context).now + (golferActivities.elementAt(index)["golfers"] as List).length.toString() + "\t" + Language.of(context).fee + golferActivities.elementAt(index)["fee"].toString()),
          leading: Image.network(coursePhoto(golferActivities.elementAt(index)["cid"] as int)!),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {
            Navigator.push(context, showActivityPage(golferActivities.elementAt(index), _golferID, golferName(golferActivities.elementAt(index)['uid'] as int)!, _golferID == golferActivities.elementAt(index)['uid'] as int));
          }),
      separatorBuilder: (context, index) => Divider(),
    );
    return listView;
  }

  ListView GolfCourseBody() {
    var listView = ListView.separated(
      itemCount: golfCourses.length,
      itemBuilder: (context, index) => ListTile(title: Text(golfCourses.elementAt(index)["region"].toString() + ' ' + golfCourses.elementAt(index)["name"].toString(), style: TextStyle(fontSize: 20)), subtitle: Text(((golfCourses.elementAt(index)["zones"] as List).length * 9).toString() + ' Holes'), leading: Image.network(golfCourses.elementAt(index)["photo"] as String), trailing: Icon(Icons.keyboard_arrow_right)),
      separatorBuilder: (context, index) => Divider(),
    );
    return listView;
  }

  ListView MyScoreBody() {
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
        Navigator.push(context, newActivityPage('golferActivities', _golferDoc, _golferDoc)).then((ret) {
          if (ret ?? false) setState(() => index = 2);
        });
        break;
      case 3:
        Navigator.push(context, newGolfCoursePage()).then((ret) {
          if (ret ?? false) setState(() => index = 3);
        });
        break;
      case 5:
        if (isManager(_gID, _golferID))  {
          FirebaseFirestore.instance.collection('ApplyQueue')
            .where('gid', isEqualTo: _gID)
            .where('response', isEqualTo: 'waiting').get().then((value) {
              value.docs.forEach((result) async {
                // grant or refuse the apply of e['uid']
                var e = result.data();
                bool? ans = await grantApplyDialog(golferName(e['uid'] as int)!);
                if (ans!) {
                  e.update('response', (value) => 'OK');
                  addMember(_gID, e['uid'] as int);
                } else
                  e.update('response', (value) => 'No');
              });
          });
        }
        Navigator.push(context, newActivityPage("groupActivities", _groupDoc, _golferDoc)).then((ret) {
          if (ret ?? false) setState(() => index = 5);
        });
        break;
    }
  }
}
