import 'dart:collection';

import '../services/db_interface_stub.dart'
    if (dart.library.io) '../services/database_interface.dart'
    if (dart.library.html) '../services/web_database_interface.dart';

import 'package:flutter/material.dart';

import '../loading_state_helper.dart';

class DataRepository {
  late DatabaseInterface _database;

  DataRepository(finishCallback) {
    _database = DatabaseInterface();
    init(finishCallback);
  }

  init(Function finishCallback) async {
    await _database.init();
    finishCallback();
  }

  listen(String s, Function(dynamic) manageEvent) {
    return _database.listen(s, manageEvent);
  }

  void createData(
    String folder,
    String record,
    Map<String, dynamic> data,
    String successString,
    String errorString,
    LoadingStateHelper helper,
    Function refreshCallback,
    Function showMessage,
    Function noConnectivityCallback,
  ) async {
    helper.startLoading(refreshCallback);
    try {
      bool exists = await _database.exists(folder, record);
      if (exists) {
        showMessage('ERROR', errorString, 'Awww...', Colors.red);
      } else {
        await _database.set(
          'users',
          'testUser',
          data,
        );

        showMessage('Success!', successString, 'Ok!', Colors.black);
      }
    } catch (e) {
      if (e.toString().startsWith('[cloud_firestore/unavailable]')) {
        noConnectivityCallback();
      }
    }

    helper.stopLoading(refreshCallback);
  }

  void readData(
    String folder,
    String record,
    String successString,
    String errorString,
    LoadingStateHelper helper,
    Function refreshCallback,
    Function showMessage,
    Function noConnectivityCallback,
  ) async {
    helper.startLoading(refreshCallback);
    try {
      Map<String, dynamic>? rec = await _database.read(folder, record);

      if (rec == null) {
        //can only happen on mobile version
        showMessage('Error', 'ERROR ON READ, THE RECORD WAS NOT FOUND', 'What a pity...', Colors.red);
      } else {
        SplayTreeMap<String, dynamic> record = SplayTreeMap.from(rec);
        showMessage('Success!', '$successString: $record', 'Got it!', Colors.black);
      }
    } catch (e) {
      if (e.toString().startsWith('[cloud_firestore/unavailable]')) {
        noConnectivityCallback();
      } else {
        showMessage('Error', errorString, 'What a pity...', Colors.red);
      }
    }
    helper.stopLoading(refreshCallback);
  }

  void updateData(
    String folder,
    String record,
    Map<String, dynamic> data,
    String successString,
    String errorString,
    LoadingStateHelper helper,
    Function refreshCallback,
    Function showMessage,
    Function noConnectivity,
  ) async {
    helper.startLoading(refreshCallback);

    try {
      _database.update(folder, record, data).then((_) {
        showMessage('Success!', successString, 'Ok, thank you!', Colors.black);
        helper.stopLoading(refreshCallback);
      }).catchError((e) {
        if ((e.toString().startsWith("[cloud_firestore/not-found]")) ||
            (e.toString().startsWith("FirebaseError: Requested entity was not found"))) {
          showMessage('ERROR', errorString, 'Cannot update? WTF!', Colors.red);
        } else {
          showMessage('ERROR', 'Error on update:${e.toString()}', 'Ok', Colors.red);
        }
        helper.stopLoading(refreshCallback);
      });
    } catch (e) {
      if (e.toString().startsWith('[cloud_firestore/unavailable]')) {
        noConnectivity();
      }
      helper.stopLoading(refreshCallback);
    }
  }

  void deleteData(
    String folder,
    String record,
    String successString,
    String errorString,
    LoadingStateHelper helper,
    Function refreshCallback,
    Function showMessage,
    Function noConnectivity,
  ) async {
    helper.startLoading(refreshCallback);
    try {
      bool exists = await _database.exists(folder, record);

      if (!exists) {
        showMessage('ERROR', errorString, 'Can`t I delete the void?', Colors.red);
      } else {
        await _database.delete(folder, record);
        showMessage('Success!', successString, 'I will miss it!', Colors.black);
      }
    } catch (e) {
      if (e.toString().startsWith('[cloud_firestore/unavailable]')) {
        noConnectivity();
      }
    }
    helper.stopLoading(refreshCallback);
  }
}
