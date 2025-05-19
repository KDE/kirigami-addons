// SPDX-FileCopyrightText: 2024 Carl Schwan <carl\carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-only or LGPL-3.0-only or LicenseRef-KDE-Accepted-LGPL

#pragma once

#include <kirigamiactioncollection.h>
#include <kirigamiaddonsstatefulapp_export.h>
#include <QObject>
#include <QSortFilterProxyModel>
#include <QtQml/qqmlregistration.h>

/*!
 * \class AbstractKirigamiApplication
 * \brief The main container for your actions.
 *
 * AbstractKirigamiApplication is a class that needs to be inherited in your application.
 *
 * It allows to expose the various actions of your application to the QML frontend. Depending
 * on the complexitiy of the application, you can either reimplement setupActions only
 * and put all your actions inside the mainCollection, or, if you want to organize your actions
 * in multiple collections, you can also expose the custom collections by overwriting
 * actionCollections.
 *
 * \code{.cpp}
 * class MyKoolApp : public AbstractKirigamiApplication
 * {
 *     Q_OBJECT
 *     QML_ELEMENT
 *
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
 * \endcode
 *
 * The application object then need to be assigned to the application property in a StatefulWindow.
 *
 * \code{.qml}
 * import org.kde.kirigamiaddons.StatefulApplication as StatefulApplication
 *
 * StatefulApplication.StatefulWindow {
 *     id: root
 *
 *     application: MyKoolApp {}
 *
 *     StatefulApplication.Action {
 *         actionName: 'add_notebook'
 *         application: root.application
 *     }
 * }
 * \endcode{}
 *
 * \since 1.4.0
 */
class KIRIGAMIADDONSSTATEFULAPP_EXPORT AbstractKirigamiApplication : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_UNCREATABLE("Abstract class")

    /// \internal Used by StatefulApp.ManagedWindow
    Q_PROPERTY(QSortFilterProxyModel *actionsModel READ actionsModel CONSTANT)

    /// \internal Used by StatefulApp.ManagedWindow
    Q_PROPERTY(QAbstractListModel *shortcutsModel READ shortcutsModel CONSTANT)

    /*!
     * \qmlproperty QObject AbstractKirigamiApplication::configurationView
     * This property holds the configurationView of the application
     *
     * When set, AbstractKirigamiApplication will setup a "options_configure" action
     * that will open the configurationView when triggered.
     */
    Q_PROPERTY(QObject *configurationView READ configurationView WRITE setConfigurationView NOTIFY configurationViewChanged)

public:
    /*! Default constructor of AbstractKirigamiApplication */
    explicit AbstractKirigamiApplication(QObject *parent = nullptr);

    /*! Default destructor of AbstractKirigamiApplication */
    virtual ~AbstractKirigamiApplication();

    /*! Return the list of KirigamiActionCollection setup in your application.
     *  Overwrite this method if you are using custom collections.
     */
    virtual QList<KirigamiActionCollection *> actionCollections() const;

    /*! Return the main action collection. */
    KirigamiActionCollection *mainCollection() const;

    /*! \internal Used by StatefulApp.StatefulWindow */
    QSortFilterProxyModel *actionsModel();

    /*! \internal Used by the shortcuts editor */
    QAbstractListModel *shortcutsModel();

    /*! Get the named action.
     *  \return nullptr is not such action is defined.
     */
    Q_INVOKABLE QAction *action(const QString &actionName);

    /*! Getter for the configurationView property. */
    QObject *configurationView() const;

    /*! Setter for the configurationView property. */
    void setConfigurationView(QObject *configurationView);

Q_SIGNALS:
    /*! \internal Used by StatefulApp.StatefulWindow */
    void openAboutPage();

    /*! \internal Used by StatefulApp.StatefulWindow */
    void openAboutKDEPage();

    /*! \internal Used by StatefulApp.StatefulWindow */
    void openKCommandBarAction();

    /*! \internal Used by StatefulApp.StatefulWindow */
    void shortcutsEditorAction();

    /*! Changed signal for the configurationView property. */
    void configurationViewChanged();

protected:
    /*! Entry points to declare your actions.
     *
     *  Don't forget to call the parent implementation to get the following actions
     *  setup for you:
     *
     * \list
     * \li CommandBar
     * \li About page for your application
     * \li About page for KDE
     * \endlist
     *
     *  Once the actions are setup, call readSettings to read the configured shortcuts.
     */
    virtual void setupActions();
     /*! Read the configured settings for the action. */
    void readSettings();

private:
    void KIRIGAMIADDONSSTATEFULAPP_NO_EXPORT quit();

    class Private;
    std::unique_ptr<Private> d;
};
