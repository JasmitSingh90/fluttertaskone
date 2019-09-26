# flutter_task_one

A new Flutter project.

## Getting Started

It’s a Flutter based project which displays a few random pictures and option to play/pause music (Ringtone).
The UI gets data in the form of byte array from Android background bound services and also uses the same to play the music in the background.
Note: Implementation using only Flutter was far easier by using either Image.network, Flutter background_fetch(Package), dio 3.0.1(Package) of these but the main objective here is to display the connection between Flutter and native Android code using Method Calls.

Project Architecture:
Here Bloc pattern is implemented using RxDart to separate the UI and Business Layer. The files distribution is done in a modular way with each having its own set of:
UI file: Contains the widgets
Bloc file: Contains the business logic
Provider file: Contains the InheritedWidget - Responsible for getting access to the root widget via context
Supported files - Contains the supported widgets
The above implementation pattern can be noticed in the folders like core_module, home_module, splash_module

Note: The core module contains the files responsible for maintaining things at the Application level, making other modules to fall under it.

Apart from the above folders, the project supports App theming and Localization. It also has below folders with the described responsibilities:
 
Common: Responsible for handling common files across platforms. Currently has Constants file.
Util: Contains utility files.
Widgets: Contains custom reusable widgets.

What more could have been done?
Many more things from having separate Repository - to maintain the API calls, Model - To have business entities, Built_value to make entities immutable etc could have been done to improve it further.
