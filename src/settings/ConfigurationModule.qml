// SPDX-FileCopyrightText: 2021 Carl Schwan <carl\carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL

import QtQml
import org.kde.kirigamiaddons.settings.private as Private

/*!
   \qmltype ConfigurationModule
   \inqmlmodule org.kde.kirigamiaddons.settings
   \brief This object holds the information of configuration module.
   \since 1.3.0
 */
QtObject {
    id: root

    /*!
       \brief This property holds the id of the module for when it needs to be referenced.

       Primary use case is for setting a default module in ConfigurationView.
     */
    required property string moduleId

    /*!
       This property holds the name of the module.

       This will be displayed in the list of modules.
     */
    required property string text

    /*!
       This property holds the icon of the module.
     */
    readonly property Private.ActionIconGroup icon: Private.ActionIconGroup {}

    /*!
       This property holds a function that returns a Component.
     */
    required property var page

    /*!
       This property holds whether the module is visible.
       \default true
     */
    property bool visible: true

    /*!
       This property holds the initial property that the page needs to be initialized with
       if any.

       This is a function that returns an Javascript object.

       \qml
       initialProperties: () => {
           return {
               room: root._room,
               connection: root._connection
           };
       }
       \endqml
     */
    property var initialProperties: () => {
        return {};
    }

    /*!
       This property holds the category of the module.

       This is used to group modules together on mobile.

       Do not overwrite the default value if you want your module to
       be grouped in the default category.
       \default "_main_category"
     */
    property string category: "_main_category"
}
