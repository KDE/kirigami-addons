/*
 *  SPDX-FileCopyrightText: 2020 Marco Martin <mart@kde.org>
 *
 *  SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.12
import org.kde.kitemmodels 1.0 

TableView {
    id: root
    rowSpacing: 0
    property QtObject sourceModel
    property alias descendantsModel: descendantsModel
    property alias expandsByDefault: descendantsModel.expandsByDefault

    model: KDescendantsProxyModel {
        id: descendantsModel
        expandsByDefault: false
        model: root.sourceModel
    }
}

