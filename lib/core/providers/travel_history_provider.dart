import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tuk_gen/core/models/client.dart';
import 'package:tuk_gen/core/models/driver.dart';
import 'package:tuk_gen/core/models/travel_history.dart';
import 'package:tuk_gen/core/providers/driver_provider.dart';

import 'client_provider.dart';

class TravelHistoryProvider {

  CollectionReference _ref;

  TravelHistoryProvider() {
    _ref = FirebaseFirestore.instance.collection('TravelHistory');
  }

  Future<String> create(TravelHistory travelHistory) async {
    String errorMessage;

    try {
      String id = _ref.doc().id;
      travelHistory.id = id;

      await _ref.doc(travelHistory.id).set(travelHistory.toJson()); // ALMACENAMOS LA INFORMACION
      return id;
    } catch(error) {
      errorMessage = error.code;
    }

    if (errorMessage != null) {
      return Future.error(errorMessage);
    }
  }

  Future<List<TravelHistory>> getByIdClient(String idClient) async {
    QuerySnapshot querySnapshot = await _ref.where('idClient', isEqualTo: idClient).orderBy('timestamp', descending: true).get();
    List<Map<String, dynamic>> allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    List<TravelHistory> travelHistoryList = new List();

    for (Map<String, dynamic> data in allData) {
      travelHistoryList.add(TravelHistory.fromJson(data));
    }

    for (TravelHistory travelHistory in travelHistoryList) {
      DriverProvider driverProvider = new DriverProvider();
      Driver driver = await driverProvider.getById(travelHistory.idDriver);
      travelHistory.nameDriver = driver.username;
    }

    return travelHistoryList;
  }
  Future<List<TravelHistory>> getByIdDriver(String idDriver) async {
    print("getByIdDriver");
    QuerySnapshot querySnapshot = await _ref.where('idDriver', isEqualTo: idDriver).orderBy('timestamp', descending: true).get();
    List<Map<String, dynamic>> allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    List<TravelHistory> travelHistoryList = new List();

    for (Map<String, dynamic> data in allData) {
      travelHistoryList.add(TravelHistory.fromJson(data));
    }
    /*
    for (TravelHistory travelHistory in travelHistoryList) {
      ClientProvider clientProvider = new ClientProvider();
      Client client= await clientProvider.getById(travelHistory.idDriver);
      travelHistory.nameCliente = client.username;
    }
    */
    print(travelHistoryList);
    return travelHistoryList;
  }

  Stream<DocumentSnapshot> getByIdStream(String id) {
    return _ref.doc(id).snapshots(includeMetadataChanges: true);
  }

  Future<TravelHistory> getById(String id) async {
    DocumentSnapshot document = await _ref.doc(id).get();

    if (document.exists) {
      TravelHistory client = TravelHistory.fromJson(document.data());
      return client;
    }

    return null;
  }

  Future<void> update(Map<String, dynamic> data, String id) {
    return _ref.doc(id).update(data);
  }

  Future<void> delete(String id) {
    return _ref.doc(id).delete();
  }

}