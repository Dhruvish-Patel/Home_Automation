import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:home_automation/models/user_data.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "user.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE User(id INTEGER PRIMARY KEY, email TEXT, password TEXT, name Text, city Text, mobile Text, address Text)");
//    await db.execute(
//        "CREATE TABLE Home(id INTEGER PRIMARY KEY, email TEXT, homeName TEXT)");
//    await db.execute(
//        "CREATE TABLE Room(id INTEGER PRIMARY KEY, email TEXT, homeID INTEGER, roomName TEXT)");
//    await db.execute(
//        "CREATE TABLE Hardware(id INTEGER PRIMARY KEY, email TEXT, homeID INTEGER, roomID INTEGER, hwName TEXT, hwSeries Text, hwIP Text)");
//    await db.execute(
//        "CREATE TABLE Device(id INTEGER PRIMARY KEY, email TEXT, homeID INTEGER, roomID INTEGER, hwID INTEGER, dvName TEXT, dvPort Text, dvImg Text, dvStatus INTEGER)");
//    await db.execute(
//        "CREATE TABLE DeviceSlider(id INTEGER PRIMARY KEY, email TEXT, dvID INTEGER, value INTEGER)");
    print("Created tables");
  }

  Future<int> saveUser(User user) async {
    await this.deleteUsers();
    var dbClient = await db;
    int res = await dbClient.insert("User", user.toMap());
    return res;
  }

  Future<int> deleteUsers() async {
    var dbClient = await db;
    int res = await dbClient.delete("User");
//    await dbClient.delete("Home");
//    await dbClient.delete("Room");
//    await dbClient.delete("Hardware");
//    await dbClient.delete("Device");
//    await dbClient.delete("DeviceSlider");
    return res;
  }

  Future deleteDatabaseFile() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "user.db");
    await deleteDatabase(path);
  }

  Future<bool> isLoggedIn() async {
    var dbClient = await db;
    var res = await dbClient.query("User");
    return res.length == 1 ? true : false;
  }

  Future<String> getUser() async {
    var dbClient = await db;
    var res = await dbClient.rawQuery("SELECT * FROM User");
    if (res.length > 0) {
      return res.first['email'].toString();
    } else {
      return null;
    }
  }

  Future<User> getUserDetails() async {
    var dbClient = await db;
    var res = await dbClient.rawQuery("SELECT * FROM User");
    if (res.length == 1) {
      return User.map(res.first);
    } else {
      this.deleteUsers();
      return null;
    }
  }

  Future updateUser(User user) async {
    var dbClient = await db;
    int res = await dbClient.rawUpdate(
        "UPDATE User SET name=?,address=?,city=?,mobile=? WHERE email=?",
        [user.name, user.address, user.city, user.mobile, user.email]);
    return res;
  }

