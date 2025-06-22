import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../models/player_stats.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ИСПРАВЛЕНИЕ: Ключ теперь загружается из безопасных переменных окружения.
  // Это предотвращает утечку ключа в GitHub.
  static const _webClientId = String.fromEnvironment('WEB_CLIENT_ID');

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: kIsWeb ? (_webClientId.isNotEmpty ? _webClientId : null) : null,
  );

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  String _generateNonce([int length = 32]) {
    final random = Random.secure();
    final values = List<int>.generate(length, (i) => random.nextInt(256));
    return base64Url.encode(values);
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      await _checkAndCreateUserProfile(userCredential.user);
      return userCredential.user;
    } catch (e) {
      print("Критическая ошибка входа через Google: $e");
      throw e;
    }
  }

  Future<User?> signInWithApple() async {
    try {
      final rawNonce = _generateNonce();
      final nonce = sha256.convert(utf8.encode(rawNonce)).toString();
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
        nonce: nonce,
      );
      final oauthProvider = OAuthProvider('apple.com');
      final oAuthCredential = oauthProvider.credential(
        idToken: credential.identityToken,
        rawNonce: rawNonce,
      );
      final userCredential = await _auth.signInWithCredential(oAuthCredential);
      await _checkAndCreateUserProfile(userCredential.user, appleFullName: credential.givenName);
      return userCredential.user;
    } catch (e) {
      print("Критическая ошибка входа через Apple: $e");
      throw e;
    }
  }

  Future<User?> signInAnonymously() async {
    try {
      final userCredential = await _auth.signInAnonymously();
      await _checkAndCreateUserProfile(userCredential.user);
      return userCredential.user;
    } catch(e) {
      print("Критическая ошибка анонимного входа: $e");
      throw e;
    }
  }

  Future<void> _checkAndCreateUserProfile(User? user, {String? appleFullName}) async {
    if (user == null) return;
    final docRef = _firestore.collection('players').doc(user.uid);
    final doc = await docRef.get();
    if (!doc.exists) {
      final newStats = PlayerStats(
        playerName: user.displayName ?? appleFullName ?? 'Player_${user.uid.substring(0, 5)}',
        avatarId: Random().nextInt(10000),
      );
      await docRef.set(newStats.toMap());
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  Future<PlayerStats> loadPlayerStats() async {
    final user = _auth.currentUser;
    if (user == null) return PlayerStats();
    final doc = await _firestore.collection('players').doc(user.uid).get();
    return doc.exists ? PlayerStats.fromMap(doc.data()!) : PlayerStats();
  }

  Future<void> updatePostGameStats({required int finalScore, required Duration playtime}) async {
    final user = _auth.currentUser;
    if (user == null) return;
    final docRef = _firestore.collection('players').doc(user.uid);
    return _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) { return; }
      final currentStats = PlayerStats.fromMap(snapshot.data()! as Map<String, dynamic>);

      currentStats.gamesPlayed += 1;
      currentStats.totalPlaytimeSeconds += playtime.inSeconds;
      currentStats.totalXp += finalScore;
      currentStats.level = (currentStats.totalXp ~/ 1000) + 1;

      if (finalScore > currentStats.tetrisHighScore) {
        currentStats.tetrisHighScore = finalScore;
      }
      transaction.update(docRef, currentStats.toMap());
    });
  }

  // ИСПРАВЛЕНИЕ: Переименовано с savePlayerProfile на savePlayerStats
  Future<void> savePlayerStats(PlayerStats stats) async {
    final user = _auth.currentUser;
    if (user == null) return;
    await _firestore.collection('players').doc(user.uid).set(stats.toMap(), SetOptions(merge: true));
  }

  Future<List<PlayerStats>> getLeaderboard() async {
    final snapshot = await _firestore
        .collection('players')
        .orderBy('tetrisHighScore', descending: true)
        .limit(100)
        .get();
    return snapshot.docs.map((doc) => PlayerStats.fromMap(doc.data())).toList();
  }
}
