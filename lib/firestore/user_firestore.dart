import 'package:chat_app/firestore/room_firestore.dart';
import 'package:chat_app/model/user.dart';
import 'package:chat_app/utils/shared_prefs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserFirestore {
  static final FirebaseFirestore firebaseFirestoreInstance = FirebaseFirestore.instance;
  static final _userCollection = firebaseFirestoreInstance.collection('user');

  static Future<String?> insertNewAccount() async{
    try {
      final newDoc = await _userCollection.add({
       'name':'名無し',
       'image_path':'https://www.johnnys-net.jp/material/AMIfv97WtBbOkHVVtqRdq0XKMgM1t7Nz0FH1DFJits8S1OSFojKXytIiG3HsXsQcWfFM_9qm0wCPFDXU3Qyq1o5RtxNqpc6oEb7jtUsWQpMTyzbNMz01eWeywh6vU2M-LUW_JFk_VCZCIVBJUuvb3z2y6qbEuZ5W_Sw0BgDXjhS-v6TPKXQdT81_35lWSKJ4lnsZP999STFSreaGe_69CzCk39AzQ9yMZmUrvrmQn7Eo1pcwJGQKnunv314bjgEMdJng-tbJ7OE-ATiexrgJurGjvAtdjfCcxDq8kJhhxi1u7_6xdvdLQds?c=0&m=image%2Fjpeg',
      });

      print('アカウント作成完了');
      return newDoc.id;

    } catch(e) {
      print('アカウント作成失敗 ===== $e');
      return null;
    }
  }

  static Future<void> createUser() async {
    final myUid = await insertNewAccount();
    if(myUid != null){
      await RoomFirestore.createRoom(myUid);
      await SharedPrefs.setUid(myUid);
    }
  }

  static Future<List<QueryDocumentSnapshot>?> fetchUsers() async{
    try {
      final snapshot = await _userCollection.get();

      return snapshot.docs;
    } catch(e){
      print('ユーザー情報の取得失敗 ===== $e');
      return null;
    }
  }

  static Future<User?> fetchProfile(String uid) async{
    try {
      final myProfile = await _userCollection.doc(uid).get();
      final snapshot = await _userCollection.doc(uid).get();
      User user = User(
       name: snapshot.data()!['name'],
       imagePath: snapshot.data()!['image_path'],
       uid: uid,
     );

     return user;
    } catch(e) {
      print('自分のユーザー情報の取得失敗 ----- $e');
      return null;
    }
  }
}