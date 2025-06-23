import 'dart:math';
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/player_stats.dart';
import '../services/firebase_service.dart';
import '../widgets/identicon_avatar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  final TextEditingController _nameController = TextEditingController();
  PlayerStats? _stats;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    final stats = await _firebaseService.loadPlayerStats();
    if (mounted) {
      setState(() {
        _stats = stats;
        _nameController.text = stats.playerName;
        _isLoading = false;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (_stats == null) return;

    final newName = _nameController.text.trim();
    if (newName.isEmpty) return;

    setState(() => _isLoading = true);
    _stats!.playerName = newName;

    // ИСПРАВЛЕНИЕ: Вызываем правильный метод `savePlayerProfile`
    await _firebaseService.savePlayerProfile(_stats!);

    if (mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.profileSaved)),
      );
      _loadProfile();
    }
  }

  void _changeAvatar() async {
    if (_stats == null) return;
    setState(() {
      _stats!.avatarId = Random().nextInt(10000);
    });
    await _saveProfile();
  }

  // ... (остальной код виджета без изменений)
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profile),
        backgroundColor: Colors.transparent,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _stats == null
          ? Center(child: Text('Не удалось загрузить профиль'))
          : ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildProfileHeader(l10n),
          const SizedBox(height: 24),
          _buildStatsCard(l10n),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(AppLocalizations l10n) {
    return Column(
      children: [
        GestureDetector(
          onTap: _changeAvatar,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              IdenticonAvatar(text: _stats!.playerName, seed: _stats!.avatarId, size: 100),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.refresh, size: 20, color: Colors.white),
              )
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: TextField(
                controller: _nameController,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  hintText: l10n.enterYourName,
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveProfile,
            ),
          ],
        ),
        Text('${l10n.playerLevel}: ${_stats!.level}', style: TextStyle(color: Colors.white70)),
      ],
    );
  }

  Widget _buildStatsCard(AppLocalizations l10n) {
    final playtime = Duration(seconds: _stats!.totalPlaytimeSeconds);
    final playtimeFormatted = "${playtime.inHours}h ${playtime.inMinutes.remainder(60)}m";

    return Card(
      color: Theme.of(context).cardColor.withOpacity(0.5),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.statistics, style: Theme.of(context).textTheme.titleLarge),
            const Divider(height: 24),
            _buildStatRow(l10n.gamesPlayed, '${_stats!.gamesPlayed}'),
            _buildStatRow(l10n.totalPlaytime, playtimeFormatted),
            const Divider(height: 24),
            Text(l10n.tetrisStats, style: Theme.of(context).textTheme.titleMedium),
            _buildStatRow(l10n.highScore, '${_stats!.tetrisHighScore}'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.white70)),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
