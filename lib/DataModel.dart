//import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';

var golferGroup = {
  {
    "name": "麻吉 Fun Golf",
    "region": "北台灣",
    "managers": [
      100,
    ],
    "members": [
      101,
      102
    ],
    "remarks": "Please use real name and phone number!",
    "gid": 1
  },
  {
    "name": "開心家族",
    "region": "北台灣",
    "managers": [
      200,
      103
    ],
    "members": [
      201,
      202,
      203,
      104
    ],
    "remarks": "Happy golfing!",
    "gid": 2
  }
};

bool isMember(int gid, int uid) {
  for (var e in golferGroup) 
    if (e["gid"] == gid) 
      for (var id in e["members"] as List<int>)
        if (id == uid)
          return true;
  return false;
}

bool isManager(int gid, int uid) {
  for (var e in golferGroup) 
    if (e["gid"] == gid) 
      for (var id in e["managers"] as List<int>)
        if (id == uid)
          return true;
  return false;
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
    "name": "John Chu",
    "phone": "0988173018",
    "sex": 1,
    "uid": 103
  },
};

String? golferNames(List<int> uids) {
  var result = '';
  for (var uid in uids)
    for (var e in golfers)
      if (e["uid"] == uid) {
        result += e["name"] as String;
        result += ', ';
      }
  return result.substring(0, result.length > 2 ? result.length - 2 : result.length);
}

var groupActivities = {
  {
    "gid": 1,
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
      }
    ]
  }
};

var golferActivities = {
  {
    "uid": 1,
    "cid": 102,
    "tee off": "2022/3/16 6:30",
    "fee": 2500,
    "max": 4,
    "golfers": [
      {
        "uid": 100,
        "appTime": "2022/3/3 14:20",
        "scores": []
      },
      {
        "uid": 200,
        "appTime": "2022/3/3 14:20",
        "scores": []
      },
      {
        "uid": 201,
        "appTime": "2022/3/3 14:20",
        "scores": []
      },
    ]
  },
};

var golfCourses = {
  {
    "cid": 100,
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
    "cid": 101,
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
    "cid": 102,
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
  var result = '';
  for (var e in golfCourses) 
    if (e["cid"] == cid) 
      return (e["photo"] as String);
  return result;
}

var applyQueue = {
  {
    "uid": 100,
    "gid": 1,
    "response": "No"
  }
};

bool isApplying(int gid, int uid)
{
  for (var ap in applyQueue) {
    if (((ap["uid"] as int) == uid) && ((ap["gid"] as int) == gid))
      return true;
  }
  return false;
}