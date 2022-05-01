import 'package:flutter/material.dart';
import 'package:editable/editable.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
              appBar: AppBar(title: Text(Language.of(context).createNewGolfGroup), elevation: 1.0),
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
                      child: Text(Language.of(context).create, style: TextStyle(fontSize: 24)),
                      onPressed: () {
                        int gID = uuidTime();
                        if (_groupName != '' && _region != '') {
                          FirebaseFirestore.instance.collection('GolferClubs').add({
                            "name": _groupName,
                            "region": _region,
                            "remarks": _remarks,
                            "managers": [golferID],
                            "members": [golferID],
                            "gid": gID
                          });
                          myGroups.add(gID); 
                          storeMyGroup();
                          Navigator.of(context).pop(true);
                        }
                      })
                ]));
              }));
        });
}

class NameID {
  const NameID(this.name, this.id);
  final String name;
  final int id;
  @override
  String toString() => name;
  int toID() => id;
}

List<NameID> coursesItems = [];

_NewActivityPage newActivityPage(bool isGroup, int owner, int golfer) {
  return _NewActivityPage(isGroup, owner, golfer);
}

class _NewActivityPage extends MaterialPageRoute<bool> {
  _NewActivityPage(bool isGroup, int owner, int golfer)
      : super(builder: (BuildContext context) {
          String _courseName = '';
          var _selectedCourse;
          DateTime _selectedDate = DateTime.now();
          bool _includeMe = true;
          int _fee = 2500, _max = 4;
          var activity = FirebaseFirestore.instance.collection(isGroup ? 'ClubActivities' : 'GolferActivities');
          var tag = isGroup ? 'gid' : 'uid';

          if (coursesItems.isEmpty)
            FirebaseFirestore.instance.collection('GolfCourses').get().then((value) {
              value.docs.forEach((result) {
                var items = result.data();
                coursesItems.add(NameID(items['name'] as String, items['cid'] as int));
              });
            });

          return Scaffold(
              appBar: AppBar(title: Text(Language.of(context).createNewActivity), elevation: 1.0),
              body: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                return Center(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                  const SizedBox(height: 24.0),
                  Flexible(
                      child: Row(children: <Widget>[
                    ElevatedButton(
                        child: Text(Language.of(context).golfCourses),
                        onPressed: () {
                          showMaterialScrollPicker<NameID>(
                            context: context,
                            title: 'Select a course',
                            items: coursesItems,
                            showDivider: false,
                            selectedItem: _selectedCourse,
                            onChanged: (value) => setState(() => _selectedCourse = value),
                          ).then((value) => setState(() => _courseName = value.toString()));
                        }),
                    const SizedBox(width: 5),
                    Flexible(
                        child: TextFormField(
                      initialValue: _courseName,
                      key: Key(_courseName),
                      showCursor: true,
                      onChanged: (String value) => setState(() => print(_courseName = value)),
                      //keyboardType: TextInputType.name,
                      decoration: InputDecoration(labelText: "Course Name:", border: OutlineInputBorder()),
                    )),
                    const SizedBox(width: 5)
                  ])),
                  const SizedBox(height: 24),
                  Flexible(
                      child: Row(children: <Widget>[
                    ElevatedButton(
                        child: Text(Language.of(context).teeOff),
                        onPressed: () {
                          showMaterialDatePicker(
                            context: context,
                            title: 'Pick a date',
                            selectedDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(Duration(days: 180)),
                            //onChanged: (value) => setState(() => _selectedDate = value),
                          ).then((date) {
                            if (date != null) showMaterialTimePicker(context: context, title: 'Pick a time', selectedTime: TimeOfDay.now()).then((time) => setState(() => print(_selectedDate = DateTime(date.year, date.month, date.day, time!.hour, time.minute))));
                          });
                        }),
                    const SizedBox(width: 5),
                    Flexible(
                        child: TextFormField(
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
                  Flexible(
                      child: Row(children: <Widget>[
                    const SizedBox(width: 5),
                    Flexible(
                        child: TextFormField(
                      initialValue: _max.toString(),
                      showCursor: true,
                      onChanged: (String value) => setState(() => _max = int.parse(value)),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: Language.of(context).max, icon: Icon(Icons.group), border: OutlineInputBorder()),
                    )),
                    const SizedBox(width: 5),
                    Flexible(
                        child: TextFormField(
                      initialValue: _fee.toString(),
                      showCursor: true,
                      onChanged: (String value) => setState(() => _fee = int.parse(value)),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: Language.of(context).fee, icon: Icon(Icons.money), border: OutlineInputBorder()),
                    )),
                    const SizedBox(width: 5)
                  ])),
                  const SizedBox(height: 24),
                  Flexible(
                      child: Row(children: <Widget>[
                    const SizedBox(width: 5),
                    Checkbox(value: _includeMe, onChanged: (bool? value) => setState(() => _includeMe = value!)),
                    const SizedBox(width: 5),
                    const Text('Include myself')
                  ])),
                  const SizedBox(height: 24.0),
                  ElevatedButton(
                      child: Text(Language.of(context).create, style: TextStyle(fontSize: 24)),
                      onPressed: () async {
//                        print(_selectedCourse.toString());
                        var name = await golferName(golfer);
                        if (_courseName != '') {
                          activity.add({
                            tag: owner,
                            "cid": _selectedCourse.toID(),
                            "teeOff": Timestamp.fromDate(_selectedDate),
                            "max": _max,
                            "fee": _fee,
                            "golfers": _includeMe ? [{
                                      "uid": golfer,
                                      "name": name,
                                      "appTime": DateTime.now().toString().substring(0, 19),
                                      "scores": []
                                    }] : []
                          });
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
          double _lat = 0, _lon = 0;
          var _courseZones = [];
          //         List<AutocompletePrediction>? predictions = [];
//          GooglePlace googlePlace = GooglePlace('AIzaSyD26EyAImrDoOMn3o6FgmSQjlttxjqmS7U');

          saveZone(var row) {
            print(row);
            _courseZones.add({
              'name': row['zoName'],
              'holes': [
                row['h1'],
                row['h2'],
                row['h3'],
                row['h4'],
                row['h5'],
                row['h6'],
                row['h7'],
                row['h8'],
                row['h9']
              ],
            });
          }

          return Scaffold(
            appBar: AppBar(title: Text(Language.of(context).createNewCourse), elevation: 1.0),
            body: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
              return Center(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
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
                  onChanged: (String value) {
                    int i;
                    for (i = 0; value[i] != ','; i++);
                    _lat = double.parse(value.substring(0, i - 1));
                    _lon = double.parse(value.substring(i + 1));
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
                  tdStyle: TextStyle(fontSize: 16),
                  trHeight: 16,
                  tdAlignment: TextAlign.center,
                  thAlignment: TextAlign.center,
                  showSaveIcon: true,
                  saveIcon: Icons.save,
                  saveIconColor: Colors.blue,
                  onRowSaved: (row) => saveZone(row),
                  showCreateButton: true,
                  createButtonLabel: Text('Add zone'),
                  createButtonIcon: Icon(Icons.add),
                  createButtonColor: Colors.blue,
                  columnRatio: 0.15,
                  columns: [
                    {
                      "title": "Zone",
                      'index': 1,
                      'key': 'zoName'
                    },
                    {
                      "title": "1",
                      'index': 2,
                      'key': 'h1'
                    },
                    {
                      "title": "2",
                      'index': 3,
                      'key': 'h2'
                    },
                    {
                      "title": "3",
                      'index': 4,
                      'key': 'h3'
                    },
                    {
                      "title": "4",
                      'index': 5,
                      'key': 'h4'
                    },
                    {
                      "title": "5",
                      'index': 6,
                      'key': 'h5'
                    },
                    {
                      "title": "6",
                      'index': 7,
                      'key': 'h6'
                    },
                    {
                      "title": "7",
                      'index': 8,
                      'key': 'h7'
                    },
                    {
                      "title": "8",
                      'index': 9,
                      'key': 'h8'
                    },
                    {
                      "title": "9",
                      'index': 10,
                      'key': 'h9'
                    }
                  ],
                  rows: [
                    {
                      'zoName': 'Ou',
                      'h1': '',
                      'h2': '',
                      'h3': '',
                      'h4': '',
                      'h5': '',
                      'h6': '',
                      'h7': '',
                      'h8': '',
                      'h9': ''
                    },
                    {
                      'zoName': 'I',
                      'h1': '',
                      'h2': '',
                      'h3': '',
                      'h4': '',
                      'h5': '',
                      'h6': '',
                      'h7': '',
                      'h8': '',
                      'h9': ''
                    },
                  ],
                )),
                const SizedBox(height: 16.0),
                ElevatedButton(
                    child: Text(Language.of(context).create, style: TextStyle(fontSize: 24)),
                    onPressed: () {
                      FirebaseFirestore.instance.collection('GolfCourses').add({
                        "cid": uuidTime(),
                        "name": _courseName,
                        "region": _region,
                        "photo": _photoURL,
                        "zones": _courseZones,
                        "location": GeoPoint(_lat, _lon),
                      });
                      Navigator.of(context).pop(true);
                    }),
              ]));
            }),
          );
        });
}

ShowActivityPage showActivityPage(var activity, int uId, String title, bool editable, double handicap) {
  return ShowActivityPage(activity, uId, title, editable, handicap);
}

class ShowActivityPage extends MaterialPageRoute<int> {
  ShowActivityPage(var activity, int uId, String title, bool editable, double handicap)
      : super(builder: (BuildContext context) {
          bool alreadyIn = false;
          String uName=''; int uIdx=0;
          var rows = [];

          List buildRows() {
            var oneRow = {};
            int idx = 0;

            for (var e in activity.data()!['golfers']) {
              if (idx % 4 == 0) {
                oneRow = Map();
                if (idx >= (activity.data()!['max'] as int))
                  oneRow['row'] = Language.of(context).waiting;
                else
                  oneRow['row'] = idx / 4 + 1;
                oneRow['c1'] = e['name'];
                oneRow['c2'] = '';
                oneRow['c3'] = '';
                oneRow['c4'] = '';
              } else if (idx % 4 == 1)
                oneRow['c2'] = e['name'];
              else if (idx % 4 == 2)
                oneRow['c3'] = e['name'];
              else if (idx % 4 == 3) {
                oneRow['c4'] = e['name'];
                rows.add(oneRow);
              }
              if (e['uid'] as int == uId) {
                alreadyIn = true; 
                uName = e['name']; 
                uIdx = idx;
                if (myActivities.indexOf(activity.id) < 0) {
                  myActivities.add(activity.id);
                  storeMyActivities();
                }
              }
              idx++;
              if (idx == (activity.data()!['max'] as int)) while (idx % 4 != 0) idx++;
            }
            if ((idx % 4) != 0)
              rows.add(oneRow);
            else if (idx == 0) {
              oneRow['c1'] = oneRow['c2'] = oneRow['c3'] = oneRow['c4'] = '';
              rows.add(oneRow);
            }

            return rows;
          }

          bool teeOffPass = activity.data()!['teeOff'].compareTo(Timestamp.now()) < 0;
          Map course = {};
          void updateScore() async {
            FirebaseFirestore.instance.collection('ClubActivities').doc(activity.id).get().then((value) {
              var glist = value.get('golfers');
              glist[uIdx]['scores'] = myScores[0]['scores'];
              glist[uIdx]['total'] = myScores[0]['total'];
              glist[uIdx]['net'] = myScores[0]['total'] - handicap;
              FirebaseFirestore.instance.collection('ClubActivities').doc(activity.id).update({'golfers': glist});
            });
          }
          return Scaffold(
              appBar: AppBar(title: Text(title), elevation: 1.0),
              body: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                return Container(child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                  const SizedBox(height: 16.0),
                  Text(Language.of(context).teeOff + activity.data()!['teeOff'].toDate().toString().substring(0, 16) + '\t' + Language.of(context).fee + activity.data()!['fee'].toString(), style: TextStyle(fontSize: 20)),
                  const SizedBox(height: 16.0),
                  FutureBuilder(
                      future: courseBody(activity.data()!['cid'] as int),
                      builder: (context, snapshot2) {
                        if (!snapshot2.hasData)
                          return const LinearProgressIndicator();
                        else {
                          course = snapshot2.data!as Map;
                          return Text(course['name'] + "\t" + Language.of(context).max + activity.data()!['max'].toString(), style: TextStyle(fontSize: 20));
                        }
                      }),
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
                      {"title": "A", 'index': 2,'key': 'c1','editable': false},
                      {"title": "B", 'index': 3,'key': 'c2','editable': false},
                      {"title": "C", 'index': 4,'key': 'c3','editable': false},
                      {"title": "D", 'index': 5,'key': 'c4','editable': false}
                    ],
                    rows: buildRows(),
                  )),
                  const SizedBox(height: 16.0),
                  teeOffPass && !alreadyIn ? const SizedBox(height: 10.0) : 
                  ElevatedButton(
                    child: Text(teeOffPass && alreadyIn ? Language.of(context).enterScore : 
                                alreadyIn ? Language.of(context).cancel : Language.of(context).apply),
                    onPressed: () async {
                      if (teeOffPass && alreadyIn) {                        
                        if ((course["zones"]).length > 2) {
                          List zones = await selectZones(context, course);
                          if (zones.isNotEmpty)
                            Navigator.push(context, newScorePage(course, uName, zone0: zones[0], zone1: zones[1])).then((value) {
                              if (value!) 
                                updateScore();
                            });
                        } else
                          Navigator.push(context, newScorePage(course, uName)).then((value) {
                            if (value!) 
                              updateScore();
                          });
                        Navigator.of(context).pop(0);
                      } else
                        Navigator.of(context).pop(teeOffPass ? 0 : alreadyIn ? -1 : 1);
                    }),
                  const SizedBox(height: 16.0),
                ]));
              }),
              floatingActionButton: editable
                  ? FloatingActionButton(
                      onPressed: () {},
                      child: const Icon(Icons.edit),
                    )
                  : null,
              floatingActionButtonLocation: FloatingActionButtonLocation.endTop);
        });
}

