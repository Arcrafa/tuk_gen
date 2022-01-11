library tuk_gen;
import 'package:package_info/package_info.dart';
import 'package:tuk_gen/tokens/environment.dart' as env;
Future<String> getAppName() async{
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  env.appName= packageInfo.appName;
  return packageInfo.appName;
}
/// A Calculator.
class Calculator {
  /// Returns [value] plus 1.
  int addOne(int value) => value + 1;
}
