# SPDX-FileCopyrightText: 2019 David Edmundson <kde@davidedmundson.co.uk>
# SPDX-License-Identifier: BSD-2-Clause

add_subdirectory(components)
add_subdirectory(dateandtime)
add_subdirectory(tableview)
add_subdirectory(treeview)
add_subdirectory(sounds)
add_subdirectory(formcard)
add_subdirectory(delegates)
add_subdirectory(settings)
add_subdirectory(statefulapplication)

if (TARGET Qt6::qdoc AND TARGET Qt6::qhelpgenerator)
    add_library(addonsdummydocumentationtarget OBJECT)
    ecm_generate_qdoc(addonsdummydocumentationtarget kirigami-addons.qdocconf)
endif()
