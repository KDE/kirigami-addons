# SPDX-FileCopyrightText: 2019 David Edmundson <kde@davidedmundson.co.uk>
# SPDX-License-Identifier: BSD-2-Clause

add_subdirectory(components)
add_subdirectory(dateandtime)
add_subdirectory(treeview)
add_subdirectory(sounds)
add_subdirectory(formcard)
add_subdirectory(delegates)
add_subdirectory(settings)

# This is used to make the KSvg import work in the KF5 version
# Should be removed as soon master goes KF6 only
if (QT_MAJOR_VERSION EQUAL "5")
    add_subdirectory(ksvgcompat)
endif()
