# SPDX-FileCopyrightText: 2022 Devin Lin <devin@kde.org>
# SPDX-License-Identifier: GPL-2.0-or-later

# FormCard module

ecm_add_qml_module(formcardplugin
    URI "org.kde.kirigamiaddons.formcard"
    VERSION 1.0
    GENERATE_PLUGIN_SOURCE
    DEPENDENCIES
        org.kde.kirigami
        org.kde.kirigamiaddons.delegates
)

ecm_target_qml_sources(formcardplugin SOURCES
    AbstractFormDelegate.qml
    FormArrow.qml
    FormButtonDelegate.qml
    FormCard.qml
    FormCardPage.qml
    FormHeader.qml
    AboutPage.qml
    AboutKDE.qml
    AboutKDEPage.qml
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
    FormTextAreaDelegate.qml
    FormPasswordFieldDelegate.qml
    FormDateTimeDelegate.qml
    FormGridContainer.qml
    FormCardDialog.qml
)

if(ANDROID)
    ecm_target_qml_sources(formcardplugin SOURCES
        android/FormColorDelegate.qml
    )
else()
    ecm_target_qml_sources(formcardplugin SOURCES
        FormColorDelegate.qml
    )
endif()

ecm_target_qml_sources(formcardplugin PATH private SOURCES
    private/ContentItemLoader.qml
    private/SpinButton.qml
)

target_link_libraries(formcardplugin PRIVATE
    Qt6::Quick
    Qt6::Qml
    KF6::I18n
)

ecm_finalize_qml_module(formcardplugin DESTINATION ${KDE_INSTALL_QMLDIR})
