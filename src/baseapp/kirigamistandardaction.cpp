/*
    This file is part of the KDE libraries
    SPDX-FileCopyrightText: 1999, 2000 Kurt Granroth <granroth@kde.org>

    SPDX-License-Identifier: LGPL-2.0-only
*/

#include "kirigamistandardaction.h"
#include "kirigamistandardaction_p.h"
#include "moc_kirigamistandardaction_p.cpp"

#include <KLocalizedString>
#include <KStandardShortcutWatcher>
#include <QGuiApplication>

namespace KirigamiStandardAction
{
AutomaticAction::AutomaticAction(const QIcon &icon,
                                 const QString &text,
                                 KStandardShortcut::StandardShortcut standardShortcut,
                                 const char *slot,
                                 QObject *parent)
    : QAction(parent)
{
    setText(text);
    setIcon(icon);

    const QList<QKeySequence> shortcut = KStandardShortcut::shortcut(standardShortcut);
    setShortcuts(shortcut);
    setProperty("defaultShortcuts", QVariant::fromValue(shortcut));
    connect(KStandardShortcut::shortcutWatcher(),
            &KStandardShortcut::StandardShortcutWatcher::shortcutChanged,
            this,
            [standardShortcut, this](KStandardShortcut::StandardShortcut id, const QList<QKeySequence> &newShortcut) {
                if (id != standardShortcut) {
                    return;
                }
                setShortcuts(newShortcut);
                setProperty("defaultShortcuts", QVariant::fromValue(newShortcut));
            });

    connect(this, SIGNAL(triggered()), this, slot);
}

QStringList stdNames()
{
    return internal_stdNames();
}

QList<StandardAction> actionIds()
{
    QList<StandardAction> result;

    for (uint i = 0; g_rgActionInfo[i].id != ActionNone; i++) {
        result.append(g_rgActionInfo[i].id);
    }

    return result;
}

KStandardShortcut::StandardShortcut shortcutForActionId(StandardAction id)
{
    const KirigamiStandardActionInfo *pInfo = infoPtr(id);
    return (pInfo) ? pInfo->idAccel : KStandardShortcut::AccelNone;
}

QAction *_k_createInternal(StandardAction id, QObject *parent)
{
    static bool stdNamesInitialized = false;

    QAction *pAction = nullptr;
    const KirigamiStandardActionInfo *pInfo = infoPtr(id);

    // qCDebug(KCONFIG_WIDGETS_LOG) << "KirigamiStandardAction::create( " << id << "=" << (pInfo ? pInfo->psName : (const char*)0) << ", " << parent << " )"; // ellis

    if (pInfo) {
        QString sLabel;
        QString iconName = pInfo->psIconName.toString();

        switch (id) {
        case Back:
            sLabel = i18nc("go back", "&Back");
            if (QGuiApplication::isRightToLeft()) {
                iconName = QStringLiteral("go-next");
            }
            break;

        case Forward:
            sLabel = i18nc("go forward", "&Forward");
            if (QGuiApplication::isRightToLeft()) {
                iconName = QStringLiteral("go-previous");
            }
            break;

        case Home:
            sLabel = i18nc("home page", "&Home");
            break;
        case Preferences:
        case AboutApp:
        case HelpContents: {
            QString appDisplayName = QGuiApplication::applicationDisplayName();
            if (appDisplayName.isEmpty()) {
                appDisplayName = QCoreApplication::applicationName();
            }
            sLabel = pInfo->psLabel.subs(appDisplayName).toString();
        } break;
        default:
            sLabel = pInfo->psLabel.toString();
        }

        if (QGuiApplication::isRightToLeft()) {
            switch (id) {
            case Prior:
                iconName = QStringLiteral("go-next-view-page");
                break;
            case Next:
                iconName = QStringLiteral("go-previous-view-page");
                break;
            case FirstPage:
                iconName = QStringLiteral("go-last-view-page");
                break;
            case LastPage:
                iconName = QStringLiteral("go-first-view-page");
                break;
            case DocumentBack:
                iconName = QStringLiteral("go-next");
                break;
            case DocumentForward:
                iconName = QStringLiteral("go-previous");
                break;
            default:
                break;
            }
        }

        if (id == Donate) {
            const QString currencyCode = QLocale().currencySymbol(QLocale::CurrencyIsoCode).toLower();
            if (!currencyCode.isEmpty()) {
                iconName = QStringLiteral("help-donate-%1").arg(currencyCode);
            }
        }

        QIcon icon = iconName.isEmpty() ? QIcon() : QIcon::fromTheme(iconName);

        switch (id) {
        // Same as default, but with the app icon
        case AboutApp: {
            pAction = new QAction(parent);
            icon = qGuiApp->windowIcon();
            break;
        }

        default:
            pAction = new QAction(parent);
            break;
        }

        // Set the text before setting the MenuRole, as on OS X setText will do some heuristic role guessing.
        // This ensures user menu items get the intended role out of the list below.
        pAction->setText(sLabel);

        switch (id) {
        case Quit:
            pAction->setMenuRole(QAction::QuitRole);
            break;

        case Preferences:
            pAction->setMenuRole(QAction::PreferencesRole);
            break;

        case AboutApp:
            pAction->setMenuRole(QAction::AboutRole);
            break;

        default:
            pAction->setMenuRole(QAction::NoRole);
            break;
        }

        if (!pInfo->psToolTip.isEmpty()) {
            pAction->setToolTip(pInfo->psToolTip.toString());
        }
        pAction->setIcon(icon);

        QList<QKeySequence> cut = KStandardShortcut::shortcut(pInfo->idAccel);
        if (!cut.isEmpty()) {
            // emulate KActionCollection::setDefaultShortcuts to allow the use of "configure shortcuts"
            pAction->setShortcuts(cut);
            pAction->setProperty("defaultShortcuts", QVariant::fromValue(cut));
        }
        pAction->connect(KStandardShortcut::shortcutWatcher(),
                         &KStandardShortcut::StandardShortcutWatcher::shortcutChanged,
                         pAction,
                         [pAction, shortcut = pInfo->idAccel](KStandardShortcut::StandardShortcut id, const QList<QKeySequence> &newShortcut) {
                             if (id != shortcut) {
                                 return;
                             }
                             pAction->setShortcuts(newShortcut);
                             pAction->setProperty("defaultShortcuts", QVariant::fromValue(newShortcut));
                         });

        pAction->setObjectName(pInfo->psName.toString());
    }

    if (pAction && parent && parent->inherits("KActionCollection")) {
        QMetaObject::invokeMethod(parent, "addAction", Q_ARG(QString, pAction->objectName()), Q_ARG(QAction *, pAction));
    }

    return pAction;
}

QAction *create(StandardAction id, const QObject *recvr, const char *slot, QObject *parent)
{
    QAction *pAction = _k_createInternal(id, parent);
    if (recvr && slot) {
        if (id == OpenRecent) {
            // FIXME QAction port: probably a good idea to find a cleaner way to do this
            // Open Recent is a special case - provide the selected URL
            QObject::connect(pAction, SIGNAL(urlSelected(QUrl)), recvr, slot);
        } else if (id == ConfigureToolbars) { // #200815
            QObject::connect(pAction, SIGNAL(triggered(bool)), recvr, slot, Qt::QueuedConnection);
        } else {
            QObject::connect(pAction, SIGNAL(triggered(bool)), recvr, slot);
        }
    }
    return pAction;
}

QString name(StandardAction id)
{
    const KirigamiStandardActionInfo *pInfo = infoPtr(id);
    return (pInfo) ? pInfo->psName.toString() : QString();
}

QAction *openNew(const QObject *recvr, const char *slot, QObject *parent)
{
    return KirigamiStandardAction::create(New, recvr, slot, parent);
}

QAction *open(const QObject *recvr, const char *slot, QObject *parent)
{
    return KirigamiStandardAction::create(Open, recvr, slot, parent);
}

QAction *save(const QObject *recvr, const char *slot, QObject *parent)
{
    return KirigamiStandardAction::create(Save, recvr, slot, parent);
}

QAction *saveAs(const QObject *recvr, const char *slot, QObject *parent)
{
    return KirigamiStandardAction::create(SaveAs, recvr, slot, parent);
}

QAction *revert(const QObject *recvr, const char *slot, QObject *parent)
{
    return KirigamiStandardAction::create(Revert, recvr, slot, parent);
}

QAction *print(const QObject *recvr, const char *slot, QObject *parent)
{
    return KirigamiStandardAction::create(Print, recvr, slot, parent);
}

QAction *printPreview(const QObject *recvr, const char *slot, QObject *parent)
{
    return KirigamiStandardAction::create(PrintPreview, recvr, slot, parent);
}

QAction *close(const QObject *recvr, const char *slot, QObject *parent)
{
    return KirigamiStandardAction::create(Close, recvr, slot, parent);
}

QAction *mail(const QObject *recvr, const char *slot, QObject *parent)
{
    return KirigamiStandardAction::create(Mail, recvr, slot, parent);
}

QAction *quit(const QObject *recvr, const char *slot, QObject *parent)
{
    return KirigamiStandardAction::create(Quit, recvr, slot, parent);
}

QAction *undo(const QObject *recvr, const char *slot, QObject *parent)
{
    return KirigamiStandardAction::create(Undo, recvr, slot, parent);
}

QAction *redo(const QObject *recvr, const char *slot, QObject *parent)
{
    return KirigamiStandardAction::create(Redo, recvr, slot, parent);
}

QAction *cut(const QObject *recvr, const char *slot, QObject *parent)
{
    return KirigamiStandardAction::create(Cut, recvr, slot, parent);
}

QAction *copy(const QObject *recvr, const char *slot, QObject *parent)
{
    return KirigamiStandardAction::create(Copy, recvr, slot, parent);
}

QAction *paste(const QObject *recvr, const char *slot, QObject *parent)
{
    return KirigamiStandardAction::create(Paste, recvr, slot, parent);
}

QAction *clear(const QObject *recvr, const char *slot, QObject *parent)
{
    return KirigamiStandardAction::create(Clear, recvr, slot, parent);
}

QAction *selectAll(const QObject *recvr, const char *slot, QObject *parent)
{
    return KirigamiStandardAction::create(SelectAll, recvr, slot, parent);
}

QAction *deselect(const QObject *recvr, const char *slot, QObject *parent)
{
    return KirigamiStandardAction::create(Deselect, recvr, slot, parent);
}

QAction *find(const QObject *recvr, const char *slot, QObject *parent)
{
    return KirigamiStandardAction::create(Find, recvr, slot, parent);
}

QAction *findNext(const QObject *recvr, const char *slot, QObject *parent)
{
    return KirigamiStandardAction::create(FindNext, recvr, slot, parent);
}

QAction *findPrev(const QObject *recvr, const char *slot, QObject *parent)
{
    return KirigamiStandardAction::create(FindPrev, recvr, slot, parent);
}

QAction *replace(const QObject *recvr, const char *slot, QObject *parent)
{
    return KirigamiStandardAction::create(Replace, recvr, slot, parent);
}

QAction *actualSize(const QObject *recvr, const char *slot, QObject *parent)
{
    return KirigamiStandardAction::create(ActualSize, recvr, slot, parent);
}

QAction *fitToPage(const QObject *recvr, const char *slot, QObject *parent)
{
    return KirigamiStandardAction::create(FitToPage, recvr, slot, parent);
}

QAction *fitToWidth(const QObject *recvr, const char *slot, QObject *parent)
{
    return KirigamiStandardAction::create(FitToWidth, recvr, slot, parent);
}

QAction *fitToHeight(const QObject *recvr, const char *slot, QObject *parent)
{
    return KirigamiStandardAction::create(FitToHeight, recvr, slot, parent);
}

QAction *zoomIn(const QObject *recvr, const char *slot, QObject *parent)
{
    return KirigamiStandardAction::create(ZoomIn, recvr, slot, parent);
}

QAction *zoomOut(const QObject *recvr, const char *slot, QObject *parent)
{
    return KirigamiStandardAction::create(ZoomOut, recvr, slot, parent);
}

QAction *zoom(const QObject *recvr, const char *slot, QObject *parent)
{
    return KirigamiStandardAction::create(Zoom, recvr, slot, parent);
}

QAction *redisplay(const QObject *recvr, const char *slot, QObject *parent)
{
    return KirigamiStandardAction::create(Redisplay, recvr, slot, parent);
}

QAction *up(const QObject *recvr, const char *slot, QObject *parent)
{
    return KirigamiStandardAction::create(Up, recvr, slot, parent);
}

QAction *back(const QObject *recvr, const char *slot, QObject *parent)
{
    return KirigamiStandardAction::create(Back, recvr, slot, parent);
}

QAction *forward(const QObject *recvr, const char *slot, QObject *parent)
{
    return KirigamiStandardAction::create(Forward, recvr, slot, parent);
}

QAction *home(const QObject *recvr, const char *slot, QObject *parent)
{
    return KirigamiStandardAction::create(Home, recvr, slot, parent);
}

QAction *prior(const QObject *recvr, const char *slot, QObject *parent)
{
    return KirigamiStandardAction::create(Prior, recvr, slot, parent);
}

QAction *next(const QObject *recvr, const char *slot, QObject *parent)
{
    return KirigamiStandardAction::create(Next, recvr, slot, parent);
}

QAction *goTo(const QObject *recvr, const char *slot, QObject *parent)
{
    return KirigamiStandardAction::create(Goto, recvr, slot, parent);
}

QAction *gotoPage(const QObject *recvr, const char *slot, QObject *parent)
{
    return KirigamiStandardAction::create(GotoPage, recvr, slot, parent);
}

QAction *gotoLine(const QObject *recvr, const char *slot, QObject *parent)
{
    return KirigamiStandardAction::create(GotoLine, recvr, slot, parent);
}

QAction *firstPage(const QObject *recvr, const char *slot, QObject *parent)
{
    return KirigamiStandardAction::create(FirstPage, recvr, slot, parent);
}

QAction *lastPage(const QObject *recvr, const char *slot, QObject *parent)
{
    return KirigamiStandardAction::create(LastPage, recvr, slot, parent);
}

QAction *documentBack(const QObject *recvr, const char *slot, QObject *parent)
{
    return KirigamiStandardAction::create(DocumentBack, recvr, slot, parent);
}

QAction *documentForward(const QObject *recvr, const char *slot, QObject *parent)
{
    return KirigamiStandardAction::create(DocumentForward, recvr, slot, parent);
}

QAction *addBookmark(const QObject *recvr, const char *slot, QObject *parent)
{
    return KirigamiStandardAction::create(AddBookmark, recvr, slot, parent);
}

QAction *editBookmarks(const QObject *recvr, const char *slot, QObject *parent)
{
    return KirigamiStandardAction::create(EditBookmarks, recvr, slot, parent);
}

QAction *spelling(const QObject *recvr, const char *slot, QObject *parent)
{
    return KirigamiStandardAction::create(Spelling, recvr, slot, parent);
}

static QAction *buildAutomaticAction(QObject *parent, StandardAction id, const char *slot)
{
    const KirigamiStandardActionInfo *p = infoPtr(id);
    if (!p) {
        return nullptr;
    }

    AutomaticAction *action = new AutomaticAction(QIcon::fromTheme(p->psIconName.toString()), p->psLabel.toString(), p->idAccel, slot, parent);

    action->setObjectName(p->psName.toString());
    if (!p->psToolTip.isEmpty()) {
        action->setToolTip(p->psToolTip.toString());
    }

    if (parent && parent->inherits("KActionCollection")) {
        QMetaObject::invokeMethod(parent, "addAction", Q_ARG(QString, action->objectName()), Q_ARG(QAction *, action));
    }

    return action;
}

QAction *cut(QObject *parent)
{
    return buildAutomaticAction(parent, Cut, SLOT(cut()));
}

QAction *copy(QObject *parent)
{
    return buildAutomaticAction(parent, Copy, SLOT(copy()));
}

QAction *paste(QObject *parent)
{
    return buildAutomaticAction(parent, Paste, SLOT(paste()));
}

QAction *clear(QObject *parent)
{
    return buildAutomaticAction(parent, Clear, SLOT(clear()));
}

QAction *selectAll(QObject *parent)
{
    return buildAutomaticAction(parent, SelectAll, SLOT(selectAll()));
}

KirigamiToggleAction *showMenubar(const QObject *recvr, const char *slot, QObject *parent)
{
    QAction *ret = KirigamiStandardAction::create(ShowMenubar, recvr, slot, parent);
    Q_ASSERT(qobject_cast<KirigamiToggleAction *>(ret));
    return static_cast<KirigamiToggleAction *>(ret);
}

QAction *keyBindings(const QObject *recvr, const char *slot, QObject *parent)
{
    return KirigamiStandardAction::create(KeyBindings, recvr, slot, parent);
}

QAction *preferences(const QObject *recvr, const char *slot, QObject *parent)
{
    return KirigamiStandardAction::create(Preferences, recvr, slot, parent);
}

QAction *configureToolbars(const QObject *recvr, const char *slot, QObject *parent)
{
    return KirigamiStandardAction::create(ConfigureToolbars, recvr, slot, parent);
}

QAction *configureNotifications(const QObject *recvr, const char *slot, QObject *parent)
{
    return KirigamiStandardAction::create(ConfigureNotifications, recvr, slot, parent);
}

QAction *helpContents(const QObject *recvr, const char *slot, QObject *parent)
{
    return KirigamiStandardAction::create(HelpContents, recvr, slot, parent);
}

QAction *whatsThis(const QObject *recvr, const char *slot, QObject *parent)
{
    return KirigamiStandardAction::create(WhatsThis, recvr, slot, parent);
}

QAction *reportBug(const QObject *recvr, const char *slot, QObject *parent)
{
    return KirigamiStandardAction::create(ReportBug, recvr, slot, parent);
}

QAction *switchApplicationLanguage(const QObject *recvr, const char *slot, QObject *parent)
{
    return KirigamiStandardAction::create(SwitchApplicationLanguage, recvr, slot, parent);
}

QAction *aboutApp(const QObject *recvr, const char *slot, QObject *parent)
{
    return KirigamiStandardAction::create(AboutApp, recvr, slot, parent);
}

QAction *aboutKDE(const QObject *recvr, const char *slot, QObject *parent)
{
    return KirigamiStandardAction::create(AboutKDE, recvr, slot, parent);
}

QAction *deleteFile(const QObject *recvr, const char *slot, QObject *parent)
{
    return KirigamiStandardAction::create(DeleteFile, recvr, slot, parent);
}

QAction *renameFile(const QObject *recvr, const char *slot, QObject *parent)
{
    return KirigamiStandardAction::create(RenameFile, recvr, slot, parent);
}

QAction *moveToTrash(const QObject *recvr, const char *slot, QObject *parent)
{
    return KirigamiStandardAction::create(MoveToTrash, recvr, slot, parent);
}

QAction *donate(const QObject *recvr, const char *slot, QObject *parent)
{
    return KirigamiStandardAction::create(Donate, recvr, slot, parent);
}
}
