import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:editable/editable.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'DataModel.dart';

SharedPreferences? prefs;

Future<void> main() async {
  prefs = await SharedPreferences.getInstance();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Golfer Group',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
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
int _golferID = 0;

class _MyHomePageState extends State<MyHomePage> {
  int _currentPageIndex = 0;
  String _name = '', _phone = '';
  gendre _sex = gendre.Male;
  double _handicap = 18;
  bool isRegistered = false, isUpdate = false;
  List<String> appTitle = [
    "Golfer Info",
    "Groups",
    "Activities",
    "Golf courses",
    "My Scores"
  ];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    _golferID = prefs!.getInt('golferID') ?? 0;
    print(_golferID);
    for (var e in golfers) {
      if (e["uid"] == _golferID) {
        _name = e["name"].toString();
        _phone = e["phone"].toString();
        _sex = e["sex"] == 1 ? gendre.Male : gendre.Female;
        isRegistered = true;
        _currentPageIndex = 1;
        break;
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle[_currentPageIndex]),
      ),
      body: Center(
          child: _currentPageIndex == 0
              ? RegisterBody()
              : _currentPageIndex == 1
                  ? GroupBody()
                  : _currentPageIndex == 2
                      ? ActivityBody()
                      : _currentPageIndex == 3
                          ? GolfCourseBody()
                          : _currentPageIndex == 4
                              ? MyScoreBody()
                              : null),
      drawer: isRegistered ? golfDrawer() : null,
      floatingActionButton: (_currentPageIndex > 0 && _currentPageIndex < 4)
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
              title: Text("Groups"),
              leading: Icon(Icons.group),
              onTap: () {
                setState(() => _currentPageIndex = 1);
                Navigator.of(context).pop();
              }),
          ListTile(
              title: Text("Activities"),
              leading: Icon(Icons.sports_golf),
              onTap: () {
                setState(() => _currentPageIndex = 2);
                Navigator.of(context).pop();
              }),
          ListTile(
              title: Text("Golf Courses"),
              leading: Icon(Icons.golf_course),
              onTap: () {
                setState(() => _currentPageIndex = 3);
                Navigator.of(context).pop();
              }),
          ListTile(
              title: Text("My scores"),
              leading: Icon(Icons.format_list_numbered),
              onTap: () {
                setState(() => _currentPageIndex = 4);
                Navigator.of(context).pop();
              }),
          ListTile(
              title: Text("Log out"),
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
      showCursor: true,
      onChanged: (String value) => setState(() => _name = value),
      //keyboardType: TextInputType.name,
      decoration: InputDecoration(labelText: "Name:", hintText: 'Real Name:', icon: Icon(Icons.person), border: UnderlineInputBorder()),
    );

    final golferPhone = TextFormField(
      initialValue: _phone,
      onChanged: (String value) => setState(() => _phone = value),
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(labelText: "Mobile:", hintText: 'Mobile:', icon: Icon(Icons.phone), border: UnderlineInputBorder()),
    );
    final golferSex = Row(children: <Widget>[
      Flexible(
          child: RadioListTile<gendre>(
              title: const Text('Male'),
              value: gendre.Male,
              groupValue: _sex,
              onChanged: (gendre? value) => setState(() {
                    _sex = value!;
                    _golferAvatar = maleGolfer;
                  }))),
      Flexible(
          child: RadioListTile<gendre>(
              title: const Text('Female'),
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
              isUpdate ? 'Modify' : 'Register',
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            ),
            onPressed: () {
              if (_name != '' && _phone != '') {
                for (var e in golfers) {
                  if (isUpdate) {
                    if (e["uid"] == _golferID) {
                      e["name"] = _name;
                      e["phone"] = _phone;
                      e["sex"] = _sex == gendre.Male ? 1 : 2;
                      break;
                    }
                  } else if (e["name"].toString() == _name && e["phone"].toString() == _phone) {
                    _golferID = e["uid"] as int;
                    print(_name + " already registered");
                    print(_golferID);
                    break;
                  }
                }
                if (_golferID == 0) {
                  _golferID = DateTime.now().millisecondsSinceEpoch;

                  golfers.add({
                    "name": _name,
                    "phone": _phone,
                    "sex": _sex == gendre.Male ? 1 : 2,
                    "uid": _golferID
                  });
                  print('Add new goler ' + _name);
                  print(_golferID);
                }
                prefs!.setInt('golferID', _golferID);
              }
              setState(() => isRegistered = true);
              _currentPageIndex = 1;
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
        Text(isRegistered ? "Handicap: ${_handicap}" : '', style: TextStyle(fontWeight: FontWeight.bold)),
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

  ListView GroupBody() {
    var listView = ListView.separated(
      itemCount: golferGroup.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(golferGroup.elementAt(index)["name"].toString(), style: TextStyle(fontSize: 20)),
        subtitle: Text('Region: ' + golferGroup.elementAt(index)["region"].toString() + "\nManager: " + golferNames(golferGroup.elementAt(index)["managers"] as List<int>)! + "\nmembers: " + (golferGroup.elementAt(index)["members"] as List<int>).length.toString()),
        leading: Image.network("https://www.csu-emba.com/img/port/22/10.jpg"),
        /*Icon(Icons.group), */
        trailing: Icon(Icons.keyboard_arrow_right),
        onTap: () async {
          if (isMember(golferGroup.elementAt(index)["gid"] as int, _golferID)) {
            // show group activities
            print("show group activities");
          } else {
            int gid = golferGroup.elementAt(index)["gid"] as int;
            bool? apply = await showApplyDialog(isApplying(gid, _golferID));
            if (apply!) {
              // fill the apply waiting queue
              applyQueue.add({
                "uid": _golferID,
                "gid": gid,
                "response": "waiting"
              });
              print(applyQueue);
            }
          }
        },
      ),
      separatorBuilder: (context, index) => Divider(),
    );
    return listView;
  }

  ListView ActivityBody() {
    var listView = ListView.separated(
      itemCount: golferActivities.length,
      itemBuilder: (context, index) => ListTile(title: Text(courseName(golferActivities.elementAt(index)["cid"] as int)!, style: TextStyle(fontSize: 20)), subtitle: Text("Tee off: " + golferActivities.elementAt(index)["tee off"].toString() + '\nMax: ' + golferActivities.elementAt(index)["max"].toString() + '\tNow: ' + (golferActivities.elementAt(index)["golfers"] as List<Map>).length.toString() + "\tFee: " + golferActivities.elementAt(index)["fee"].toString()), leading: Image.network(coursePhoto(golferActivities.elementAt(index)["cid"] as int)!), trailing: Icon(Icons.keyboard_arrow_right)),
      separatorBuilder: (context, index) => Divider(),
    );
    return listView;
  }

  ListView GolfCourseBody() {
    var listView = ListView.separated(
      itemCount: golfCourses.length,
      itemBuilder: (context, index) => ListTile(title: Text(golfCourses.elementAt(index)["region"].toString() + ' ' + golfCourses.elementAt(index)["name"].toString(), style: TextStyle(fontSize: 20)), subtitle: Text(((golfCourses.elementAt(index)["zones"] as List<Map>).length * 9).toString() + ' Holes'), leading: Image.network(golfCourses.elementAt(index)["photo"] as String), trailing: Icon(Icons.keyboard_arrow_right)),
      separatorBuilder: (context, index) => Divider(),
    );
    return listView;
  }

  ListView MyScoreBody() {
    return ListView();
  }

  void doBodyAdd(int index) {
    switch (index) {
      case 1:
        Navigator.push(context, _NewGroupPage());
        setState(() => _currentPageIndex = 2);
        break;
      case 2:
        Navigator.push(context, _NewActivityPage(false));
        break;
      case 3:
        Navigator.push(context, _NewGolfCoursePage());
        break;
    }
  }
}

class _NewGroupPage extends MaterialPageRoute<void> {
  _NewGroupPage()
      : super(builder: (BuildContext context) {
          String _groupName='', _region='', _remarks='';
          return Scaffold(
              appBar: AppBar(title: Text('Create New Golf Group'), elevation: 1.0),
              body: Builder(
                  builder: (BuildContext context) => Center(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                        TextFormField(
                          showCursor: true,
                          onChanged: (String value) => _groupName = value,
                          //keyboardType: TextInputType.name,
                          decoration: InputDecoration(labelText: "Group Name:", icon: Icon(Icons.group), border: UnderlineInputBorder()),
                        ),
                        TextFormField(
                          showCursor: true,
                          onChanged: (String value) => _region = value,
                          //keyboardType: TextInputType.name,
                          decoration: InputDecoration(labelText: "Activity Region:", icon: Icon(Icons.place), border: UnderlineInputBorder()),
                        ),
                        const SizedBox(height: 24.0),
                        TextFormField(
                          showCursor: true,
                          onChanged: (String value) => _remarks = value,
                          //keyboardType: TextInputType.name,
                          maxLines: 5,
                          decoration: InputDecoration(labelText: "Remarks:", border: OutlineInputBorder()),
                        ), 
                        const SizedBox(height: 24.0),
                        RaisedButton(
                          child: Text('Create'),
                          onPressed: () {
                            if (_groupName != '' && _region != '') {
                              golferGroup.add({
                                "name": _groupName,
                                "region": _region,
                                "remarks": _remarks,
                                "managers": [_golferID],
                                "members": [_golferID],
                                "gid": DateTime.now().millisecondsSinceEpoch
                              });
                              Navigator.of(context).pop(true);
                            }
                          }
                        )
                      ]
                    ))));
        });
}

class NameID {
  const NameID(this.name, this.ID);
  final String name;
  final int ID;
  @override
  String toString() => name;
  int toID() => ID;
}

class _NewActivityPage extends MaterialPageRoute<void> {
    
  _NewActivityPage(bool isGroup) : super(builder: (BuildContext context) {
    String _courseName='';
    List<NameID> coursesItems = [];
    var _selectedCourse;

    for (var e in golfCourses)
      coursesItems.add(NameID(e["name"] as String, e["cid"] as int));

    return Scaffold(
        appBar: AppBar(title: Text('Create New Activity'), elevation: 1.0),
        body: Builder(
            builder: (BuildContext context) => Center(
              child: Column(crossAxisAlignment: CrossAxisAlignment.center, 
                children: <Widget>[
                  const SizedBox(height: 24.0),
                  Flexible(child: Row(children: <Widget>[
                    ElevatedButton(
                      child: Text("Golf Course:"),
                      onPressed: () { 
                        showMaterialScrollPicker<NameID> (
                          context: context,
                          title: 'Select a course',
                          items: coursesItems,
                          selectedItem: _selectedCourse,
                          onChanged: (value) => _selectedCourse = value,
                        ).then((selection) => _selectedCourse = selection);
                      }
                    ),
                    const SizedBox(width: 5),
                    Flexible(child: TextFormField(
                          initialValue:  _selectedCourse.toString(),
                          showCursor: true,
                          onChanged: (String value) => _courseName = value,
                          //keyboardType: TextInputType.name,
                          decoration: InputDecoration(labelText: "Course Name:", border:OutlineInputBorder()),
                      )),
                    const SizedBox(width: 5)
                  ]))
                ])
            )
        )
      );
  });
}

class _NewGolfCoursePage extends MaterialPageRoute<void> {
  _NewGolfCoursePage()
      : super(builder: (BuildContext context) {
          String _courseName, _region, _photoURL;
          return Scaffold(
              appBar: AppBar(title: Text('Create New Golf Course'), elevation: 1.0),
              body: Builder(
                  builder: (BuildContext context) => Center(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.center, 
                      children: <Widget>[
                        TextFormField(
                          showCursor: true,
                          onChanged: (String value) => _courseName = value,
                          //keyboardType: TextInputType.name,
                          decoration: InputDecoration(labelText: "Course Name:", icon: Icon(Icons.golf_course), border: UnderlineInputBorder()),
                        ),
                        TextFormField(
                          showCursor: true,
                          onChanged: (String value) => _region = value,
                          //keyboardType: TextInputType.name,
                          decoration: InputDecoration(labelText: "Region:", icon: Icon(Icons.place), border: UnderlineInputBorder()),
                        ),
                        TextFormField(
                          showCursor: true,
                          onChanged: (String value) => _photoURL = value,
                          //keyboardType: TextInputType.name,
                          decoration: InputDecoration(labelText: "Photo URL:", icon: Icon(Icons.photo), border: UnderlineInputBorder()),
                        ),
                        Flexible(child: Editable(borderColor: Colors.black, tdStyle: TextStyle(fontSize:16),
                          trHeight: 16, tdAlignment: TextAlign.center,
                          columns: [
                            {"title" : "Hole#", 'index': 1, 'key': 'hole'},
                            {"title" : "Out", 'index': 2, 'key': 'z1'},
                            {"title" : "Int", 'index': 3, 'key': 'z2'},
                          ],
                          rows: [
                            {'hole': 1, 'z1': '', 'z2': ''},
                            {'hole': 2, 'z1': '', 'z2': ''},
                            {'hole': 3, 'z1': '', 'z2': ''},
                            {'hole': 4, 'z1': '', 'z2': ''},
                            {'hole': 5, 'z1': '', 'z2': ''},
                            {'hole': 6, 'z1': '', 'z2': ''},
                            {'hole': 7, 'z1': '', 'z2': ''},
                            {'hole': 8, 'z1': '', 'z2': ''},
                            {'hole': 9, 'z1': '', 'z2': ''},
                          ]
                        ))
                      ]
                    ))));
        });
/* void showPlacePicker() async {
    LocationResult result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
      PlacePicker("AIzaSyD26EyAImrDoOMn3o6FgmSQjlttxjqmS7U")
    ));
    print(result);
  }*/
}
