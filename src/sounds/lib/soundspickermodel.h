// SPDX-FileCopyrightText: 2021 Han Young <hanyoung@protonmail.com>
// SPDX-License-Identifier: LGPL-2.0-or-later
#ifndef SoundsPickerModel_H
#define SoundsPickerModel_H

#include <QAbstractListModel>
#include <memory>
class SoundsPickerModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(bool notification READ notification WRITE setNotification NOTIFY notificationChanged)
    Q_PROPERTY(QStringList defaultAudio READ defaultAudio WRITE setDefaultAudio NOTIFY defaultAudioChanged)
    Q_PROPERTY(QString theme READ theme WRITE setTheme NOTIFY themeChanged)
public:
    enum Roles {
        NameRole = Qt::UserRole,
        UrlRole
    };
    
    explicit SoundsPickerModel(QObject *parent = nullptr);
    ~SoundsPickerModel();
    
    bool notification() const;
    void setNotification(bool notification);
    Q_INVOKABLE QString initialSourceUrl(int index);
    QHash<int, QByteArray> roleNames() const override;
    QVariant data(const QModelIndex &index, int role) const override;
    int rowCount(const QModelIndex& parent) const override;

    const QStringList &defaultAudio() const;
    void setDefaultAudio(const QStringList &audio);
    const QString &theme() const;
    void setTheme(const QString &theme);

Q_SIGNALS:
    void notificationChanged();
    void defaultAudioChanged();
    void themeChanged();
    
private:
    void loadFiles();
    void rearrangeRingtoneOrder();
    class Private;
    std::unique_ptr<Private> d;
};

#endif // SoundsPickerModel_H
