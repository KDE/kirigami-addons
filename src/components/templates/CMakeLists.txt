# SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
# SPDX-License-Identifier: BSD-2-Clause

ecm_add_qml_module(componentstemplatesplugin
    URI "org.kde.kirigamiaddons.components.templates"
    VERSION 1.0
    GENERATE_PLUGIN_SOURCE
    DEPENDENCIES QtQuick QtQuick.Templates org.kde.kirigami
)

ecm_target_qml_sources(componentstemplatesplugin SOURCES
    FloatingButton.qml
    DoubleFloatingButton.qml
)

ecm_finalize_qml_module(componentstemplatesplugin DESTINATION ${KDE_INSTALL_QMLDIR} EXPORT KirigamiAddonsTargets)
