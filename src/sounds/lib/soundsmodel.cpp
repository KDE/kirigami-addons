// SPDX-FileCopyrightText: 2021 Han Young <hanyoung@protonmail.com>
// SPDX-License-Identifier: LGPL-2.0-or-later
#include "soundsmodel.h"
#include <vector>
#include <QDirIterator>
#include <QDebug>
class SoundsModel::Private
{
public:
    std::vector<QString> soundsVec;
    bool notification = false;
};
SoundsModel::SoundsModel(QObject *parent)
    : QAbstractListModel(parent)
    , d(std::make_unique<Private>())
{
    loadFiles();
}
void SoundsModel::loadFiles(QString theme)
{
    d->soundsVec.clear();
    QString path = QStringLiteral("/usr/share/sounds/") + theme + QStringLiteral("/stereo/");
    if (!d->notification && QDir(path + QStringLiteral("ringtone")).exists())
        path += QStringLiteral("ringtone");
    else if (d->notification && QDir(path + QStringLiteral("notification")).exists())
        path += QStringLiteral("notificatoin");

    QDirIterator it(path, QDir::Files, QDirIterator::Subdirectories);
    while (it.hasNext()) {
        d->soundsVec.push_back(it.next());
    }
}
SoundsModel::~SoundsModel() = default;
QHash<int, QByteArray> SoundsModel::roleNames() const
{
    return {
        {Roles::NameRole, QByteArrayLiteral("ringtoneName")},
        {Roles::UrlRole, QByteArrayLiteral("sourceUrl")}};
}
bool SoundsModel::notification() const
{
    return d->notification;
}
void SoundsModel::setNotification(bool notification)
{
    if (d->notification != notification)
        d->notification = notification;
    beginResetModel();
    loadFiles();
    endResetModel();
}
QString SoundsModel::initialSourceUrl(int index)
{
    if (index >= 0 && index < (int)d->soundsVec.size())
        return d->soundsVec.at(index);
    else
        return {};
}
QVariant SoundsModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() < 0 || index.row() >= (int)d->soundsVec.size()) {
        return {};
    }

    if (role == NameRole) {
        auto ret = d->soundsVec.at(index.row());
        int suffixPos = ret.lastIndexOf(QLatin1Char('.'));
        if (suffixPos > 0)
            ret.truncate(suffixPos);
        int pathPos =  ret.lastIndexOf(QLatin1Char('/'));
        if (pathPos >= 0)
            ret.remove(0, pathPos + 1);
        return ret;
    } else {
        return d->soundsVec.at(index.row());
    }
}
int SoundsModel::rowCount(const QModelIndex& parent) const {
    Q_UNUSED(parent)
    return d->soundsVec.size();
}
