# mobi_note

## Installation

1. **Clone the repository**
   ```bash
   git clone <repository_url>
   cd <repository_name>
   ```

2. **Install dependencies**
   If the app is written in Flutter:
   ```bash
   flutter pub get
   ```

3. **Run the application**
   - On an emulator or connected device:
     ```bash
     flutter run
     ```
   - Or build an APK:
     ```bash
     flutter build apk
     ```

4. **Requirements**
   - Flutter SDK (https://flutter.dev)
   - Android Studio or VS Code (recommended for running/emulation)
   - Android device or emulator

---

## Main Screen

When you launch the app, you'll see a list of your notes and notebooks. The bottom right corner features a button to create a new note. The top bar allows you to change the theme (dark, light, easy) or reset the database (deletes all notes).

![Main screen](https://github.com/bsobocki/MobiNote/tree/master/document/images/strona_domowa.png)

### Themes

You can choose between three themes: **dark**, **light**, and **easy** (increased contrast and larger fonts).

![Theme comparison](https://github.com/bsobocki/MobiNote/tree/master/document/images/strona_domowa_motywy.png)

## Notes and Notebooks

- **Notebooks**: Button for organizing notes into notebooks (feature in development).
- **Recent Notes**: List of notes with title and content preview. Each note can be deleted or edited.

## Editing a Note

- **Top bar**: Save/back button (saves changes), title field, save option switch.
- **Toolbar**: Add images and lists.

![Note editing screen](https://github.com/bsobocki/MobiNote/tree/master/document/images/tryb_edycji.png)

- **Editor**: Edit text and widgets in real time.

## Text Formatting

- **Headings**: Markdown style – `#`, `##`, `###`, `####` at the start of a line.
- **Styles**:  
  - `*text*` – bold  
  - `^text^` – italic  
  - `_text_` – underline  
  - `~text~` – strikethrough  
- Styles can be nested, but not overlapped.

![Style example](https://github.com/bsobocki/MobiNote/tree/master/document/images/style.png)
![Raw styled text](https://github.com/bsobocki/MobiNote/tree/master/document/images/style_surowy_tekst.png)

## Widgets

- **Images**: Add from device, resize, or delete.

![Image selection mode](https://github.com/bsobocki/MobiNote/tree/master/document/images/tryb_zaznaczenia.png)

- **Lists**:  
  - Types: checkbox, numbered, with symbols, counter.
  - Add/remove rows with enter or buttons.
  - Counter: clicking increases value, goal can be edited.

![Counter in list](https://github.com/bsobocki/MobiNote/tree/master/document/images/liczniki.png)

## Additional Information

- Notes consist of text paragraphs and widgets.
- Editing and deleting paragraphs is intuitive via keyboard and gestures.
- The "easy" theme increases readability (larger fonts, higher contrast).

---

**Note:** A new note is only saved after making changes and using the back button in the top bar.

---

Let me know if you want to add more technical details or further instructions!

---

## Prepare Environment

My current environtment preparing:

- Install according to the [official website](https://docs.flutter.dev/get-started/install):
    - Flutter 
    - Android Studio
    - Android Emulator
- [Prepare Visual Studio Code](https://docs.flutter.dev/get-started/editor?tab=vscode)

## Running

Current way to run an application:
- clone this repo
- run Android Emulator (for me this is `Pixel 6 API 30`)
    to run an emulator from Windows terminal:
    you can run a new Windows Terminal and go to the sdk directory
    for me it was `C:\Users\<my_user>\AppData\Local\Android\Sdk\emulator`
    and run `emulator.exe -avd <avd_name>`
    to see available avds run `emulator.exe -list-avds`
    example:
    ```
    C:\Users\bartq\AppData\Local\Android\Sdk\emulator> .\emulator.exe -list-avds
    Pixel_6_API_30
    C:\Users\bartq\AppData\Local\Android\Sdk\emulator> .\emulator.exe -avd Pixel_6_API_30
    ```
- flutter run

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
