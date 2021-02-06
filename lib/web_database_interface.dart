import 'package:firebase_core/firebase_core.dart';
import 'package:firebase/firebase.dart';
import 'package:firebase/firestore.dart';


class DatabaseInterface {
  static Firestore fsi;

  /// Creates the Firebase connection, only needed in mobile version.
  /// (The Web version is connected in the index.html file)
  initializeApp() async {
    await Firebase.initializeApp();
  }
  /// Retrieves the database instance
  void init(Function() stopLoading) {

    fsi = firestore();
    stopLoading();
  }

  /// Returns true if the Collection s, Document t is actually present in the DB
  /// Returns false otherwise
  Future<bool> exists(String s, String t) async {
    return (await fsi.collection(s).doc(t).get()).exists;

  }

  /// Sets the value at Collection s, Document t
  /// with the data contained in the Map map
  set(String s, String t, Map<String, dynamic> map) async {
    return await fsi.collection(s).doc(t).set(map);

  }

  /// Returns the data contained at Collection s, Document t
  /// The Map is not sorted, the key sorting depends on last activities
  Future<Map<String, dynamic>> read(String s, String t) async {
    return (await fsi.collection(s).doc(t).get()).data();

  }

  /// Tries to update the values listed inside map
  /// inside Collection s, Document t
  /// Throws an error if the data doesn't exist
  update(String s, String t, Map<String, dynamic> map) async {

    return fsi.collection(s).doc(t).update(data: map);

  }

  /// Tries to delete the entire Document t inside Collection s
  /// Doesn't throw an error if the data doesn't exist
  delete(String s, String t) {
    fsi.collection(s).doc(t).delete();

  }

}