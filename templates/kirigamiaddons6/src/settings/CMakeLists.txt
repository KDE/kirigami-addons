# SPDX-FileCopyrightText: %{CURRENT_YEAR} %{AUTHOR} <%{EMAIL}>
# SPDX-License-Identifier: BSD-2-Clause

qt_add_library(%{APPNAMELC}_settings STATIC)
ecm_add_qml_module(%{APPNAMELC}_settings
    GENERATE_PLUGIN_SOURCE
    URI org.kde.%{APPNAMELC}.settings
    QML_FILES
        %{APPNAME}ConfigurationView.qml
        GeneralPage.qml
)
