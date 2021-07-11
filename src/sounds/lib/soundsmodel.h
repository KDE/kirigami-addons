// SPDX-FileCopyrightText: 2021 Han Young <hanyoung@protonmail.com>
// SPDX-License-Identifier: LGPL-2.0-or-later
#ifndef SOUNDSMODEL_H
#define SOUNDSMODEL_H

#include <QAbstractListModel>
#include <memory>
class SoundsModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(bool notification READ notification WRITE setNotification NOTIFY notificationChanged)
public:
    enum Roles {NameRole = Qt::UserRole,
                  UrlRole};
    explicit SoundsModel(QObject *parent = nullptr);
    ~SoundsModel();
    bool notification() const;
    void setNotification(bool notification);
    Q_INVOKABLE QString initialSourceUrl(int index);
    QHash<int, QByteArray> roleNames() const override;
    QVariant data(const QModelIndex &index, int role) const override;
    int rowCount(const QModelIndex& parent) const override;
Q_SIGNALS:
    void notificationChanged();
private:
    void loadFiles(QString theme = QStringLiteral("plasma-mobile"));
    class Private;
    std::unique_ptr<Private> d;
};

#endif // SOUNDSMODEL_H
