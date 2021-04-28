import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageUtil {
  final String _authenticationTokenKey = 'authenticationToken';
  final storage = FlutterSecureStorage();

  Future<void> storeAuthenticationToken(String authenticationToken) async {
    await storage.write(
        key: _authenticationTokenKey, value: authenticationToken);
  }

  Future<String> retrieveAuthenticationToken() async {
    String value = await storage.read(key: _authenticationTokenKey);
    return value;
  }

  Future<void> removeAuthenticationToken() async {
    await storage.delete(key: _authenticationTokenKey);
  }
}
