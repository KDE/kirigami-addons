# SPDX-FileCopyrightText: 2026 Sandro Andrade <sandroandrade@kde.org>
# SPDX-License-Identifier: BSD-2-Clause

ecm_add_qml_module(onboardingplugin
    URI "org.kde.kirigamiaddons.onboarding"
    VERSION 1.0
    GENERATE_PLUGIN_SOURCE
    DEPENDENCIES
        org.kde.kirigami
        QtQuick.Effects
)

ecm_generate_qdoc(onboardingplugin kirigamiaddonsonboarding.qdocconf)

target_sources(onboardingplugin PRIVATE
    onboarding.cpp
    onboarding_p.h
    onboardingcontroller.cpp
    onboardingcontroller_p.h
)

ecm_target_qml_sources(onboardingplugin SOURCES
    OnboardToolTip.qml
)

ecm_target_qml_sources(onboardingplugin PRIVATE PATH private SOURCES
    private/OnboardingEffect.qml
    private/OnboardingOverlay.qml
)

target_link_libraries(onboardingplugin PRIVATE
    Qt6::Quick
    Qt6::Qml
    Qt6::QuickControls2
    Qt6::QuickEffects
)

ecm_finalize_qml_module(onboardingplugin DESTINATION ${KDE_INSTALL_QMLDIR} EXPORT KirigamiAddonsTargets)
