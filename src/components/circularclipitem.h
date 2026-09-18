// SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-or-later

#pragma once

#include <QQuickItem>
#include <QtQml/qqmlregistration.h>

/*!
 * \class CircularClipItem
 * \inmodule KirigamiAddonsComponents
 * \internal Clips its children to a circle using the stencil buffer
 * instead of an offscreen render pass with layers.enabled
 */
class CircularClipItem : public QQuickItem
{
    Q_OBJECT
    QML_ELEMENT

public:
    explicit CircularClipItem(QQuickItem *parent = nullptr);

protected:
    QSGNode *updatePaintNode(QSGNode *node, UpdatePaintNodeData *data) override;
};