//  Future<int> saveHome(Home home) async {
//    var dbClient = await db;
//    int res = await dbClient.insert("Home", home.toMap());
//    return res;
//  }
//
//  Future<int> saveAllHome(List<Home> homeList) async {
//    var dbClient = await db;
//    int result = await dbClient.rawDelete('DELETE FROM Home');
//    int res = 0;
//    for (int i = 0; i < homeList.length; i++) {
//      result = await dbClient.insert("Home", homeList[i].toMap());
//      res += result;
//    }
//    return res;
//  }
//
//  Future<int> deleteHome(Home home) async {
//    var dbClient = await db;
//    await deleteAllRoomWith(home);
//    int res = await dbClient.rawDelete(
//        'DELETE FROM Home WHERE homeName = ? and email = ?',
//        [home.homeName, home.email]);
//    return res;
//  }
//
//  Future<String> getHome() async {
//    var dbClient = await db;
//    var res = await dbClient.rawQuery("SELECT * FROM Home");
//    if (res.length > 0) {
//      return res.first['homeName'].toString();
//    } else {
//      return null;
//    }
//  }
//
//  Future<List<Home>> getAllHome() async {
//    var dbClient = await db;
//    var res = await dbClient.rawQuery("SELECT * FROM Home");
//    if (res.length > 0) {
//      List<Home> list = new List<Home>();
//      for (int i = 0; i < res.length; i++) {
//        list.add(Home.map(res[i]));
//      }
//      return list;
//    } else {
//      return null;
//    }
//  }
//
//  Future<int> renameHome(Home home) async {
//    var dbClient = await db;
//    var res = await dbClient.rawUpdate(
//        "UPDATE Home SET homeName = ? WHERE id = ?", [home.homeName, home.id]);
//    if (res > 0) {
//      return res;
//    } else {
//      return 0;
//    }
//  }
//
//  Future<int> saveRoom(Room room) async {
//    var dbClient = await db;
//    int res = await dbClient.insert("Room", room.toMap());
//    return res;
//  }
//
//  Future<int> saveAllRoom(List<Room> roomList) async {
//    var dbClient = await db;
//    int result = await dbClient.rawDelete('DELETE FROM Room');
//    int res = 0;
//    for (int i = 0; i < roomList.length; i++) {
//      result = await dbClient.insert("Room", roomList[i].toMap());
//      res += result;
//    }
//    return res;
//  }
//
//  Future<int> deleteRoom(Room room) async {
//    await deleteAllHardwareWithRoom(room);
//    var dbClient = await db;
//    int res = await dbClient.rawDelete(
//        'DELETE FROM Room WHERE roomName = ? and homeID = ? and email = ?',
//        [room.roomName, room.homeID, room.email]);
//    return res;
//  }
//
//  Future<int> deleteAllRoomWith(Home home) async {
//    await deleteAllHardwareWithHome(home);
//    var dbClient = await db;
//    int res = await dbClient.rawDelete(
//        'DELETE FROM Room WHERE homeID = ? and email = ?',
//        [home.id, home.email]);
//    return res;
//  }
//
//  Future<String> getRoom() async {
//    var dbClient = await db;
//    var res = await dbClient.rawQuery("SELECT * FROM Room");
//    if (res.length > 0) {
//      return res.first['roomName'].toString();
//    } else {
//      return null;
//    }
//  }
//
//  Future<List<Room>> getAllRoom() async {
//    var dbClient = await db;
//    var res = await dbClient.rawQuery("SELECT * FROM Room");
//    if (res.length > 0) {
//      List<Room> list = new List<Room>();
//      for (int i = 0; i < res.length; i++) {
//        list.add(Room.map(res[i]));
//      }
//      return list;
//    } else {
//      return null;
//    }
//  }
//
//  Future<int> renameRoom(Room room) async {
//    var dbClient = await db;
//    var res = await dbClient.rawUpdate(
//        "UPDATE Room SET roomName = ? WHERE id = ?", [room.roomName, room.id]);
//    if (res > 0) {
//      return res;
//    } else {
//      return 0;
//    }
//  }
//
//  Future<int> saveHardware(Hardware hw) async {
//    var dbClient = await db;
//    int res = await dbClient.insert("Hardware", hw.toMap());
//    return res;
//  }
//
//  Future<int> saveAllHardware(List<Hardware> hwList) async {
//    var dbClient = await db;
//    int result = await dbClient.rawDelete('DELETE FROM Hardware');
//    int res = 0;
//    for (int i = 0; i < hwList.length; i++) {
//      result = await dbClient.insert("Hardware", hwList[i].toMap());
//      res += result;
//    }
//    return res;
//  }
//
//  Future<int> deleteHardware(Hardware hw) async {
//    await deleteAllDeviceWithHardware(hw);
//    var dbClient = await db;
//    int res = await dbClient.rawDelete(
//        'DELETE FROM Hardware WHERE hwName = ? and roomID = ? and homeID = ? and email = ?',
//        [hw.hwName, hw.roomID, hw.homeID, hw.email]);
//    return res;
//  }
//
//  Future<int> deleteAllHardwareWithRoom(Room room) async {
//    await deleteAllDeviceWithRoom(room);
//    var dbClient = await db;
//    int res = await dbClient.rawDelete(
//        'DELETE FROM Hardware WHERE roomID = ? and email = ?',
//        [room.id, room.email]);
//    return res;
//  }
//
//  Future<int> deleteAllHardwareWithHome(Home home) async {
//    await deleteAllDeviceWithHome(home);
//    var dbClient = await db;
//    int res = await dbClient.rawDelete(
//        'DELETE FROM Hardware WHERE homeID = ? and email = ?',
//        [home.id, home.email]);
//    return res;
//  }
//
//  Future<String> getHardware() async {
//    var dbClient = await db;
//    var res = await dbClient.rawQuery("SELECT * FROM Hardware");
//    if (res.length > 0) {
//      return res.first['hwName'].toString();
//    } else {
//      return null;
//    }
//  }
//
//  Future<List<Hardware>> getAllHardware() async {
//    var dbClient = await db;
//    var res = await dbClient.rawQuery("SELECT * FROM Hardware");
//    if (res.length > 0) {
//      List<Hardware> list = new List<Hardware>();
//      for (int i = 0; i < res.length; i++) {
//        list.add(Hardware.map(res[i]));
//      }
//      return list;
//    } else {
//      return null;
//    }
//  }
//
//  Future<int> renameHardware(Hardware hw) async {
//    var dbClient = await db;
//    var res = await dbClient.rawUpdate(
//        "UPDATE Hardware SET hwName = ?, hwSeries = ?, hwIP = ? WHERE id = ?",
//        [hw.hwName, hw.hwSeries, hw.hwIP, hw.id]);
//    if (res > 0) {
//      return res;
//    } else {
//      return 0;
//    }
//  }
//
//  Future<int> saveDevice(Device dv) async {
//    var dbClient = await db;
//    int res = await dbClient.rawInsert(
//        "INSERT INTO Device(id,email,dvName,dvPort,dvImg,dvStatus,hwID,roomID,homeID) VALUES(?,?,?,?,?,?,?,?,?)",
//        [
//          dv.id,
//          dv.email,
//          dv.dvName,
//          dv.dvPort,
//          dv.dvImg,
//          dv.dvStatus,
//          dv.hwID,
//          dv.roomID,
//          dv.homeID
//        ]);
//    return res;
//  }
//
//  Future<int> saveAllDevice(List<Device> dvList) async {
//    var dbClient = await db;
//    List<DeviceSlider> dvSliderList = new List<DeviceSlider>();
//    int result = await dbClient.rawDelete('DELETE FROM Device');
//    int res = 0;
//    for (int i = 0; i < dvList.length; i++) {
//      result = await dbClient.rawInsert(
//          "INSERT INTO Device(id,email,dvName,dvPort,dvImg,dvStatus,hwID,roomID,homeID) VALUES(?,?,?,?,?,?,?,?,?)",
//          [
//            dvList[i].id,
//            dvList[i].email,
//            dvList[i].dvName,
//            dvList[i].dvPort,
//            dvList[i].dvImg,
//            dvList[i].dvStatus,
//            dvList[i].hwID,
//            dvList[i].roomID,
//            dvList[i].homeID
//          ]);
//      if (dvList[i].deviceSlider != null) {
//        dvSliderList.add(dvList[i].deviceSlider);
//      }
//      res += result;
//    }
//    saveAllDeviceSlider(dvSliderList);
//    return res;
//  }
//
//  Future<int> saveAllDeviceSlider(List<DeviceSlider> dvSliderList) async {
//    var dbClient = await db;
//    int res = 0;
//    int result = await dbClient.rawDelete('DELETE FROM DeviceSlider');
//    for (int i = 0; i < dvSliderList.length; i++) {
//      result = await dbClient.insert("DeviceSlider", dvSliderList[i].toMap());
//      res += result;
//    }
//    return res;
//  }
//
//  Future<int> saveDeviceSlider(DeviceSlider dvSlider) async {
//    var dbClient = await db;
//    int res = await dbClient.insert("DeviceSlider", dvSlider.toMap());
//    return res;
//  }
//
//  Future<int> deleteDevice(Device dv) async {
//    var dbClient = await db;
//    int res =
//        await dbClient.rawDelete('DELETE FROM Device WHERE id = ?', [dv.id]);
//    await deleteDeviceSlider(dv.id);
//    return res;
//  }
//
//  Future<int> deleteDeviceSlider(int dvID) async {
//    var dbClient = await db;
//    int res = await dbClient
//        .rawDelete('DELETE FROM DeviceSlider WHERE dvID = ?', [dvID]);
//    return res;
//  }
//
//  Future<int> deleteAllDeviceWithHardware(Hardware hw) async {
//    var dbClient = await db;
//    int res = await dbClient.rawDelete(
//        'DELETE FROM Device WHERE hwID = ? and email = ?', [hw.id, hw.email]);
//    return res;
//  }
//
//  Future<int> deleteAllDeviceWithRoom(Room room) async {
//    var dbClient = await db;
//    int res = await dbClient.rawDelete(
//        'DELETE FROM Device WHERE roomID = ? and email = ?',
//        [room.id, room.email]);
//    return res;
//  }
//
//  Future<int> deleteAllDeviceWithHome(Home home) async {
//    var dbClient = await db;
//    int res = await dbClient.rawDelete(
//        'DELETE FROM Device WHERE homeID = ? and email = ?',
//        [home.id, home.email]);
//    return res;
//  }
//
//  Future<String> getDevice() async {
//    var dbClient = await db;
//    var res = await dbClient.rawQuery("SELECT * FROM Device");
//    if (res.length > 0) {
//      return res.first['dvName'].toString();
//    } else {
//      return null;
//    }
//  }
//
//  Future<List<Device>> getAllDevice() async {
//    var dbClient = await db;
//    var res = await dbClient.rawQuery("SELECT * FROM Device");
//    if (res.length > 0) {
//      List<Device> list = new List<Device>();
//      for (int i = 0; i < res.length; i++) {
//        list.add(Device.map(res[i]));
//      }
//      return list;
//    } else {
//      return null;
//    }
//  }
//
//  Future<int> renameDevice(Device dv) async {
//    var dbClient = await db;
//    var res = await dbClient.rawUpdate(
//        "UPDATE Device SET dvName = ?, dvPort = ?, dvImg = ? WHERE id = ?",
//        [dv.dvName, dv.dvPort, dv.dvImg, dv.id]);
//    if (res > 0) {
//      return res;
//    } else {
//      return 0;
//    }
//  }
}
