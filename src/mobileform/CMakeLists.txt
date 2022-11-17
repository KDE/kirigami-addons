# SPDX-FileCopyrightText: 2022 Devin Lin <devin@kde.org>
# SPDX-License-Identifier: GPL-2.0-or-later

ecm_add_qml_module(mobileformplugin URI "org.kde.kirigamiaddons.labs.mobileform" VERSION 0.1)

target_compile_definitions(mobileformplugin PRIVATE -DTRANSLATION_DOMAIN=\"kirigami_mobileform\")

target_sources(mobileformplugin PRIVATE
    lib/plugin.cpp
)

ecm_target_qml_sources(mobileformplugin SOURCES
    AbstractFormDelegate.qml
    FormArrow.qml
    FormButtonDelegate.qml
    FormCard.qml
    AboutCard.qml
    FormCardHeader.qml
    FormCheckDelegate.qml
    FormComboBoxDelegate.qml
    FormDelegateBackground.qml
    FormDelegateSeparator.qml
    FormRadioDelegate.qml
    FormSectionText.qml
    FormSwitchDelegate.qml
    FormTextDelegate.qml
    FormTextFieldDelegate.qml
)

target_link_libraries(mobileformplugin
    Qt${QT_MAJOR_VERSION}::Quick
    Qt${QT_MAJOR_VERSION}::Qml
    KF5::I18n
)

ecm_finalize_qml_module(mobileformplugin DESTINATION ${KDE_INSTALL_QMLDIR})
