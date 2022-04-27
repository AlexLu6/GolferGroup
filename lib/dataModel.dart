import 'dart:convert';
//import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
SharedPreferences? prefs;

int uuidTime() {
  return DateTime.now().millisecondsSinceEpoch - 1647000000000;
}

var myGroups = [];
void storeMyGroup() 
{
  prefs!.setString('golfGroups', jsonEncode(myGroups));
}

void  loadMyGroup() 
{
  myGroups = jsonDecode(prefs!.getString('golfGroups')?? '[]');
}

var myActivities =[];
void storeMyActivities() {
  prefs!.setString('golfActivities', jsonEncode(myActivities));
}

void loadMyActivities() 
{
  myActivities = jsonDecode(prefs!.getString('golfActivities')?? '[]');
}

var myScores = [];
void storeMyScores()
{
  prefs!.setString('golfScores', jsonEncode(myScores));
}

void loadMyScores() 
{
  myScores = jsonDecode(prefs!.getString('golfScores')?? '[]');
}

var golferGroup = {
  {
    "name": "麻吉 Fun Golf",
    "region": "北台灣",
    "managers": [100],
    "members": [100,101,102],
    "remarks": "Please use real name and phone number!",
    "gid": 1
  },
  {
    "name": "開心家族",
    "region": "北台灣",
    "managers": [200,103],
    "members": [201,202,203,104],
    "remarks": "Happy golfing!",
    "gid": 2
  }
};

Future <String>? groupName(int gid) {
  var res;
  return FirebaseFirestore.instance.collection('GolferClubs')
    .where('gid', isEqualTo: gid)
    .get().then((value) {
      value.docs.forEach((result) {
          var items = result.data();
          res = items['Name'];
      });
      return res;
    });
}

Future<bool> isMember(int gid, int uid) {
  bool res = false;
  return FirebaseFirestore.instance.collection('GolferClubs')
    .where('gid', isEqualTo: gid)
    .get().then((value) {
      value.docs.forEach((result) {
          var items = result.data();
          res = (items['members'] as List).indexOf(uid) >= 0 ? true : false;
      });
      return res;
    });
}

void addMember(int gid, int uid) {
  FirebaseFirestore.instance.collection('GolferClubs')
    .where('gid', isEqualTo: gid)
    .get().then((value) {
      value.docs.forEach((result) {
          var members = result.data()['members'] as List;
          members.add(uid);
          FirebaseFirestore.instance.collection('GolferClubs').doc(result.id).update({'members': members});
      });
    });
}

Future<bool> isManager(int gid, int uid) {
  bool res = false;
  return FirebaseFirestore.instance.collection('GolferClubs')
    .where('gid', isEqualTo: gid)
    .get().then((value) {
      value.docs.forEach((result) {
          var items = result.data();
          res = (items['managers'] as List).indexOf(uid) >= 0 ? true : false;
      });
      return res;
    });

}

void addManager(int gid, int uid) {
  FirebaseFirestore.instance.collection('GolferClubs')
    .where('gid', isEqualTo: gid)
    .get().then((value) {
      value.docs.forEach((result) {
//          var items = result.data();
//          (items['managers'] as List<int>).add(uid);
          result.data().update('managers', (value) => (value as List).add(uid));
      });
    });
}

var golfers = {
  {
    "name": "Alex Lu",
    "phone": "0988173018",
    "sex": 1,
    "uid": 104
  },
  {
    "name": "鄭永發",
    "phone": "0988173018",
    "sex": 1,
    "uid": 100
  },
  {
    "name": "Richard Hsu",
    "phone": "0988173018",
    "sex": 1,
    "uid": 200
  },
  {
    "name": "Levis Lu",
    "phone": "0988173018",
    "sex": 1,
    "uid": 101
  },
  {
    "name": "Roger Chen",
    "phone": "0988173018",
    "sex": 1,
    "uid": 102
  },
  {
    "name": "Aice Wu",
    "phone": "0988173018",
    "sex": 2,
    "uid": 201
  },
  {
    "name": "Marry Chang",
    "phone": "0988173018",
    "sex": 2,
    "uid": 202
  },
  {
    "name": "朱唯中",
    "phone": "0988173018",
    "sex": 1,
    "uid": 103
  },
};

Future <String>? golferName(int uid) {
  var res;
  return FirebaseFirestore.instance.collection('Golfers')
    .where('uid', isEqualTo: uid)
    .get().then((value) {
      value.docs.forEach((result) {
          var items = result.data();
          res = items['name'];
      });
      return res;
    });
}

Future <String>? golferNames(List uids) async {
  var res;
  return await FirebaseFirestore.instance.collection('Golfers')
    .where('uid', whereIn: uids)
    .get().then((value) {
      value.docs.forEach((result) {
          var items = result.data();
          res = res == null ? items['name'] : res + ', ' + items['name'];
      });
      return res;
    });
}

