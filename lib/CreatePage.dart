import 'package:flutter/material.dart';
import 'package:editable/editable.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dataModel.dart';
import 'locale/language.dart';

_NewGroupPage newGroupPage(int golferID) {
  return _NewGroupPage(golferID);
}

class _NewGroupPage extends MaterialPageRoute<bool> {
  _NewGroupPage(int golferID)
      : super(builder: (BuildContext context) {
          String _groupName = '', _region = '', _remarks = '';
          return Scaffold(
              appBar: AppBar(title: Text('Create New Golf Group'), elevation: 1.0),
              body: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                return Center(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                  TextFormField(
                    showCursor: true,
                    onChanged: (String value) => setState(() => _groupName = value),
                    //keyboardType: TextInputType.name,
                    decoration: InputDecoration(labelText: "Group Name:", icon: Icon(Icons.group), border: UnderlineInputBorder()),
                  ),
                  TextFormField(
                    showCursor: true,
                    onChanged: (String value) => setState(() => _region = value),
                    //keyboardType: TextInputType.name,
                    decoration: InputDecoration(labelText: "Activity Region:", icon: Icon(Icons.place), border: UnderlineInputBorder()),
                  ),
                  const SizedBox(height: 24.0),
                  TextFormField(
                    showCursor: true,
                    onChanged: (String value) => setState(() => _remarks = value),
                    //keyboardType: TextInputType.name,
                    maxLines: 5,
                    decoration: InputDecoration(labelText: "Remarks:", border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 24.0),
                  ElevatedButton(
                      child: Text(Language.of(context).create),
                      onPressed: () {
                        if (_groupName != '' && _region != '') {
                          golferGroup.add({
                            "name": _groupName,
                            "region": _region,
                            "remarks": _remarks,
                            "managers": [
                              golferID
                            ],
                            "members": [
                              golferID
                            ],
                            "gid": DateTime.now().millisecondsSinceEpoch
                          });
                          Navigator.of(context).pop(true);
                        }
                      })
                ]));
              }));
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

_NewActivityPage newActivityPage(bool isGroup, int golferID) {
  return _NewActivityPage(isGroup, golferID);
}

class _NewActivityPage extends MaterialPageRoute<bool> {
  _NewActivityPage(bool isGroup, int golferID)
      : super(builder: (BuildContext context) {
          String _courseName = '';
          List<NameID> coursesItems = [];
          var _selectedCourse;
          DateTime _selectedDate = DateTime.now();
          bool _includeMe = true;
          String _fee = '2500', _max = '4';
          var activity = isGroup ? groupActivities : golferActivities;
          var tag = isGroup ? 'gid' : 'uid';

          for (var e in golfCourses) coursesItems.add(NameID(e["name"] as String, e["cid"] as int));

          return Scaffold(
              appBar: AppBar(title: Text('Create New Activity'), elevation: 1.0),
              body: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                return Center(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                  const SizedBox(height: 24.0),
                  Flexible(child: Row(children: <Widget>[
                    ElevatedButton(child: Text("Golf Course:"),
                        onPressed: () {
                          showMaterialScrollPicker<NameID>(
                            context: context,
                            title: 'Select a course',
                            items: coursesItems,
                            showDivider: false,
                            selectedItem: _selectedCourse,
                            onChanged: (value) => setState(() => print(_selectedCourse = value)),
                          );
                        }
                      ),
                    const SizedBox(width: 5),
                    Flexible(child: TextFormField(
                      initialValue:  _courseName,
                      key: Key(_selectedCourse.toString()),
                      showCursor: true,
                      onChanged: (String value) => setState(() => _courseName = value),
                      //keyboardType: TextInputType.name,
                      decoration: InputDecoration(labelText: "Course Name:", border: OutlineInputBorder()),
                    )),
                    const SizedBox(width: 5)
                  ])),
                  const SizedBox(height: 24),
                  Flexible(child: Row(children: <Widget>[
                    ElevatedButton(child: Text(Language.of(context).teeOff),
                        onPressed: () {
                          showMaterialDatePicker(
                            context: context,
                            title: 'Pick a date',
                            selectedDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(Duration(days: 180)),
                            //onChanged: (value) => setState(() => _selectedDate = value),
                          ).then((value) => setState(() => print(_selectedDate = value!)));
                        }
                    ),
                    const SizedBox(width: 5),
                    Flexible(child: TextFormField(
                      initialValue: _selectedDate.toString().substring(0, 16),
                      key: Key(_selectedDate.toString().substring(0, 16)),
                      showCursor: true,
                      onChanged: (String? value) => _selectedDate = DateTime.parse(value!),
                      keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(labelText: "Date Time:", border: OutlineInputBorder()),
                    )),
                    const SizedBox(width: 5)
                  ])),
                  const SizedBox(height: 24),
                  Flexible(child: Row(children: <Widget>[
                    const SizedBox(width: 5),
                    Flexible(child: TextFormField(
                      initialValue: _max, 
                      showCursor: true,
                      onChanged: (String value) => setState(() => _max = value),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: Language.of(context).max, icon: Icon(Icons.group), border: OutlineInputBorder()),
                    )),
                    const SizedBox(width: 5),
                    Flexible(child: TextFormField(
                      initialValue: _fee,
                      showCursor: true,
                      onChanged: (String value) => setState(() => _fee = value),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: Language.of(context).fee, icon: Icon(Icons.money), border: OutlineInputBorder()),
                    )),
                    const SizedBox(width: 5)
                  ])),
                  const SizedBox(height: 24),
                  Flexible(child: Row(children: <Widget>[
                    const SizedBox(width: 5),
                    Checkbox(value: _includeMe, onChanged: (bool? value) => setState(() => _includeMe = value!)),
                    const SizedBox(width: 5),
                    const Text('Include myself')
                  ])),
                  const SizedBox(height: 24.0),
                  ElevatedButton(child: Text(Language.of(context).create),
                      onPressed: () {
                        if (_courseName != '') {
                        activity.add({
                          tag: golferID,
                          "cid": _selectedCourse.toID(),
                          "tee off": _selectedDate.toString().substring(0, 16),
                          "max": _max,
                          "fee": _fee,
                          "golfers": _includeMe
                              ? [
                                  {
                                    "uid": golferID,
                                    "appTime": DateTime.now().toString().substring(0, 19),
                                    "scores": []
                                  }
                                ]
                              : []
                        });
                        print(activity);
                        Navigator.of(context).pop(true);
                        }
                      })
                ]));
              }));
        });
}

