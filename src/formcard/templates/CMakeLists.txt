# SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
# SPDX-License-Identifier: BSD-2-Clause

ecm_add_qml_module(formcardtemplatesplugin
    URI "org.kde.kirigamiaddons.formcard.templates"
    VERSION 1.0
    GENERATE_PLUGIN_SOURCE
    DEPENDENCIES org.kde.kirigamiaddons.private QtQuick org.kde.kirigami
)

ecm_target_qml_sources(formcardtemplatesplugin SOURCES
    FormCard.qml
    FormCardDialog.qml
    FormDelegateBackground.qml
    FormGridContainer.qml
    FormHeader.qml
)

ecm_finalize_qml_module(formcardtemplatesplugin DESTINATION ${KDE_INSTALL_QMLDIR} EXPORT KirigamiAddonsTargets)
