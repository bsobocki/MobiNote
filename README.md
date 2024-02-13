# mobi_note

A new Flutter project.

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


# TO DO

### Fix

[x] dynamically set fontSize and height of TextFields
[x] space between TextFields
[ ] adding a new TextField in the right place with paragraphDefaultFontSize

### Few Next steps:

[x] fix problem with * b o l d   ^ i t a l i c * ^
[ ] code refactor &&  add UT
[x] handle paragraphs adding
    [x] move focus to the new one
    [x] set TextField size when paragraph is header
[x] handle paragraphs removing
    [x] catch delete event (cursor on the textfield beggining)
    [x] move focus to the one above
[x] show paragraph characters on focus
[ ] handle widgets
    [x] fix database insertion bug
    [x] add/remove widgets with buttons
    [ ] remove widgets from List by deleting (remove last item -> add NoteParagraphTextEditor)
    [ ] create json with widget specification
    [ ] elements like checkbox as widget
[ ] add colors
    [ ] define hex for utf character describing colors
        \ u F [color num] - for example
