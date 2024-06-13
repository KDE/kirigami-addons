// SPDX-FileCopyrightText: %{CURRENT_YEAR} %{AUTHOR} <%{EMAIL}>
// SPDX-License-Identifier: GPL-2.0-or-later

#pragma once

#include <QQmlEngine>
#include <AbstractKirigamiApplication>

using namespace Qt::StringLiterals;

class %{APPNAME}Application : public AbstractKirigamiApplication
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

public:
    explicit %{APPNAME}Application(QObject *parent = nullptr);

Q_SIGNALS:
    void openConfigurations();
    void incrementCounter();

private:
    void setupActions() override;
};
