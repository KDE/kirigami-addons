// SPDX-FileCopyrightText: 2021 Han Young <hanyoung@protonmail.com>
// SPDX-License-Identifier: LGPL-2.0-or-later

#include "soundspickermodel.h"

#include <vector>

#include <QDirIterator>
#include <QStandardPaths>

class SoundsPickerModel::Private
{
public:
    QStringList defaultAudio;
    std::vector<QString> soundsVec;
    bool notification = false;
    QString theme = QStringLiteral("plasma-mobile");
};

SoundsPickerModel::SoundsPickerModel(QObject *parent)
    : QAbstractListModel(parent)
    , d(std::make_unique<Private>())
{
    loadFiles();
}

void SoundsPickerModel::loadFiles()
{
    d->soundsVec.clear();
    const auto locations = QStandardPaths::standardLocations(QStandardPaths::GenericDataLocation);
    const QString path = QStringLiteral("/sounds/") + d->theme + QStringLiteral("/stereo/");

    for (const auto &directory : locations) {
        if (QDir(directory + path).exists()) {
            QString subPath = directory + path;
            if (!d->notification && QDir(subPath + QStringLiteral("ringtone")).exists()) {
                subPath += QStringLiteral("ringtone");
            } else if (d->notification && QDir(subPath + QStringLiteral("notification")).exists()) {
                subPath += QStringLiteral("notification");
            }

            QDirIterator it(subPath, QDir::Files, QDirIterator::Subdirectories);
            while (it.hasNext()) {
                const QString fileName = it.next();
                if (fileName.endsWith(QLatin1String(".license"))) {
                    continue;
                }
                d->soundsVec.push_back(fileName);
            }
        }
    }
}

SoundsPickerModel::~SoundsPickerModel() = default;

QHash<int, QByteArray> SoundsPickerModel::roleNames() const
{
    return {
        {Roles::NameRole, QByteArrayLiteral("ringtoneName")},
        {Roles::UrlRole, QByteArrayLiteral("sourceUrl")}
    };
}

bool SoundsPickerModel::notification() const
{
    return d->notification;
}

void SoundsPickerModel::setNotification(bool notification)
{
    if (d->notification == notification) {
        return;
    }
    d->notification = notification;

    bool needReset = false;
    QString path = QStandardPaths::writableLocation(QStandardPaths::GenericDataLocation) + QStringLiteral("/") + d->theme + QStringLiteral("/stereo/");
    if (!d->notification && QDir(path + QStringLiteral("ringtone")).exists()) {
        needReset = true;
    } else if (d->notification && QDir(path + QStringLiteral("notification")).exists()) {
        needReset = true;
    }

    if (needReset) {
        beginResetModel();
        loadFiles();
        endResetModel();
        rearrangeRingtoneOrder();
    }
}

QString SoundsPickerModel::initialSourceUrl(int index)
{
    if (index >= 0 && index < (int)d->soundsVec.size()) {
        return d->soundsVec.at(index);
    }
    return {};
}

QVariant SoundsPickerModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() < 0 || index.row() >= (int)d->soundsVec.size()) {
        return {};
    }

    if (role == NameRole) {
        auto ret = d->soundsVec.at(index.row());
        int suffixPos = ret.lastIndexOf(QLatin1Char('.'));
        if (suffixPos > 0) {
            ret.truncate(suffixPos);
        }
        int pathPos =  ret.lastIndexOf(QLatin1Char('/'));
        if (pathPos >= 0) {
            ret.remove(0, pathPos + 1);
        }
        return ret;
    }
    return d->soundsVec.at(index.row());
}
int SoundsPickerModel::rowCount(const QModelIndex& parent) const {
    Q_UNUSED(parent)
    return d->soundsVec.size();
}

const QStringList &SoundsPickerModel::defaultAudio() const
{
    return d->defaultAudio;
}

void SoundsPickerModel::setDefaultAudio(const QStringList &audio)
{
    d->defaultAudio = audio;
    rearrangeRingtoneOrder();
}

const QString &SoundsPickerModel::theme() const
{
    return d->theme;
}

void SoundsPickerModel::setTheme(const QString &theme)
{
    if (d->theme == theme) {
        return;
    }
    d->theme = theme;

    beginResetModel();
    loadFiles();
    endResetModel();
    rearrangeRingtoneOrder();
}

void SoundsPickerModel::rearrangeRingtoneOrder()
{
    auto i {0};
    for (int j = 0; j < (int)d->soundsVec.size(); j++) {
        if (d->defaultAudio.contains(data(index(j), NameRole).toString())) {
            std::swap(d->soundsVec[j], d->soundsVec[i]);
            Q_EMIT dataChanged(index(j), index(j));
            Q_EMIT dataChanged(index(i), index(i));
            i++;
        }
    }
}

#include "moc_soundspickermodel.cpp"
