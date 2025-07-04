import 'app_localizations.dart';

class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override String get appTitle => 'Пазл Блок';
  @override String get classic => 'Классический';
  @override String get sprint => 'Спринт (40 линий)';
  @override String get ultra => 'Ультра (2 минуты)';
  @override String get oneVsOne => '1vs1 (против Бота)';
  @override String get selectMode => 'Выберите режим';
  @override String get tetris => 'Тетрис';
  @override String get classicMode => 'Классический режим';
  @override String get snake => 'Змейка';
  @override String get comingSoon => 'Скоро...';
  @override String get score => 'СЧЕТ';
  @override String get level => 'УРОВЕНЬ';
  @override String get next => 'СЛЕДУЮЩИЙ';
  @override String get pause => 'Пауза';
  @override String get resume => 'Продолжить';
  @override String get restart => 'Заново';
  @override String get gameOver => 'КОНЕЦ ИГРЫ';
  @override String yourScore(int score) => 'СЧЕТ: $score';
  @override String get playAgain => 'ИГРАТЬ СНОВА';
  @override String get paused => 'ПАУЗА';
  @override String get backToMenu => 'Главное Меню';
  @override String get puzzleBlockClassic => 'Пазл Блок - Классический';
  @override String get highScore => 'Рекорд';
  @override String get lastScore => 'Прошлый счет';
  @override String get newHighScore => 'НОВЫЙ РЕКОРД!';
  @override String get settings => 'Настройки';
  @override String get sound => 'Звук';
  @override String get vibration => 'Вибрация';
  @override String get volume => 'Громкость';
  @override String get profile => 'Профиль';
  @override String get playerName => 'Имя игрока';
  @override String get enterYourName => 'Введите ваше имя';
  @override String get save => 'Сохранить';
  @override String get playerLevel => 'Уровень Игрока';
  @override String get statistics => 'Статистика';
  @override String get overallStats => 'Общая статистика';
  @override String get gamesPlayed => 'Сыграно игр';
  @override String get totalPlaytime => 'Общее время в игре';
  @override String get tetrisStats => 'Статистика: Тетрис';
  @override String get editProfile => 'Редактировать';
  @override String get chooseAvatar => 'Выберите аватар';
  @override String get leaderboard => 'Таблица лидеров';
  @override String get topPlayers => 'Лучшие игроки';
  @override String get logout => 'Выйти';
  @override String get loginError => 'Ошибка входа. Пожалуйста, проверьте конфигурацию и попробуйте снова.';
  @override String get welcome => 'Добро пожаловать!';
  @override String get signInWithGoogle => 'Войти через Google';
  @override String get signInWithApple => 'Войти через Apple';
  @override String get continueAsGuest => 'Продолжить как гость';
  @override String get loginSuccess => 'Вход выполнен успешно!';
  @override String get loginCancelled => 'Вход отменен.';
  @override String get profileSaved => 'Профиль сохранен!'; // Добавлено
}
