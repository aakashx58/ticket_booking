import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/errors/failures.dart';
import '../../core/constants/app_constants.dart';
import '../models/auth_models.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveTokens(AuthResponse authResponse);
  Future<void> saveAccessToken(String token);
  Future<void> saveRefreshToken(String token);
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<void> saveUser(UserModel user);
  Future<UserModel?> getUser();
  Future<void> clearAll();
  Future<bool> isLoggedIn();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences _prefs;
  final FlutterSecureStorage _secureStorage;

  AuthLocalDataSourceImpl(this._prefs, this._secureStorage);

  @override
  Future<void> saveTokens(AuthResponse authResponse) async {
    await _secureStorage.write(
      key: AppConstants.accessTokenKey,
      value: authResponse.accessToken,
    );
    await _secureStorage.write(
      key: AppConstants.refreshTokenKey,
      value: authResponse.refreshToken,
    );
    await _prefs.setBool(AppConstants.isLoggedInKey, true);
  }

  @override
  Future<void> saveAccessToken(String token) async {
    await _secureStorage.write(key: AppConstants.accessTokenKey, value: token);
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    await _secureStorage.write(key: AppConstants.refreshTokenKey, value: token);
  }

  @override
  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: AppConstants.accessTokenKey);
  }

  @override
  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: AppConstants.refreshTokenKey);
  }

  @override
  Future<void> saveUser(UserModel user) async {
    await _prefs.setString(AppConstants.userIdKey, user.id);
    await _prefs.setString(AppConstants.userEmailKey, user.email);
    await _prefs.setString(AppConstants.userNameKey, user.name);
  }

  @override
  Future<UserModel?> getUser() async {
    final id = _prefs.getString(AppConstants.userIdKey);
    final email = _prefs.getString(AppConstants.userEmailKey);
    final name = _prefs.getString(AppConstants.userNameKey);
    
    if (id != null && email != null && name != null) {
      return UserModel(
        id: id,
        email: email,
        name: name,
        isEmailVerified: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
    return null;
  }

  @override
  Future<void> clearAll() async {
    await _secureStorage.delete(key: AppConstants.accessTokenKey);
    await _secureStorage.delete(key: AppConstants.refreshTokenKey);
    await _prefs.remove(AppConstants.userIdKey);
    await _prefs.remove(AppConstants.userEmailKey);
    await _prefs.remove(AppConstants.userNameKey);
    await _prefs.setBool(AppConstants.isLoggedInKey, false);
  }

  @override
  Future<bool> isLoggedIn() async {
    return _prefs.getBool(AppConstants.isLoggedInKey) ?? false;
  }
}