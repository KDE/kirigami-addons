// SPDX-FileCopyrightText: 2024 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-only or LGPL-3.0-only or LicenseRef-KDE-Accepted-LGPL

#pragma once

#include <kirigamiactioncollection.h>
#include <kirigamiaddonsstatefulapp_export.h>
#include <QObject>
#include <QSortFilterProxyModel>
#include <QtQml/qqmlregistration.h>

/**
 * @class AbstractKirigamiApplication kirigamiabstractapplication.h AbstractKirigamiApplication
 *
 * @short The main container for your actions.
 *
 * AbstractKirigamiApplication is a class that needs to be inherited in your application.
 * It allows to expose the various actions of your applications to the QML frontend. Depending
 * on the complexitiy of you application, you will have to either reimplement setupActions only
 * and put all your actions inside the mainCollection or if you want to organize your actions
 * in multiple collections, you will have to also expose the custom collections by overwriting
 * actionCollections.
 *
 * @code{.cpp}
 * class MyKoolApp : public AbstractKirigamiApplication
 * {
 *     Q_OBJECT
 *     QML_ELEMENT
 *     QML_SINGLETON
 *  public:
 *     explicit MyKoolApp(QObject *parent = nullptr);
 *
 *     void setupActions() override;
 * };
 *
 * MyKoolApp::MyKoolApp(QObject *parent)
 *     : AbstractKirigamiApplication(parent)
 * {
 *      setupActions();
 * }
 *
 * void MyKoolApp::setupActions()
 * {
 *     AbstractKirigamiApplication::setupActions();
 *
 *     auto actionName = QLatin1String("add_notebook");
 *     if (KAuthorized::authorizeAction(actionName)) {
 *         auto action = mainCollection()->addAction(actionName, this, &MyKoolApp::newNotebook);
 *         action->setText(i18nc("@action:inmenu", "New Notebook"));
 *         action->setIcon(QIcon::fromTheme(QStringLiteral("list-add-symbolic")));
 *         mainCollection()->addAction(action->objectName(), action);
 *         mainCollection()->setDefaultShortcut(action, QKeySequence(Qt::CTRL | Qt::SHIFT | Qt::Key_N));
 *     }
 * }
 * @endcode
 *
 * The application object then needs to set in ManagedWindow.
 *
 * @code{.qml}
 * import org.kde.kirigamiaddons.StatefulApplication as StatefulApplication
 *
 * StatefulApplication.StatefulWindow {
 *     application: MyKoolApp
 *
 *     StatefulApplication.Action {
 *         actionName: 'add_notebook'
 *     }
 * }
 * @endcode{}
 *
 * @since 1.3.0
 */
class KIRIGAMIADDONSSTATEFULAPP_EXPORT AbstractKirigamiApplication : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_UNCREATABLE("Abstract class")

    /// @internal Used by StatefulApp.ManagedWindow
    Q_PROPERTY(QSortFilterProxyModel *actionsModel READ actionsModel CONSTANT)

    /// @internal Used by StatefulApp.ManagedWindow
    Q_PROPERTY(QAbstractListModel *shortcutsModel READ shortcutsModel CONSTANT)

    /// This property holds the configurationView of the application
    ///
    /// When set, AbstractKirigamiApplication will setup a "options_configure" action
    /// that will open the configurationView when triggered.
    Q_PROPERTY(QObject *configurationsView READ configurationsView WRITE setConfigurationsView NOTIFY configurationsViewChanged)

public:
    /// Default constructor of AbstractKirigamiApplication
    explicit AbstractKirigamiApplication(QObject *parent = nullptr);

    /// Default destructor of AbstractKirigamiApplication
    virtual ~AbstractKirigamiApplication();

    /// Return the list of KirigamiActionCollection setup in your application.
    ///
    /// Overwrite this method if you are using custom collections.
    virtual QList<KirigamiActionCollection *> actionCollections() const;

    /// Return the main action collection.
    KirigamiActionCollection *mainCollection() const;

    /// @internal Used by StatefulApp.StatefulWindow
    QSortFilterProxyModel *actionsModel();

    /// @internal Used by the shortcuts editor
    QAbstractListModel *shortcutsModel();

    /// @internal Used by StatefulApp.Action
    Q_INVOKABLE QAction *action(const QString &actionName);

    /// Getter for the configurationsView property.
    QObject *configurationsView() const;

    /// Setter for the configurationsView property.
    void setConfigurationsView(QObject *configurationsView);

Q_SIGNALS:
    /// @internal Used by StatefulApp.StatefulWindow
    void openAboutPage();

    /// @internal Used by StatefulApp.StatefulWindow
    void openAboutKDEPage();

    /// @internal Used by StatefulApp.StatefulWindow
    void openKCommandBarAction();

    /// @internal Used by StatefulApp.StatefulWindow
    void shortcutsEditorAction();

    /// Changed signal for the configurationView property.
    void configurationsViewChanged();

protected:
    /// Entry points to declare your actions.
    ///
    /// Don't forget to call the parent implementation to get the following actions
    /// setup for you:
    ///
    /// - CommandBar
    /// - About page for your application
    /// - About page for KDE
    ///
    /// Once the actions are setup, call readSettings to read the confirured shortcuts.
    virtual void setupActions();

    /// Read the configured settings for the action.
    void readSettings();

private:
    void KIRIGAMIADDONSSTATEFULAPP_NO_EXPORT quit();

    class Private;
    std::unique_ptr<Private> d;
};