/*
String? golferNames(List uids) {
  var result, name;
  print(uids);
  uids.forEach((element) async {
      name = await golferName(element as int)!; 
      result = result == null ? name : result + ', ' + name;
//      print(result);
  });
  return result?? 'NoBody';
}
*/
var groupActivities = {
  {
    "gid": 2,
    "cid": 100,
    "tee off": "2022/3/12 7:00",
    "fee": 2500,
    "max": 40,
    "golfers": [
      {
        "uid": 100,
        "appTime": "2022/3/3 14:20",
        "scores": []
      },
      {
        "uid": 104,
        "appTime": "2022/3/3 14:25",
        "scores": []
      },
      {
        "uid": 201,
        "appTime": "2022/3/3 14:30",
        "scores": []
      },
      {
        "uid": 200,
        "appTime": "2022/3/3 14:30",
        "scores": []
      },
      {
        "uid": 202,
        "appTime": "2022/3/3 14:30",
        "scores": []
      }
    ]
  }
};

var golferActivities = {
  {
    "uid": 103,
    "cid": 102,
    "tee off": "2022-03-16 6:30",
    "fee": 2500,
    "max": 4,
    "golfers": [
      {
        "uid": 103,
        "appTime": "2022-03-03 14:20:00",
        "scores": []
      },
      {
        "uid": 200,
        "appTime": "2022-03-03 14:20:00",
        "scores": []
      },
      {
        "uid": 201,
        "appTime": "2022-03-03 14:20:00",
        "scores": []
      },
      {
        "uid": 202,
        "appTime": "2022/3/3 14:30",
        "scores": []
      },
    ]
  },
};

var golfCourses = {
  {
    "cid": 1170992729,
    "name": "再興高爾夫",
    "region": "湖口",
    "location": "",
    "photo": "https://tse1.mm.bing.net/th?id=OIP.Y9Lbd_JqVsv5PvgHRF3pRwHaFj&pid=Api&P=0&w=211&h=158",
    "zones": [
      {
        "name": "out",
        "holes": [4, 4, 3, 5, 5, 4, 3, 5, 3]
      },
      {
        "name": "in",
        "holes": [4, 5, 4, 3, 4, 4, 3, 5, 4]
      }
    ]
  },
  {
    "cid": 1170659463,
    "name": "新豐高爾夫",
    "region": "新豐",
    "location": "",
    "photo": "http://www.seec.com.tw/UpFiles/10/Messagess00_Pics655621715431517576/group_03.jpg",
    "zones": [
      {
        "name": "East",
        "holes": [4,3, 4, 4, 5, 4, 4, 3, 5]
      },
      {
        "name": "Center",
        "holes": [5, 4, 4, 3, 4, 4, 5, 3, 4]
      },
      {
        "name": "West",
        "holes": [4, 4, 3, 4, 5, 3, 4, 4, 5]
      }
    ]
  },
  {
    "cid": 1171137337,
    "name": "東方之星高爾夫",
    "region": "頭份",
    "location": "",
    "photo": "https://e.share.photo.xuite.net/p0932050326/1e69282/12907965/653482181_m.jpg",
    "zones": [
      {
        "name": "out",
        "holes": [5, 4, 4, 3, 5, 4, 4, 3, 4]
      },
      {
        "name": "in",
        "holes": [5, 4, 3, 4, 5, 4, 3, 4, 4]
      }
    ]
  },
};

/*
String? courseName(int cid) {
  var result = '';
  for (var e in golfCourses) 
    if (e["cid"] == cid) 
      return (e["region"] as String) + ' ' + (e["name"] as String);
  return result;
}
*/
Future <String>? courseName(int cid) {
  var res;
  return FirebaseFirestore.instance.collection('GolfCourses')
    .where('cid', isEqualTo: cid)
    .get().then((value) {
      value.docs.forEach((result) {
          var items = result.data();
          res = items['region'] + ' ' + items['name'];
      });
      return res;
    });
}
/*
String? coursePhoto(int cid) {
  var result = 'https://images.unsplash.com/photo-1623567341691-1f47b5cf949e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=876&q=80';
  for (var e in golfCourses) 
    if (e["cid"] == cid) 
      return (e["photo"] as String);
  return result;
}
*/
Future <String>? coursePhoto(int cid) {
  var res;
  return FirebaseFirestore.instance.collection('GolfCourses')
    .where('cid', isEqualTo: cid)
    .get().then((value) {
      value.docs.forEach((result) {
          var items = result.data();
          res = items['photo'];
      });
      return res;
    });
}

Future <int> isApplying(int gid, int uid) {
  int res = 0;
  return FirebaseFirestore.instance.collection('ApplyQueue')
    .where('gid', isEqualTo: gid)
    .where('uid', isEqualTo: uid)
    .get().then((value) {
      value.docs.forEach((result) {
        var items = result.data();
        if (items['response']  == 'waiting')
          res = 1;
        else if (items['response'] == 'No')
          res = -1;
      }
    );
    return res;
  });
}