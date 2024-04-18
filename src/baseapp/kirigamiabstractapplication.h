// SPDX-FileCopyrightText: 2023 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-or-later
#pragma once

#include <kirigamiactioncollection.h>
#include <kirigamiaddonsbaseapp_export.h>
#include <QObject>
#include <QSortFilterProxyModel>
#include <QtQml>

/**
 * @class KirigamiAbstractApplication kirigamiabstractapplication.h KirigamiAbstractApplication
 *
 * @short The main container for your actions.
 *
 * KirigamiAbstractApplication is a class that needs to be inherited in your application.
 * It allows to expose the various actions of your applications to the QML frontend. Depending
 * on the complexitiy of you application, you will have to either reimplement setupActions only
 * and put all your actions inside the mainCollection or if you want to organize your actions
 * in multiple collections, you will have to also expose the custom collections by overwriting
 * actionCollections.
 *
 * @code{.cpp}
 * class MyKoolApp : public KirigamiAbstractApplication
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
 *     : KirigamiAbstractApplication(parent)
 * {
 *      setupActions();
 * }
 *
 * void MyKoolApp::setupActions()
 * {
 *     KirigamiAbstractApplication::setupActions();
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
 * import org.kde.kirigamiaddons.managedapplication as ManagedApplication
 *
 * ManagedApplication.MainWindow {
 *     application: MyKoolApp
 *
 *     ManagedApplication.Action {
 *         actionName: 'add_notebook'
 *     }
 * }
 * @endcode{}
 *
 * @since 1.2.0
 */
class KIRIGAMIADDONSBASEAPP_EXPORT KirigamiAbstractApplication : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_UNCREATABLE("Abstract class")

    /// @internal Used by ManagedApp.ManagedWindow
    Q_PROPERTY(QSortFilterProxyModel *actionsModel READ actionsModel CONSTANT)

    /// @internal Used by ManagedApp.ManagedWindow
    Q_PROPERTY(QAbstractListModel *shortcutsModel READ shortcutsModel CONSTANT)

public:
    /**
     * Default constructor of KirigamiAbstractApplication
     */
    explicit KirigamiAbstractApplication(QObject *parent = nullptr);

    /**
     * Default destructor of KirigamiAbstractApplication
     */
    virtual ~KirigamiAbstractApplication();

    /// Return the list of KirigamiActionCollection setup in your application.
    ///
    /// Overwrite this method if you are using custom collections.
    virtual QList<KirigamiActionCollection *> actionCollections() const;

    /// Return the main action collection.
    KirigamiActionCollection *mainCollection() const;

    /// @internal Used by ManagedApp.MainWindow
    QSortFilterProxyModel *actionsModel();

    /// @internal Used by the shortcuts editor
    QAbstractListModel *shortcutsModel();

    /// @internal Used by ManagedApp.Action
    Q_INVOKABLE QAction *action(const QString &actionName);

    /// @internal Used by ManagedApp.Action
    Q_INVOKABLE QString iconName(const QIcon &icon) const;

Q_SIGNALS:
    /// @internal Used by ManagedApp.MainWindow
    void openAboutPage();

    /// @internal Used by ManagedApp.MainWindow
    void openAboutKDEPage();

    /// @internal Used by ManagedApp.MainWindow
    void openKCommandBarAction();

    /// @internal Used by ManagedApp.MainWindow
    void shortcutsEditorAction();

protected:
    /**
     * Entry points to declare your actions.
     *
     * Don't forget to call the parent implementation to get the following actions
     * setup for you:
     *
     * - CommandBar
     * - About page for your application
     * - About page for KDE
     */
    virtual void setupActions();

private:
    void KIRIGAMIADDONSBASEAPP_NO_EXPORT quit();

    class Private;
    std::unique_ptr<Private> d;
};
