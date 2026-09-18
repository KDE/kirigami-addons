// SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-or-later

#include "circularclipitem.h"

#include <private/qquickclipnode_p.h>
#include <private/qquickitem_p.h>

CircularClipItem::CircularClipItem(QQuickItem *parent)
    : QQuickItem(parent)
{
    setFlag(ItemHasContents, true);
    setClip(true);
}

QSGNode *CircularClipItem::updatePaintNode(QSGNode *node, UpdatePaintNodeData *data)
{
    Q_UNUSED(data)

    if (auto *clip = QQuickItemPrivate::get(this)->clipNode()) {
        clip->setRadius(qMin(width(), height()) / 2);
        clip->update();
    }

    delete node;
    return nullptr;
}
