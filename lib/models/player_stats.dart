import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class PlayerStats {
  String playerName;
  int level;
  int gamesPlayed;
  int totalPlaytimeSeconds;
  int tetrisHighScore;
  int pvpWins; // Новое поле для побед в PvP
  int avatarId;
  int totalXp;

  PlayerStats({
    this.playerName = 'Player',
    this.level = 1,
    this.gamesPlayed = 0,
    this.totalPlaytimeSeconds = 0,
    this.tetrisHighScore = 0,
    this.pvpWins = 0, // Инициализация
    this.avatarId = 0,
    this.totalXp = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'playerName': playerName,
      'level': level,
      'gamesPlayed': gamesPlayed,
      'totalPlaytimeSeconds': totalPlaytimeSeconds,
      'tetrisHighScore': tetrisHighScore,
      'pvpWins': pvpWins, // Добавлено в Map
      'avatarId': avatarId,
      'totalXp': totalXp,
    };
  }

  factory PlayerStats.fromMap(Map<String, dynamic> map) {
    return PlayerStats(
      playerName: map['playerName'] ?? 'Player',
      level: map['level'] ?? 1,
      gamesPlayed: map['gamesPlayed'] ?? 0,
      totalPlaytimeSeconds: map['totalPlaytimeSeconds'] ?? 0,
      tetrisHighScore: map['tetrisHighScore'] ?? 0,
      pvpWins: map['pvpWins'] ?? 0, // Добавлено
      avatarId: map['avatarId'] ?? 0,
      totalXp: map['totalXp'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());
  factory PlayerStats.fromJson(String source) => PlayerStats.fromMap(json.decode(source));
}
