import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tuk_gen/core/models/client.dart';
import 'package:tuk_gen/core/models/driver.dart';

class DriverProvider {
  CollectionReference _ref;

  DriverProvider() {
    _ref = FirebaseFirestore.instance.collection('Drivers');
  }

  Future<DocumentReference> create(Driver driver) {
    try {
      return _ref.doc(driver.id).set(driver.toJson());
    } catch (error) {
      return null;
    }
  }

  Stream<DocumentSnapshot> getByIdStream(String id) {
    return _ref.doc(id).snapshots(includeMetadataChanges: true);
  }

  Future<Driver> getById(String id) async {
    DocumentSnapshot document = await _ref.doc(id).get();

    if (document.exists) {
      Driver driver = Driver.fromJson(document.data());
      return driver;
    }

    return null;
  }

  Future<void> update(Map<String, dynamic> data, String id) {
    return _ref.doc(id).update(data);
  }
}
