/*
 * SPDX-FileCopyrightText: 2026 Kai Uwe Broulik <kde@broulik.de>
 *
 * SPDX-License-Identifier: LGPL-2.1-only or LGPL-3.0-only or LicenseRef-KDE-Accepted-LGPL
 */

#pragma once

#include <QSortFilterProxyModel>

#include "chipgroup.h"

class SuggestionsProxyModel : public QSortFilterProxyModel
{
    Q_OBJECT

    Q_PROPERTY(ChipGroup *group READ group WRITE setGroup NOTIFY groupChanged)
    Q_PROPERTY(QString query READ query WRITE setQuery NOTIFY queryChanged)

public:
    explicit SuggestionsProxyModel(QObject *parent = nullptr);
    ~SuggestionsProxyModel() override;

    ChipGroup *group() const;
    void setGroup(ChipGroup *group);
    Q_SIGNAL void groupChanged(ChipGroup *group);

    QString query() const;
    void setQuery(const QString &query);
    Q_SIGNAL void queryChanged(const QString &query);

protected:
    bool filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const override;

private:
    ChipGroup *m_group = nullptr;
    QString m_query;
};
