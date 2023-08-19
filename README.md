<!--
SPDX-FileCopyrightText: 2019 David Edmundson <kde@davidedmundson.co.uk>
SPDX-FileCopyrightText: 2020 Nicolas Fella <nicolas.fella@gmx.de>
SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Kirigami Addons

A set of "widgets" i.e visual end user components along with a code to support them.
Components are usable by both touch and desktop experiences providing a native experience on both,
and look native with any QQC2 style (qqc2-desktop-theme, Material or Plasma).

The API can be found in the [KDE API Reference website](https://api.kde.org/frameworks/kirigami-addons/html/index.html).

## Components

Kirigami Add-ons contains many components, which are set up like so:

* General components that don't fit anywhere else, located under [src/components](src/components).
* Date and Time components, located under [src/dateandtime](src/dateandtime).
* Delegate components, located under [src/delegates](src/delegates).
* FormCard components (formerly known as MobileForm), located under [src/formcard](src/formcard).
* Categorized Settings components, located under [src/settings](src/settings).
* Sound picker component for picking ringtones and notifications, located under [src/sounds](src/sounds).
* TreeView component, located under [src/treeview](src/treeview).

### See Also

If you can't find what you're looking for, it may exist in another repository instead:

* [Kirigami](https://invent.kde.org/frameworks/kirigami) is the QtQuick based components set that Kirigami Add-ons
  builds on top of.
* [Kirigami Gallery](https://invent.kde.org/sdk/kirigami-gallery) is a gallery application used to showcase and test
  various Kirigami components.

## Scope and Structure

To avoid this module losing scope as we have seen in other generic addons modules before, Kirigami Addons
has clearly defined rules for things to go in here:

- Kirigami Addons is cross-platform, depending on other KF5 frameworks is fine, but things must still work on Android.
  Components can use platform specializations, e.g. native dialogs, but a generic implementation for all platforms has
  to exist.

- Components are grouped according to some topic, e.g. 'dateandtime' or 'chat'.
  Each group has its own source directory and QML import name. The name follows the scheme of
  'org.kde.kirigamiaddons.topic', e.g. 'org.kde.kirigamiaddons.dateandtime'.

- All user exposed QML items should have an example application in the tests folder.

In particular, Kirigami Addons is not:

- A place for exposing non-visual QML bindings.
- A place for QML bindings for other libraries.
- A place for API for a specific platform.

## Building

The easiest way to make changes and test Kirigami Add-ons during development is
to [build it with kdesrc-build](https://community.kde.org/Get_Involved/development/Build_software_with_kdesrc-build).

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

