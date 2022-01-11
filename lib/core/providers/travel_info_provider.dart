import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tuk_gen/core/models/travel_info.dart';

class TravelInfoProvider {

  CollectionReference _ref;

  TravelInfoProvider() {
    _ref = FirebaseFirestore.instance.collection('TravelInfo');
  }

  Stream<DocumentSnapshot> getByIdStream(String id) {
    return _ref.doc(id).snapshots(includeMetadataChanges: true);
  }

  Future<TravelInfo> getById(String id) async {
    DocumentSnapshot document = await _ref.doc(id).get();

    if (document.exists) {

      TravelInfo travelInfo = TravelInfo.fromJson(document.data());
      return travelInfo;
    }

    return null;
  }

  Future<String> create(TravelInfo travelInfo) async {
    String errorMessage;

    try {
      String id = _ref.doc().id;
      travelInfo.id=id;
      await _ref.doc(travelInfo.id).set(travelInfo.toJson());
      return id;
    } catch(error) {
      errorMessage = error.code;
    }

    if (errorMessage != null) {
      return Future.error(errorMessage);
    }
  }

  Future<void> update(Map<String, dynamic> data, String id) {
    return _ref.doc(id).update(data);
  }

}