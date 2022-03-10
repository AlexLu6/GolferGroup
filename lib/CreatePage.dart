import 'package:flutter/material.dart';
import 'package:editable/editable.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'DataModel.dart';

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
                      child: Text('Create'),
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

_NewActivityPage newActivityPage(bool isGroup) {
  return _NewActivityPage(isGroup);
}

class _NewActivityPage extends MaterialPageRoute<bool> {
  _NewActivityPage(bool isGroup)
      : super(builder: (BuildContext context) {
          String _courseName = '';
          List<NameID> coursesItems = [];
          var _selectedCourse;
          DateTime _selectedDate = DateTime.now();
          bool _includeMe = true;

          for (var e in golfCourses) coursesItems.add(NameID(e["name"] as String, e["cid"] as int));

          return Scaffold(
              appBar: AppBar(title: Text('Create New Activity'), elevation: 1.0),
              body: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                return Center(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                  const SizedBox(height: 24.0),
                  Flexible(
                      child: Row(children: <Widget>[
                    ElevatedButton(
                        child: Text("Golf Course:"),
                        onPressed: () {
                          showMaterialScrollPicker<NameID>(
                            context: context,
                            title: 'Select a course',
                            items: coursesItems,
                            showDivider: false,
                            selectedItem: _selectedCourse,
                            onChanged: (value) => setState(() => print(_selectedCourse = value)),
                          );
                        }),
                    const SizedBox(width: 5),
                    Flexible(
                        child: TextFormField(
                      //initialValue: ,
                      key: Key(_selectedCourse.toString()),
                      showCursor: true,
                      onChanged: (String value) => setState(() => _courseName = value),
                      //keyboardType: TextInputType.name,
                      decoration: InputDecoration(labelText: "Course Name:", border: OutlineInputBorder()),
                    )),
                    const SizedBox(width: 5)
                  ])),
                  const SizedBox(height: 24),
                  Flexible(
                      child: Row(children: <Widget>[
                    ElevatedButton(
                        child: Text("Tee off Date:"),
                        onPressed: () {
                          showMaterialDatePicker(
                            context: context,
                            title: 'Pick a date',
                            selectedDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(Duration(days: 180)),
                            //onChanged: (value) => setState(() => _selectedDate = value),
                          ).then((value) => setState(() => print(_selectedDate = value!)));
                        }),
                    const SizedBox(width: 5),
                    Flexible(
                        child: TextFormField(
                      initialValue: _selectedDate.toString().substring(0, 16),
                      key: Key(_selectedDate.toString().substring(0, 16)),
                      showCursor: true,
                      onSaved: (String? value) => _selectedDate = DateTime.parse(value!),
                      keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(labelText: "Date:", border: OutlineInputBorder()),
                    )),
                    const SizedBox(width: 5)
                  ])),
                  Flexible(
                      child: Row(children: <Widget>[
                    const SizedBox(width: 5),
                    Checkbox(value: _includeMe, onChanged: (bool? value) => setState(() => _includeMe = value!)),
                    const SizedBox(width: 5),
                    const Text('Include myself')
                  ])),
                ]));
              }));
        });
}

_NewGolfCoursePage newGolfCoursePage() {
  return _NewGolfCoursePage();
}

class _NewGolfCoursePage extends MaterialPageRoute<void> {
  _NewGolfCoursePage()
      : super(builder: (BuildContext context) {
          String _courseName, _region, _photoURL;
          return Scaffold(
              appBar: AppBar(title: Text('Create New Golf Course'), elevation: 1.0),
              body: Builder(
                  builder: (BuildContext context) => Center(
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
                          //keyboardType: TextInputType.name,
                          decoration: InputDecoration(labelText: "Region:", icon: Icon(Icons.place), border: UnderlineInputBorder()),
                        ),
                        TextFormField(
                          showCursor: true,
                          onChanged: (String value) => _photoURL = value,
                          //keyboardType: TextInputType.name,
                          decoration: InputDecoration(labelText: "Photo URL:", icon: Icon(Icons.photo), border: UnderlineInputBorder()),
                        ),
                        Flexible(
                            child: Editable(borderColor: Colors.black, tdStyle: TextStyle(fontSize: 16), trHeight: 16, tdAlignment: TextAlign.center, columns: [
                          {
                            "title": "Hole#",
                            'index': 1,
                            'key': 'hole'
                          },
                          {
                            "title": "Out",
                            'index': 2,
                            'key': 'z1'
                          },
                          {
                            "title": "Int",
                            'index': 3,
                            'key': 'z2'
                          },
                        ], rows: [
                          {
                            'hole': 1,
                            'z1': '',
                            'z2': ''
                          },
                          {
                            'hole': 2,
                            'z1': '',
                            'z2': ''
                          },
                          {
                            'hole': 3,
                            'z1': '',
                            'z2': ''
                          },
                          {
                            'hole': 4,
                            'z1': '',
                            'z2': ''
                          },
                          {
                            'hole': 5,
                            'z1': '',
                            'z2': ''
                          },
                          {
                            'hole': 6,
                            'z1': '',
                            'z2': ''
                          },
                          {
                            'hole': 7,
                            'z1': '',
                            'z2': ''
                          },
                          {
                            'hole': 8,
                            'z1': '',
                            'z2': ''
                          },
                          {
                            'hole': 9,
                            'z1': '',
                            'z2': ''
                          },
                        ]))
                      ]))));
        });
/* void showPlacePicker() async {
    LocationResult result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
      PlacePicker("AIzaSyD26EyAImrDoOMn3o6FgmSQjlttxjqmS7U")
    ));
    print(result);
  }*/
}