Future<List> selectZones(BuildContext context, Map course, {int zone0 = 0, int zone1 = 1}) {
    bool? _zone0 = true, _zone1 = true, _zone2 = false, _zone3 = false;
    return showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                title: const Text('Select 2 courses'),
                actions: [
                  CheckboxListTile(
                      value: _zone0,
                      title: Text(course["zones"][0]['name']),
                      onChanged: (bool? value) {
                        setState(() => _zone0 = value);
                      }),
                  CheckboxListTile(
                      value: _zone1,
                      title: Text(course["zones"][1]['name']),
                      onChanged: (bool? value) {
                        setState(() => _zone1 = value);
                      }),
                  CheckboxListTile(
                      value: _zone2,
                      title: Text(course["zones"][2]['name']),
                      onChanged: (bool? value) {
                        setState(() => _zone2 = value);
                      }),
                  (course["zones"]).length == 3
                      ? SizedBox(height: 6)
                      : CheckboxListTile(
                          value: _zone3,
                          title: Text(course["zones"][3]['name']),
                          onChanged: (bool? value) {
                            setState(() => _zone3 = value);
                          }),
                  Row(children: [
                    TextButton(child: Text("OK"), onPressed: () => Navigator.of(context).pop(true)),
                    TextButton(child: Text("Cancel"), onPressed: () => Navigator.of(context).pop(false))
                  ])
                ],
              );
            });
          }).then((value) {
            int zone0, zone1;
            zone0 = _zone0! ? 0 : _zone1! ? 1 : 2;
            zone1 = _zone3! ? 3 : _zone2! ? 2 : 1;
            if (value) 
              return [zone0, zone1];
            return [];
          });
}

