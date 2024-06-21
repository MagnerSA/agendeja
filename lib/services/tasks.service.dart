import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:localstorage/localstorage.dart';

import 'user.service.dart';

class TaskService {
  FirebaseFirestore bd = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  UserService userService = UserService();

  final LocalStorage storage = LocalStorage('id');

  final key = "tasks";

  createTask(Map<String, dynamic> task) async {
    // await storage.ready;
    String uid = getUID();

    await bd
        .collection("users")
        .doc(uid)
        .collection("tasks")
        .doc(task["id"])
        .set(task);
  }

  editTask(Map<String, dynamic> task) async {
    String uid = getUID();

    await bd
        .collection("users")
        .doc(uid)
        .collection("tasks")
        .doc(task["id"])
        .update(task);
  }

  getTasks() async {
    Map<String, Map<String, dynamic>> data = {};
    await storage.ready;

    var storedData = storage.getItem(key);

    if (storedData == null) {
      var collection =
          await bd.collection("users").doc(getUID()).collection(key).get();

      for (var doc in collection.docs) {
        data[doc.data()["id"]] = doc.data();
      }

      storage.setItem(key, data);
    } else {
      storedData.forEach((key, value) {
        data[key] = value;
      });
    }
    return data;

    // String uid = _getUID();

    // var collection =
    //     await bd.collection("users").doc(uid).collection("tasks").get();
    // List<Map<String, dynamic>> tasks = [];

    // for (var doc in collection.docs) {
    //   Map<String, dynamic> task = doc.data();
    //   tasks.add(task);
    // }

    // return tasks;
  }

  updateLateTasks() async {
    DateTime today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    var collection =
        await bd.collection("users").doc(getUID()).collection("tasks").get();
    //     // .where("date", isLessThan: Timestamp.fromDate(now))
    //     // .where("checked", isEqualTo: false)

    for (var doc in collection.docs) {
      if (doc.data()["checked"] == false) {
        DateTime taskDate = DateTime.parse(doc.data()["date"]);

        if (DateTime.parse((doc.data()["date"])).isBefore(today)) {
          print("UMA");
          await bd
              .collection("users")
              .doc(getUID())
              .collection("tasks")
              .doc(doc.id)
              .update(
            {
              "date": today.toString(),
            },
          );
        }
      }
      // print('Data: ${doc.data()["date"]}');
      // print('Checked: ${doc.data()["checked"]}');
      // print('-------------------');
    }

    // var collection = await bd.collection("users").doc(getUID()).get();

    // String lastUpdateString = collection.data()?["lastUpdate"] ?? "";

    // if (lastUpdateString == "") {
    //   await bd
    //       .collection("users")
    //       .doc(getUID())
    //       .update({"lastUpdate": today.toString()});
    // } else {
    //   if (!DateTime.parse(lastUpdateString).isAtSameMomentAs(today)) {
    //     print("É HOJE");
    //   }
    // }
  }

  _realocateLateTasks() async {}

  getUID() {
    String uid = userService.currentUserID();
    return uid;
  }

  deleteTask(String id) async {
    String uid = getUID();

    await bd.collection("users").doc(uid).collection("tasks").doc(id).delete();
  }
}
