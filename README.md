# Sudoku

Simple sudoku with recursive generation algorithm done in flutter, using bloc architecture.
Game is tested for android and web, but should work aswell on IOS, i've tried to use plugins that work on all platforms/make code that allows me to use proper implementations based on current platform (i.e. saving progress) [provider](https://pub.dev/packages/provider) and [rxdart](https://pub.dev/packages/rxdart).

## TODO

- Tips ✅
- Undo ✅
- Responsive layout, for web, phones and tablets ✅
- Save board on page refresh on web
- Make keyboard work on web (works currently only on Android, on IOS should too but I'm not able to test It) ✅

## Screenshots

### Android

- Main Menu

![](./screenshots/android/main_menu.png)

- Select Difficulty Dialog

![](./screenshots/android/select_diff.png)

- Game

![](./screenshots/android/game.png)

### WEB

- Main Menu

![](./screenshots/web/main_menu.png)

- Select Difficulty Dialog

![](./screenshots/web/select_diff.png)

- Game

![](./screenshots/web/game.png)
