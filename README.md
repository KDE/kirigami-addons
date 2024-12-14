<!--
SPDX-FileCopyrightText: 2019 David Edmundson <kde@davidedmundson.co.uk>
SPDX-FileCopyrightText: 2020 Nicolas Fella <nicolas.fella@gmx.de>
SPDX-License-Identifier: CC-BY-SA-4.0
-->

Kirigami Addons is an additional set of visual components that work well on mobile and desktop and are guaranteed to be cross-platform. It uses Kirigami under the hood to create its components and should look native with any QtQuick Controls style.

* [API Documentation](https://api.kde.org/kirigami-addons/html/index.html)
* [Tutorial](https://develop.kde.org/docs/getting-started/kirigami/formcard-intro/)

## Structure

The [examples/](examples) folder contains full project examples that can be built individually using `-DBUILD_EXAMPLES=ON`. Each project can be built with a CMake target available in the [CMakeLists.txt](examples/CMakeLists.txt), e.g. `cmake --build build/ --target mobile-about`. Some examples, such as [MobileFormTutorial](examples/MobileFormTutorial), are used for the Kirigami tutorial.

The [autotests/](autotests) folder contains tests done at build time.

The [tests/](tests) folder contains individual QML files used for testing. It also serves as an up-do-date showcase of existing components.

The [src/components/](src/components) folder contains minor standalone components.

The [src/dateandtime/](src/dateandtime) folder contains ready-to-use time components.

The [src/delegates/](src/delegates) folder contains base delegates to be used in ListViews following the Kirigami Addons style.

The [src/formcard/](src/mobileform) folder contains components used to create your own About and Settings pages. They are ready to use and extensible. It depends on [Ki18n](https://api.kde.org/frameworks/ki18n/html/index.html).

The [src/settings/](src/settings) folder contains categorized settings components, visually similar to the categorized sidebar of [Plasma System Settings](https://invent.kde.org/plasma/systemsettings).

The [src/sounds/](src/sounds) folder contains a ready-to-use sound picker for picking ringtones and notifications.

The [src/treeview/](src/treeview) folder contains a ready-to-use Tree View implementation in QML. Note that Qt has a new [TreeView](https://doc.qt.io/qt-6/qml-qtquick-treeview.html) QML type available since Qt 6.4.

## Scope

Kirigami Addons must follow these rules:

- It must be cross-platform: depending on other KDE Frameworks libraries is fine, but it must still work on Android. Components can use platform specializations, for example native dialogs, but a generic implementation for all platforms must exist.

- Components must be grouped according to topic: for example, "dateandtime" or "chat". Each group should have its own source directory and QML import name. The name should follow the scheme of "org.kde.kirigamiaddons.topic", for example: "org.kde.kirigamiaddons.dateandtime".

- All user-exposed QML items should have an examples implemented in the tests folder, not necessarily in a separate file.

In particular, Kirigami Addons is not the right place for:

- exposing non-visual QML bindings
- QML bindings for other libraries
- API for a specific platform

## Building

To build locally and use it in your application:

```bash
cmake -B build/ -DCMAKE_INSTALL_PREFIX=$HOME/kde/usr/
cmake --build build/
cmake --install build/
source build/prefix.sh
```

For development purposes, the best way to build Kirigami Addons is to [build it with kdesrc-build](https://community.kde.org/Get_Involved/development/Build_software_with_kdesrc-build).

## Contributing

Like other projects in the KDE ecosystem, contributions are welcome from all. This repository is managed
in [KDE Invent](https://invent.kde.org/libraries/kirgiami-addons), our GitLab instance.

* Want to contribute code? See the [GitLab wiki page](https://community.kde.org/Infrastructure/GitLab) for a tutorial on
  how to send a merge request.
* Reporting a bug? Please submit it on
  the [KDE Bugtracking System](https://bugs.kde.org/enter_bug.cgi?format=guided&product=kirigami-addons). Please do not
  use the Issues
  tab to report bugs.
* Is there a part of Kirigami Add-ons that's not translated? See
  the [Getting Involved in Translation wiki page](https://community.kde.org/Get_Involved/translation) to see how
  you can help translate!

If you get stuck or need help with anything at all, head over to
the [KDE New Contributors room](https://go.kde.org/matrix/#/#kde-welcome:kde.org) on Matrix. For questions about
Kirigami Add-ons, please ask in the [Kirigami room](https://go.kde.org/matrix/#/#kirigami:kde.org).
See [Matrix](https://community.kde.org/Matrix) for more details.
