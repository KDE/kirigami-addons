# SPDX-FileCopyrightText: 2022 Devin Lin <devin@kde.org>
# SPDX-License-Identifier: GPL-2.0-or-later

# MobileForm Labs module
# Deprecated and replaced by FormCard

ecm_add_qml_module(mobileformplugin URI "org.kde.kirigamiaddons.labs.mobileform" VERSION 0.1)

target_sources(mobileformplugin PRIVATE
    lib/labplugin.cpp
)

ecm_target_qml_sources(mobileformplugin SOURCES
    labs/FormCard.qml
    labs/AboutPage.qml
    labs/AboutKDE.qml

    AbstractFormDelegate.qml
    FormArrow.qml
    FormButtonDelegate.qml
    FormHeader.qml
    FormCardHeader.qml
    FormCheckDelegate.qml
    FormComboBoxDelegate.qml
    FormDelegateBackground.qml
    FormDelegateSeparator.qml
    FormRadioDelegate.qml
    FormSectionText.qml
    FormSpinBoxDelegate.qml
    FormSwitchDelegate.qml
    FormTextDelegate.qml
    FormTextFieldDelegate.qml
    FormGridContainer.qml
)

ecm_target_qml_sources(mobileformplugin PATH private SOURCES
    private/ContentItemLoader.qml
    private/SpinButton.qml
)

target_link_libraries(mobileformplugin PRIVATE
    Qt${QT_MAJOR_VERSION}::Quick
    Qt${QT_MAJOR_VERSION}::Qml
    KF${KF_MAJOR_VERSION}::I18n
)

ecm_finalize_qml_module(mobileformplugin DESTINATION ${KDE_INSTALL_QMLDIR})

# FormCard module

ecm_add_qml_module(formcardplugin URI "org.kde.kirigamiaddons.formcard" VERSION 1.0)

target_sources(formcardplugin PRIVATE
    lib/formcardplugin.cpp
)

ecm_target_qml_sources(formcardplugin SOURCES
    AbstractFormDelegate.qml
    FormArrow.qml
    FormButtonDelegate.qml
    FormCard.qml
    FormCardHeader.qml
    FormCardPage.qml
    FormHeader.qml
    AboutPage.qml
    AboutKDE.qml
    FormCheckDelegate.qml
    FormComboBoxDelegate.qml
    FormDelegateBackground.qml
    FormDelegateSeparator.qml
    FormRadioDelegate.qml
    FormSectionText.qml
    FormSpinBoxDelegate.qml
    FormSwitchDelegate.qml
    FormTextDelegate.qml
    FormTextFieldDelegate.qml
    FormGridContainer.qml
)

ecm_target_qml_sources(formcardplugin PATH private SOURCES
    private/ContentItemLoader.qml
    private/SpinButton.qml
)

target_link_libraries(formcardplugin PRIVATE
    Qt${QT_MAJOR_VERSION}::Quick
    Qt${QT_MAJOR_VERSION}::Qml
    KF${KF_MAJOR_VERSION}::I18n
)

ecm_finalize_qml_module(formcardplugin DESTINATION ${KDE_INSTALL_QMLDIR})
