# SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
# SPDX-License-Identifier: BSD-2-Clause

add_library(KirigamiAddonsMaterialPlatform MODULE)
target_sources(KirigamiAddonsMaterialPlatform PRIVATE materialfactory.cpp materialtheme.cpp materialtheme.h)
target_link_libraries(KirigamiAddonsMaterialPlatform PRIVATE Qt6::Quick KF6::KirigamiPlatform KF6::IconThemes)
set_target_properties(KirigamiAddonsMaterialPlatform PROPERTIES
    PREFIX ""
    OUTPUT_NAME "libplugins_kf6_kirigami_platform_Material"
)
install(TARGETS KirigamiAddonsMaterialPlatform DESTINATION ${KDE_INSTALL_PLUGINDIR}/kf6/kirigami/platform)
