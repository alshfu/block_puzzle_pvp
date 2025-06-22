import 'app_localizations.dart';

class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override String get appTitle => 'Block Puzzle';
  @override String get classic => 'Classic';
  @override String get sprint => 'Sprint (40 lines)';
  @override String get ultra => 'Ultra (2 minutes)';
  @override String get oneVsOne => '1vs1 (vs Bot)';
  @override String get selectMode => 'Select Mode';
  @override String get tetris => 'Tetris';
  @override String get classicMode => 'Classic mode';
  @override String get snake => 'Snake';
  @override String get comingSoon => 'Coming soon...';
  @override String get score => 'SCORE';
  @override String get level => 'LEVEL';
  @override String get next => 'NEXT';
  @override String get pause => 'Pause';
  @override String get resume => 'Resume';
  @override String get restart => 'Restart';
  @override String get gameOver => 'GAME OVER';
  @override String yourScore(int score) => 'SCORE: $score';
  @override String get playAgain => 'PLAY AGAIN';
  @override String get paused => 'PAUSED';
  @override String get backToMenu => 'Main Menu';
  @override String get puzzleBlockClassic => 'Block Puzzle - Classic';
  @override String get highScore => 'High Score';
  @override String get lastScore => 'Last Score';
  @override String get newHighScore => 'NEW RECORD!';
  @override String get settings => 'Settings';
  @override String get sound => 'Sound';
  @override String get vibration => 'Vibration';
  @override String get volume => 'Volume';
  @override String get profile => 'Profile';
  @override String get playerName => 'Player Name';
  @override String get enterYourName => 'Enter your name';
  @override String get save => 'Save';
  @override String get playerLevel => 'Player Level';
  @override String get statistics => 'Statistics';
  @override String get overallStats => 'Overall Stats';
  @override String get gamesPlayed => 'Games Played';
  @override String get totalPlaytime => 'Total Playtime';
  @override String get tetrisStats => 'Stats: Tetris';
  @override String get editProfile => 'Edit';
  @override String get chooseAvatar => 'Choose Avatar';
  @override String get leaderboard => 'Leaderboard';
  @override String get topPlayers => 'Top Players';
  @override String get logout => 'Sign Out';
  @override String get loginError => 'Login failed. Please check your configuration and try again.';
  @override String get welcome => 'Welcome!';
  @override String get signInWithGoogle => 'Sign in with Google';
  @override String get signInWithApple => 'Sign in with Apple';
  @override String get continueAsGuest => 'Continue as Guest';
  // ИСПРАВЛЕНИЕ: Добавлены недостающие строки
  @override String get loginSuccess => 'Login Successful!';
  @override String get loginCancelled => 'Login cancelled.';
}
