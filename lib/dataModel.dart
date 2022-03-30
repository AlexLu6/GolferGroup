//import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

int uuidTime() {
  return DateTime.now().millisecondsSinceEpoch - 1647000000000;
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

String? groupName(int gid) {
  FirebaseFirestore.instance.collection('GolferClubs')
    .where('gid', isEqualTo: gid)
    .get().then((value) {
      value.docs.forEach((result) {
          var items = result.data();
          return items['Name'];
      });
    });
}

bool isMember(int gid, int uid) {
  bool res = false;
  FirebaseFirestore.instance.collection('GolferClubs')
    .where('gid', isEqualTo: gid)
    .get().then((value) {
      value.docs.forEach((result) {
          var items = result.data();
          for (var id in items['members'] as List<int>)
            if (id == uid)
              res = true;
      });
    });
  return res;
}

void addMember(int gid, int uid) {
  FirebaseFirestore.instance.collection('GolferClubs')
    .where('gid', isEqualTo: gid)
    .get().then((value) {
      value.docs.forEach((result) {
//          var items = result.data();
//          (items['members'] as List<int>).add(uid);
          result.data().update('members', (value) => (value as List<int>).add(uid));
      });
    });
}

bool isManager(int gid, int uid) {
  bool res = false;
  FirebaseFirestore.instance.collection('GolferClubs')
    .where('gid', isEqualTo: gid)
    .get().then((value) {
      value.docs.forEach((result) {
          var items = result.data();
          for (var id in items['managers'] as List<int>)
            if (id == uid)
              res = true;
      });
    });
  return res;
}

void addManager(int gid, int uid) {
  FirebaseFirestore.instance.collection('GolferClubs')
    .where('gid', isEqualTo: gid)
    .get().then((value) {
      value.docs.forEach((result) {
//          var items = result.data();
//          (items['managers'] as List<int>).add(uid);
          result.data().update('managers', (value) => (value as List<int>).add(uid));
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

String? golferName(int uid) {
  FirebaseFirestore.instance.collection('Golfers')
    .where('uid', isEqualTo: uid)
    .get().then((value) {
      value.docs.forEach((result) {
          var items = result.data();
          return items['Name'];
      });
    });
    return null;
}

String? golferNames(List<dynamic> uids) {
  var result = '';
  print(uids);
  FirebaseFirestore.instance.collection('Golfers')
    .where('uid', isEqualTo: uids[0] as int)
    .get().then((value) {
      value.docs.forEach((e) {
          var items = e.data();
          result += items['Name'] as String;
          result += ', ';
      });
    }).whenComplete(() => print(result));

  return result.substring(0, result.length > 2 ? result.length - 2 : result.length);
}

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

String? courseName(int cid) {
  var result = '';
  for (var e in golfCourses) 
    if (e["cid"] == cid) 
      return (e["region"] as String) + ' ' + (e["name"] as String);
  return result;
}

String? coursePhoto(int cid) {
  var result = 'https://images.unsplash.com/photo-1623567341691-1f47b5cf949e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=876&q=80';
  for (var e in golfCourses) 
    if (e["cid"] == cid) 
      return (e["photo"] as String);
  return result;
}

int isApplying(int gid, int uid)
{
  int res = 0;
  FirebaseFirestore.instance.collection('ApplyQueue')
    .where('gid', isEqualTo: gid)
    .where('uid', isEqualTo: uid).get().then((value) {
      value.docs.forEach((result) {
        var items = result.data();
        if (items['response']  == 'waiting')
          res = 1;
        else if (items['response'] == 'No')
          res = -1;
      });
    });
  return res;
}