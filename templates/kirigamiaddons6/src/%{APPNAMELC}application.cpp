// SPDX-License-Identifier: GPL-2.0-or-later
// SPDX-FileCopyrightText: %{CURRENT_YEAR} %{AUTHOR} <%{EMAIL}>

#include "%{APPNAMELC}application.h"
#include <KAuthorized>
#include <KLocalizedString>

using namespace Qt::StringLiterals;

%{APPNAME}Application::%{APPNAME}Application(QObject *parent)
    : AbstractKirigamiApplication(parent)
{
    setupActions();
}

void %{APPNAME}Application::setupActions()
{
    AbstractKirigamiApplication::setupActions();

    auto actionName = "increment_counter"_L1;
    if (KAuthorized::authorizeAction(actionName)) {
        auto action = mainCollection()->addAction(actionName, this, &%{APPNAME}Application::incrementCounter);
        action->setText(i18nc("@action:inmenu", "Increment"));
        action->setIcon(QIcon::fromTheme(u"list-add-symbolic"_s));
        mainCollection()->addAction(action->objectName(), action);
        mainCollection()->setDefaultShortcut(action, Qt::CTRL | Qt::Key_I);
    }

    actionName = "options_configure"_L1;
    if (KAuthorized::authorizeAction(actionName)) {
        auto action = KStandardActions::preferences(this, &%{APPNAME}Application::openConfigurations, this);
        mainCollection()->addAction(action->objectName(), action);
    }

    readSettings();
}

#include "moc_%{APPNAMELC}application.cpp"
