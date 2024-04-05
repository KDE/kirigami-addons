# SPDX-FileCopyrightText: 2022 Devin Lin <devin@kde.org>
# SPDX-License-Identifier: GPL-2.0-or-later

# FormCard module
ecm_add_qml_module(formcardplugin
    URI "org.kde.kirigamiaddons.formcard"
    VERSION 1.0
    GENERATE_PLUGIN_SOURCE
    DEPENDENCIES
        org.kde.coreaddons
        org.kde.kirigami
        org.kde.kirigamiaddons.components
        org.kde.kirigamiaddons.dateandtime
        org.kde.kirigamiaddons.delegates
)

ecm_target_qml_sources(formcardplugin SOURCES
    AbstractFormDelegate.qml
    FormArrow.qml
    FormButtonDelegate.qml
    FormPage.qml
    FormGroup.qml
    FormColorDelegate.qml
    ActionHeader.qml
    AboutPage.qml
    AboutKDE.qml
    AboutKDEPage.qml
    FormCheckDelegate.qml
    FormComboBoxDelegate.qml
    FormDelegateBackground.qml
    FormDelegateSeparator.qml
    FormPlaceholderMessageDelegate.qml
    FormLinkDelegate.qml
    FormRadioDelegate.qml
    FormRadioSelectorDelegate.qml
    FormSectionText.qml
    FormSpinBoxDelegate.qml
    FormSwitchDelegate.qml
    FormTextDelegate.qml
    FormTextFieldDelegate.qml
    FormTextAreaDelegate.qml
    FormPasswordFieldDelegate.qml
    FormDateTimeDelegate.qml
    FormGridContainer.qml
    FormDialog.qml
)

if(ANDROID)
    ecm_target_qml_sources(formcardplugin SOURCES
        android/FormColorDelegate.qml
        android/FormIconDelegate.qml
    )
else()
    ecm_target_qml_sources(formcardplugin SOURCES
        FormColorDelegate.qml
        FormIconDelegate.qml
    )
endif()

target_sources(formcardplugin PRIVATE
    aboutcomponent_p.h
    aboutcomponent.cpp
    passwordhealth.h
    passwordhealth.cpp
    zxcvbn/zxcvbn.h
    zxcvbn/zxcvbn.c
)
target_compile_definitions(formcardplugin PRIVATE -DTRANSLATION_DOMAIN=\"kirigami-addons6\")

set_source_files_properties(private/FormCardUnits.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

ecm_target_qml_sources(formcardplugin PATH private SOURCES
    private/ContentItemLoader.qml
    private/SpinButton.qml
    private/FormCardUnits.qml
)

target_link_libraries(formcardplugin PRIVATE
    Qt6::Quick
    Qt6::Qml
    KF6::I18n
    KF6::I18n
    KF6::CoreAddons
)

ecm_finalize_qml_module(formcardplugin DESTINATION ${KDE_INSTALL_QMLDIR} EXPORT KirigamiAddonsTargets)