_NewGolfCoursePage newGolfCoursePage() {
  return _NewGolfCoursePage();
}

class _NewGolfCoursePage extends MaterialPageRoute<bool> {
  _NewGolfCoursePage()
      : super(builder: (BuildContext context) {
          String _courseName = '', _region = '', _photoURL = '';
//          int zoneCnt = 0;
          var _courseZones = [];

          saveZone(var row) {
            print(row);
            _courseZones.add({
              'name': row['zoName'],
              'holes': [
                row['h1'], row['h2'], row['h3'], row['h4'], row['h5'], row['h6'], row['h7'], row['h8'], row['h9']
              ],
            });
          }

          return Scaffold(
              appBar: AppBar(title: Text('Create New Golf Course'), elevation: 1.0),
              body: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                return Center(child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                  TextFormField(
                    showCursor: true,
                    onChanged: (String value) => _courseName = value,
                    //keyboardType: TextInputType.name,
                    decoration: InputDecoration(labelText: "Course Name:", icon: Icon(Icons.golf_course), border: UnderlineInputBorder()),
                  ),
                  TextFormField(
                    showCursor: true,
                    onChanged: (String value) => _region = value,
                    decoration: InputDecoration(labelText: "Region:", icon: Icon(Icons.place), border: UnderlineInputBorder()),
                  ),
                  TextFormField(
                    showCursor: true,
                    onTap: ()  {
                      GoogleMapController _controller;
                      Location _location = Location();
                    },
                    decoration: InputDecoration(labelText: "Location:", icon: Icon(Icons.place), border: UnderlineInputBorder()),
                  ),
                  TextFormField(
                    showCursor: true,
                    onChanged: (String value) => _photoURL = value,
                    //keyboardType: TextInputType.name,
                    decoration: InputDecoration(labelText: "Photo URL:", icon: Icon(Icons.photo), border: UnderlineInputBorder()),
                  ),
                  SizedBox(height: 10),
                  Flexible(
                    child: Editable(
                      borderColor: Colors.black, 
                      tdStyle: TextStyle(fontSize: 16), trHeight: 16, 
                      tdAlignment: TextAlign.center, thAlignment: TextAlign.center, 
                      showSaveIcon: true, saveIcon: Icons.save, saveIconColor: Colors.blue, 
                      onRowSaved: (row) => saveZone(row), 
                      showCreateButton: true, 
                      createButtonLabel: Text('Add zone'), 
                      createButtonIcon: Icon(Icons.add), 
                      createButtonColor: Colors.blue, 
                      columnRatio: 0.15,
                      columns: [
                        {"title": "Zone", 'index': 1, 'key': 'zoName'},
                        {"title": "1", 'index': 2, 'key': 'h1'},
                        {"title": "2", 'index': 3, 'key': 'h2'},
                        {"title": "3", 'index': 4, 'key': 'h3'},
                        {"title": "4", 'index': 5, 'key': 'h4'},
                        {"title": "5", 'index': 6, 'key': 'h5'},
                        {"title": "6", 'index': 7, 'key': 'h6'},
                        {"title": "7", 'index': 8, 'key': 'h7'},
                        {"title": "8", 'index': 9, 'key': 'h8'},
                        {"title": "9", 'index': 10,'key': 'h9'}
                      ],
                      rows: [
                        {'zoName': 'Ou', 'h1': '', 'h2': '', 'h3': '', 'h4': '', 'h5': '', 'h6': '', 'h7': '', 'h8': '','h9': ''},
                        {'zoName': 'I',  'h1': '', 'h2': '', 'h3': '', 'h4': '', 'h5': '', 'h6': '', 'h7': '', 'h8': '','h9': ''},
                      ]
                    )
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                      child: Text(Language.of(context).create),
                      onPressed: () {
                        golfCourses.add({
                          "cid": DateTime.now().millisecondsSinceEpoch,
                          "name": _courseName,
                          "region": _region,
                          "photo": _photoURL,
                          "zones": _courseZones,
                        });
                        //print(golfCourses);
                        //print((golfCourses.elementAt(3)["zones"] as List).length);
                        Navigator.of(context).pop(true);
                      }),
                ]));
              }),
            );
        });
}

