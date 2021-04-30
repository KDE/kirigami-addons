<!--
SPDX-FileCopyrightText: 2019 David Edmundson <kde@davidedmundson.co.uk>
SPDX-FileCopyrightText: 2020 Nicolas Fella <nicolas.fella@gmx.de>
SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Kirigami Addons

A set of "widgets" i.e visual end user components along with a code to support them.
Components are usable by both touch and desktop experiences providing a native experience on both,
and look native with any QQC2 style (qqc2-desktop-theme, Material or Plasma)

## Scope and Structure

To avoid this module losing scope as we have seen in other generic addons modules before, Kirigami Addons
has clearly defined rules for things to go in here:

- Kirigami Addons is cross-platform, depending on other KF5 frameworks is fine, but things must still work on Android.
Components can use platform specializations, e.g. native dialogs, but a generic implementation for all platforms has to exist.

- Components are grouped according to some topic, e.g. 'dateandtime' or 'chat'.
Each group has its own source directory and QML import name. The name follows the scheme of
'org.kde.kirigamiaddons.topic', e.g. 'org.kde.kirigamiaddons.dateandtime'.

- All user exposed QML items should have an example application in the tests folder.

In particular, Kirigami Addons is not:
 - a place for exposing non-visual QML bindings
 - a place for QML bindings for other libraries
 - a place for API for a specific platform

