import 'package:cougar_app/core/services/hive_service.dart';
import 'package:cougar_app/core/services/prefs_service.dart';
import 'package:cougar_app/features/auth/data/models/user_model.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';


abstract class AuthRepository {
  Future<UserModel?> login(String email, String password);
  Future<UserModel> register(String name, String email, String password, String securityQuestion, String securityAnswer);
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
}

class AuthRepositoryImpl implements AuthRepository {
  final HiveService _hiveService;
  final PrefsService _prefsService;

  AuthRepositoryImpl(this._hiveService, this._prefsService);

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  @override
  Future<UserModel?> login(String email, String password) async {
    final box = await _hiveService.getUserBox();
    final users = box.values.cast<UserModel>();
    
    try {
      final user = users.firstWhere(
        (u) => u.email == email && u.passwordHash == _hashPassword(password),
      );
      
      // Save session token (mock token)
      await _prefsService.setToken('mock_token_${user.id}');
      return user;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<UserModel> register(String name, String email, String password, String securityQuestion, String securityAnswer) async {
    final box = await _hiveService.getUserBox();
    
    final newUser = UserModel(
      id: const Uuid().v4(),
      name: name,
      email: email,
      passwordHash: _hashPassword(password),
      securityQuestion: securityQuestion,
      securityAnswer: securityAnswer,
    );
    
    await box.put(newUser.id, newUser);
    return newUser;
  }

  @override
  Future<void> logout() async {
    await _prefsService.setToken(null);
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final token = _prefsService.token;
    if (token == null) return null;
    
    final userId = token.replaceFirst('mock_token_', '');
    final box = await _hiveService.getUserBox();
    return box.get(userId) as UserModel?;
  }
}