_NewScorePage newScorePage(Map course, String golfer, {int zone0 = 0, int zone1 = 1}) {
    return _NewScorePage(course, golfer, zone0, zone1);
}

class _NewScorePage extends MaterialPageRoute<bool> {
  _NewScorePage(Map course, String golfer, int zone0, int zone1)
      : super(builder: (BuildContext context) {
          final _editableKey = GlobalKey<EditableState>();
          var columns = [
            {"title": 'Out', 'index': 0, 'key': 'zone1', 'editable': false},
            {"title": "Par", 'index': 1, 'key': 'par1', 'editable': false},
            {"title": " ", 'index': 2, 'key': 'score1'},
            {"title": 'In', 'index': 3, 'key': 'zone2', 'editable': false},
            {"title": "Par", 'index': 4, 'key': 'par2', 'editable': false},
            {"title": " ", 'index': 5,'key': 'score2'}
          ];
          var rows = [
            {'zone1': '1', 'par1': '4', 'score1': '', 'zone2': '10', 'par2': '4', 'score2': ''},
            {'zone1': '2', 'par1': '4', 'score1': '', 'zone2': '11', 'par2': '4', 'score2': ''},
            {'zone1': '3', 'par1': '4', 'score1': '', 'zone2': '12', 'par2': '4', 'score2': ''},
            {'zone1': '4', 'par1': '4', 'score1': '', 'zone2': '13', 'par2': '4', 'score2': ''},
            {'zone1': '5', 'par1': '4', 'score1': '', 'zone2': '14', 'par2': '4', 'score2': ''},
            {'zone1': '6', 'par1': '4', 'score1': '', 'zone2': '15', 'par2': '4', 'score2': ''},
            {'zone1': '7', 'par1': '4', 'score1': '', 'zone2': '16', 'par2': '4', 'score2': ''},
            {'zone1': '8', 'par1': '4', 'score1': '', 'zone2': '17', 'par2': '4', 'score2': ''},
            {'zone1': '9', 'par1': '4', 'score1': '', 'zone2': '18', 'par2': '4', 'score2': ''},
            {'zone1': 'Sum', 'par1': '', 'score1': '', 'zone2': 'Sum', 'par2': '4', 'score2': ''}
          ];
          List<int> pars = List.filled(18, 0), scores = List.filled(19, 0);
          int sum1 = 0, sum2 = 0;
          int tpars = 0;
          List buildColumns() {
            columns[0]['title'] = course['zones'][zone0]['name'];
            columns[3]['title'] = course['zones'][zone1]['name'];
            return columns;
          }

          List buildRows() {
            int idx = 0, sum = 0;
            tpars = 0;
            (course['zones'][zone0]['holes']).forEach((par) {
              rows[idx]['par1'] = par.toString();
              sum += int.parse(par);
              pars[idx] = int.parse(par);
              tpars += pars[idx];
              idx++;
            });
            rows[idx]['par1'] = sum.toString();
            idx = sum = 0;
            (course['zones'][zone1]['holes']).forEach((par) {
              rows[idx]['par2'] = par.toString();
              sum += int.parse(par);
              pars[idx + 9] = int.parse(par);
              tpars += pars[idx];
              idx++;
            });
            rows[idx]['par2'] = sum.toString();
            return rows;
          }

          return Scaffold(
              appBar: AppBar(title: Text(Language.of(context).enterScore), elevation: 1.0),
              body: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                return Container(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                  const SizedBox(height: 16.0),
                  Text('Name: ' + golfer, style: TextStyle(fontSize: 20)),
                  const SizedBox(height: 16.0),
                  Text('Course: ' + course['region'] + ' ' + course['name'], style: TextStyle(fontSize: 20)),
                  const SizedBox(height: 16.0),
                  Flexible(
                      child: Editable(
                          key: _editableKey,
                          borderColor: Colors.black,
                          tdStyle: TextStyle(fontSize: 16),
                          trHeight: 16,
                          tdAlignment: TextAlign.center,
                          thAlignment: TextAlign.center,
                          columnRatio: 0.16,
                          columns: buildColumns(),
                          rows: buildRows(),
                          onSubmitted: (value) {
                            sum1 = sum2 = 0;
                            _editableKey.currentState!.editedRows.forEach((element) {
                              if (element['row'] != 9) {
                                sum1 += int.parse(element['score1'] ?? '0');
                                sum2 += int.parse(element['score2'] ?? '0');
                                scores[element['row']] = int.parse(element['score1'] ?? '0');
                                scores[element['row'] + 9] = int.parse(element['score2'] ?? '0');
                              }
                            });
                            setState(() {});
                          })),
                  const SizedBox(height: 6.0),
                  (sum1 + sum2) == 0 ? const SizedBox(height: 6.0) : Text(Language.of(context).total + (sum1 + sum2).toString(), style: TextStyle(fontSize: 20)),
                  const SizedBox(height: 16.0),
                  Center(
                      child: ElevatedButton(
                          child: Text(Language.of(context).store, style: TextStyle(fontSize: 24)),
                          onPressed: () {
                            myScores.insert(0, {
                              'date': DateTime.now().toString().substring(0, 16),
                              'course': course['name'],
                              'pars': pars,
                              'scores': scores,
                              'total': sum1 + sum2,
                              'handicap': (sum1 + sum2) - tpars > 0 ? (sum1 + sum2) - tpars : 0
                            });
                            storeMyScores();
                            Navigator.of(context).pop(true);
                          })),
                  const SizedBox(height: 6.0)
                ]));
              }));
        });
}