class _googleMapPage extends MaterialPageRoute<bool> {

  _googleMapPage() : super(builder: (BuildContext context) {
    LatLng _initialPosition = LatLng(20.5937, 78.9629);
    GoogleMapController _controller;
    Location _location = Location();

      void _onMapCreated(GoogleMapController _cntrl) {
        _controller = _cntrl;
        _location.onLocationChanged.listen((l) { 
          _controller.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(target: LatLng(l.latitude!, l.longitude!),zoom: 15),
            ),
          );
        });
      }

      return Scaffold(
        appBar: AppBar(title: Text('Pick the course location'), elevation: 1.0),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(target: _initialPosition),
              mapType: MapType.hybrid,
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
            )
          ])
        )
      );
    });
}

_showActivityPage showActivityPage(var activity, int uId, String title, bool editable) {
  return _showActivityPage(activity, uId, title, editable);
}

class _showActivityPage extends MaterialPageRoute<bool> {
  _showActivityPage(var activity, int uId, String title, bool editable)
      : super(builder: (BuildContext context) {
          bool alreadyIn = false;

          List buildRows() {
            var rows = [];
            var oneRow = {};
            int idx = 0;

            for (var e in activity['golfers']) {
              if (idx % 4 == 0) {
                oneRow = Map();
                if (idx >= (activity['max'] as int))
                  oneRow['row'] = Language.of(context).waiting;
                else
                  oneRow['row'] = idx / 4 + 1;
                oneRow['c1'] = golferName(e['uid']);
                oneRow['c2'] = '';
                oneRow['c3'] = '';
                oneRow['c4'] = '';
              } else if (idx % 4 == 1)
                oneRow['c2'] = golferName(e['uid']);
              else if (idx % 4 == 2)
                oneRow['c3'] = golferName(e['uid']);
              else if (idx % 4 == 3) {
                oneRow['c4'] = golferName(e['uid']);
                rows.add(oneRow);
              }
              if (e['uid'] as int == uId) alreadyIn = true;
              idx++;
            }
            if ((idx % 4) != 0) rows.add(oneRow);

            return rows;
          }

          return Scaffold(
              appBar: AppBar(title: Text(title), elevation: 1.0),
              body: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                return Container(child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                  const SizedBox(height: 16.0),
                  Text(Language.of(context).teeOff + activity['tee off'] + '\t' + Language.of(context).fee + activity['fee'].toString(), style: TextStyle(fontSize: 20)),
                  const SizedBox(height: 16.0),
                  Text(courseName(activity['cid'] as int)! + "\t" + Language.of(context).max + activity['max'].toString(), style: TextStyle(fontSize: 20)),
                  const SizedBox(height: 16.0),
                  Flexible(child: Editable(
                    borderColor: Colors.black,
                    tdStyle: TextStyle(fontSize: 16),
                    trHeight: 16,
                    tdAlignment: TextAlign.center,
                    thAlignment: TextAlign.center,
                    columnRatio: 0.19,
                    columns: [
                      {"title": Language.of(context).tableGroup, 'index': 1, 'key': 'row','editable': false},
                      {"title": "A", 'index': 2, 'key': 'c1', 'editable': false},
                      {"title": "B", 'index': 3, 'key': 'c2', 'editable': false},
                      {"title": "C", 'index': 4, 'key': 'c3', 'editable': false},
                      {"title": "D", 'index': 5, 'key': 'c4', 'editable': false}
                    ],
                    rows: buildRows(),
                  )),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                      child: Text(alreadyIn ? Language.of(context).cancel : Language.of(context).apply),
                      onPressed: () {
                        setState(() {
                          if (alreadyIn)
                            activity['golfers'].removeWhere((item) => item['uid'] == uId);
                          else
                            activity['golfers'].add({
                              'uid': uId,
                              'appTime': DateTime.now().toString().substring(0, 19),
                              'scores': []
                            });
                        });
                        Navigator.of(context).pop(true);
                        ;
                      }),
                  const SizedBox(height: 16.0),
                ]));
              }),
              floatingActionButton: editable ? FloatingActionButton(
                onPressed: () {},
                child: const Icon(Icons.edit),
              ) : null,
              floatingActionButtonLocation: FloatingActionButtonLocation.endTop
            );
        });
}

/* void showPlacePicker() async {
    LocationResult result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
      PlacePicker("AIzaSyD26EyAImrDoOMn3o6FgmSQjlttxjqmS7U")
    ));
    print(result);
}*/
