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

    // var storedData = storage.getItem(key);

    // storedData[task["id"]] = task;

    // storage.setItem(key, storedData);

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

  getUID() {
    String uid = userService.currentUserID();
    return uid;
  }

  deleteTask(String id) async {
    String uid = getUID();

    await bd.collection("users").doc(uid).collection("tasks").doc(id).delete();
  }
}
