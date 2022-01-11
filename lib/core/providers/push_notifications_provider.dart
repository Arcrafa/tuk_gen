import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:tuk_gen/core/providers/client_provider.dart';
import 'package:tuk_gen/core/providers/driver_provider.dart';
import 'package:http/http.dart' as http;
import 'package:tuk_gen/core/utils/shared_pref.dart';

class PushNotificationsProvider {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  //FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  StreamController _streamController = StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get message => _streamController.stream;

  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    // Si vas a utilizar otros servicios de Firebase en segundo plano, como Firestore,
    // asegúrese de llamar a `initializeApp` antes de usar otros servicios de Firebase.
    //await Firebase.initializeApp();

    print("Handling a background message: ${message.messageId}");
    _streamController.sink.add(message);
  }


  void initPushNotifications() async {

    /*_firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print('Cuando estamos en primer plano');
        print('OnMessage: $message');
        _streamController.sink.add(message);
      },
      onLaunch: (Map<String, dynamic> message) {
        print('OnLaunch: $message');
        _streamController.sink.add(message);
        SharedPref sharedPref = new SharedPref();
        sharedPref.save('isNotification', 'true');
      },
      onResume: (Map<String, dynamic> message) {
        print('OnResume $message');
        _streamController.sink.add(message);
      }
    );
    */

    _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(
        sound: true,
        badge: true,
        alert: true,
        provisional: true
      )
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        _streamController.sink.add(message);
      }
    });
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);


    /*
    _firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
      print('Coonfiguraciones para Ios fueron regustradas $settings');
    });
*/

  }

  void saveToken(String idUser, String typeUser) async {
    String token = await _firebaseMessaging.getToken();
    Map<String, dynamic> data = {
      'token': token
    };

    if (typeUser == 'client') {
      ClientProvider clientProvider = new ClientProvider();
      clientProvider.update(data, idUser);
    }
    else {
      DriverProvider driverProvider = new DriverProvider();
      driverProvider.update(data, idUser);
    }

  }

  Future<void> sendMessage(String to, Map<String, dynamic> data, String title, String body) async {
    var response =await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String> {
        'Content-Type': 'application/json',
        'Authorization': 'key=AAAA56ts4vc:APA91bFyYvbBHmJNDcBQOUA9crcocxSGg1lUelkkKNmhKN0alfMYLl03shYKW4522YTjgBriAozhjDighscX5r7qJrJ7B4Yc-YUkG9phPwf6H6Ez4jAMmSb8tEooR-N_3ehYF-GsD_1F'
      },
      body: jsonEncode(
        <String, dynamic> {
          'notification': <String, dynamic> {
            'body': body,
            'title': title,
          },
          'priority': 'high',
          'ttl': '4500s',
          'data': data,
          'to': to
        }
      )
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  void dispose () {
    _streamController?.onCancel;
  }

}