import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:localstorage/localstorage.dart';

class UserService {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore bd = FirebaseFirestore.instance;
  final LocalStorage storage = LocalStorage('id');

  Future<bool> isUserLogged() async {
    try {
      var user = auth.currentUser;
      return user != null;
    } catch (e) {
      print('Erro ao verificar usuário logado: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      var userDoc = await bd.collection("users").doc(currentUserID()).get();
      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>;
      } else {
        print('Documento do usuário não encontrado');
        return {};
      }
    } catch (e) {
      print('Erro ao obter usuário atual: $e');
      return {};
    }
  }

  String currentUserID() {
    try {
      User? user = auth.currentUser;
      return user?.uid ?? '';
    } catch (e) {
      print('Erro ao obter ID do usuário atual: $e');
      return '';
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      print('Erro ao fazer login: $e');
      return false;
    }
  }

  Future<bool> register(String email, String password, String name) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await bd.collection("users").doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
      });

      return true;
    } catch (e) {
      print('Erro ao registrar usuário: $e');
      return false;
    }
  }

  void logout() async {
    try {
      storage.clear();
      await auth.signOut();
    } catch (e) {
      print('Erro ao fazer logout: $e');
    }
  }
}
