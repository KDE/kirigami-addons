/*
    This file is part of the KDE libraries
    SPDX-FileCopyrightText: 1999, 2000 Kurt Granroth <granroth@kde.org>
    SPDX-FileCopyrightText: 2001, 2002 Ellis Whitehead <ellis@kde.org>

    SPDX-License-Identifier: LGPL-2.0-only
*/
#pragma once

#include <QAction>
#include <QList>
#include <QStringList>

#include <KStandardShortcut>
#include <kirigamiaddonsbaseapp_export.h>
#include <kirigamitoggleaction.h>

#include <optional>
#include <type_traits>

class QObject;
class QAction;

/**
 * Convenience methods to access all standard KDE actions.
 *
 * These actions should be used instead of hardcoding menubar and
 * toolbar items.  Using these actions helps your application easily
 * conform to the <a href="https://develop.kde.org/hig/">KDE Human Interface Guidelines</a>.
 *
 * All of the documentation for QAction holds for KirigamiStandardAction
 * also.  When in doubt on how things work, check the QAction
 * documentation first.
 * Please note that calling any of these methods automatically adds the action
 * to the actionCollection() of the QObject given by the 'parent' parameter.
 *
 * <b>Simple Example:</b>\n
 *
 * In general, using standard actions should be a drop in replacement
 * for regular actions. For example, if you previously had:
 * @code
 * QAction *newAct = new QAction(QIcon::fromTheme("document-new"),
 *                               i18n("&New"),
 *                               this);
 * newAct->setShortcut(KStandardShortcut::shortcut(KStandardShortcut::New).constFirst());
 * connect(newAct, &QAction::triggered, this, &ClassFoo::fileNew);
 * @endcode
 *
 * You can replace it with:
 * @code
 * QAction *newAct = KirigamiStandardAction::openNew(this, &ClassFoo::fileNew, this);
 * @endcode
 *
 * Alternatively you can instantiate the action using the StandardAction enums
 * provided.  This author can't think of a reason why you would want to, but, hey,
 * if you do, here's how:
 *
 * \code
 * QAction *newAct = KirigamiStandardAction::create(KirigamiStandardAction::New, this, &ClassFoo::fileNew, this);
 * \endcode
 *
 * <b>Relationship with KActionCollection from KXMLGui</b>\n
 *
 * If a KActionCollection is passed as the parent then the action will be
 * automatically added to that collection:
 * \code
 * QAction *cut = KirigamiStandardAction::cut(this, &ClassFoo::editCut, actionCollection());
 * \endcode
 *
 * Each action has a unique internal name which can be queried using the
 * name method.  For example KirigamiStandardAction::name(KirigamiStandardAction::Cut)
 * would return 'edit_cut'.  This name can be used as a unique identifier
 * for the actions.  So if you wanted to add an existing standard action
 * to an action collection you can do so like this:
 * \code
 * QAction *cut = KirigamiStandardAction::cut(this, &ClassFoo::editCut, this);
 * actionCollection()->addAction(KirigamiStandardAction::name(KirigamiStandardAction::Cut), cut);
 * \endcode
 *
 * You can then get a pointer to the action using
 * \code
 * QAction *cutPtr = actionCollection()->action(KirigamiStandardAction::name(KirigamiStandardAction::Cut));
 * \endcode
 *
 * @author Kurt Granroth <granroth@kde.org>
 */
namespace KirigamiStandardAction
{
/**
 * The standard menubar and toolbar actions.
 */
enum StandardAction {
    ActionNone,
    // File Menu
    New, ///< Create a new document or window.
    Open, ///< Open an existing file.
    OpenRecent, ///< Open a recently used document.
    Save, ///< Save the current document.
    SaveAs, ///< Save the current document under a different name.
    Revert, ///< Revert the current document to the last saved version.
    Close, ///< Close the current document.
    Print, ///< Print the current document.
    PrintPreview, ///< Show a print preview of the current document.
    Mail, ///< Send the current document by mail.
    Quit, ///< Quit the program.
    // Edit Menu
    Undo, ///< Undo the last operation.
    Redo, ///< Redo the last operation.
    Cut, ///< Cut selected area and store it in the clipboard.
    Copy, ///< Copy selected area and store it in the clipboard.
    Paste, ///< Paste the contents of clipboard at the current mouse or cursor.
    SelectAll, ///< Select all elements in the current document.
    Deselect, ///< Deselect any selected elements in the current document.
    Find, ///< Initiate a 'find' request in the current document.
    FindNext, ///< Find the next instance of a stored 'find'
    FindPrev, ///< Find a previous instance of a stored 'find'.
    Replace, ///< Find and replace matches.
    // View Menu
    ActualSize, ///< View the document at its actual size.
    FitToPage, ///< Fit the document view to the size of the current window.
    FitToWidth, ///< Fit the document view to the width of the current window.
    FitToHeight, ///< Fit the document view to the height of the current window.
    ZoomIn, ///< Zoom in the current document.
    ZoomOut, ///< Zoom out the current document.
    Zoom, ///< Select the current zoom level.
    Redisplay, ///< Redisplay or redraw the document.
    // Go Menu
    Up, ///< Move up (web style menu).
    Back, ///< Move back (web style menu).
    Forward, ///< Move forward (web style menu).
    Home, ///< Go to the "Home" position or document.
    Prior, ///< Scroll up one page.
    Next, ///< Scroll down one page.
    Goto, ///< Jump to some specific location in the document.
    GotoPage, ///< Go to a specific page.
    GotoLine, ///< Go to a specific line.
    FirstPage, ///< Jump to the first page.
    LastPage, ///< Jump to the last page.
    DocumentBack, ///< Move back (document style menu).
    DocumentForward, ///< Move forward (document style menu).
    // Bookmarks Menu
    AddBookmark, ///< Add the current page to the bookmarks tree.
    EditBookmarks, ///< Edit the application bookmarks.
    // Tools Menu
    Spelling, ///< Pop up the spell checker.
    // Settings Menu
    ShowMenubar, ///< Show/Hide the menubar.
    KeyBindings, ///< Display the configure key bindings dialog.
    Preferences, ///< Display the preferences/options dialog.
    ConfigureToolbars, ///< Display the toolbar configuration dialog.
    // Help Menu
    HelpContents, ///< Display the handbook of the application.
    WhatsThis, ///< Trigger the What's This cursor.
    ReportBug, ///< Open up the Report Bug dialog.
    AboutApp, ///< Display the application's About box.
    AboutKDE, ///< Display the About KDE dialog.
    // Other standard actions
    ConfigureNotifications, ///< Display the notifications configuration dialog.
    FullScreen, ///< Switch to/from full screen mode.
    Clear, ///< Clear the content of the focus widget.
    SwitchApplicationLanguage, ///< Display the Switch Application Language dialog.
    DeleteFile, ///< Permanently deletes files or folders. @since 5.25
    RenameFile, ///< Renames files or folders. @since 5.25
    MoveToTrash, ///< Moves files or folders to the trash. @since 5.25
    Donate, ///< Open donation page on kde.org. @since 5.26
};

/**
 * Creates an action corresponding to one of the
 * KirigamiStandardAction::StandardAction actions, which is connected to the given
 * object and @p slot, and is owned by @p parent.
 *
 * The signal that is connected to @p slot is triggered(bool), except for the case of
 * OpenRecent standard action, which uses the urlSelected(const QUrl &) signal of
 * KRecentFilesAction.
 *
 * @param id The StandardAction identifier to create a QAction for.
 * @param recvr The QObject to receive the signal, or @c nullptr if no notification
 *              is needed.
 * @param slot  The slot to connect the signal to (remember to use the SLOT() macro).
 * @param parent The QObject that should own the created QAction, or @c nullptr if no parent will
 *               own the QAction returned (ensure you delete it manually in this case).
 */
KIRIGAMIADDONSBASEAPP_EXPORT QAction *create(StandardAction id, const QObject *recvr, const char *slot, QObject *parent);

/**
 * @internal
 */
KIRIGAMIADDONSBASEAPP_EXPORT QAction *_k_createInternal(StandardAction id, QObject *parent);

/**
 * This overloads create() to allow using the new connect syntax
 * @note if you use @c OpenRecent as @p id, you should manually connect to the urlSelected(const QUrl &)
 * signal of the returned KRecentFilesAction instead or use KirigamiStandardAction::openRecent(Receiver *, Func).
 *
 * If not explicitly specified, @p connectionType will be AutoConnection for all actions
 * except for ConfigureToolbars it will be QueuedConnection.
 *
 * @see create(StandardAction, const QObject *, const char *, QObject *)
 * @since 5.23 (The connectionType argument was added in 5.95)
 */
#ifdef K_DOXYGEN
inline QAction *create(StandardAction id, const QObject *recvr, Func slot, QObject *parent, std::optional<Qt::ConnectionType> connectionType = std::nullopt)
#else
template<class Receiver, class Func>
inline typename std::enable_if<!std::is_convertible<Func, const char *>::value, QAction>::type *
create(StandardAction id, const Receiver *recvr, Func slot, QObject *parent, std::optional<Qt::ConnectionType> connectionType = std::nullopt)
#endif
{
    QAction *action = _k_createInternal(id, parent);
    // ConfigureToolbars is special because of bug #200815
    const Qt::ConnectionType defaultConnectionType = (id == ConfigureToolbars) ? Qt::QueuedConnection : Qt::AutoConnection;
    QObject::connect(action, &QAction::triggered, recvr, slot, connectionType.value_or(defaultConnectionType));
    return action;
}

/**
 * This will return the internal name of a given standard action.
 */
KIRIGAMIADDONSBASEAPP_EXPORT QString name(StandardAction id);

/**
 * Returns a list of all standard names. Used by KAccelManager
 * to give those higher weight.
 */
KIRIGAMIADDONSBASEAPP_EXPORT QStringList stdNames();

/**
 * Returns a list of all actionIds.
 *
 * @since 4.2
 */
KIRIGAMIADDONSBASEAPP_EXPORT QList<StandardAction> actionIds();

/**
 * Returns the standardshortcut associated with @a actionId.
 *
 * @param id    The identifier whose associated shortcut is wanted.
 *
 * @since 4.2
 */
KIRIGAMIADDONSBASEAPP_EXPORT KStandardShortcut::StandardShortcut shortcutForActionId(StandardAction id);

// clang-format off
// we have to disable the templated function for const char* as Func, since it is ambiguous otherwise
// TODO: KF6: unify const char* version and new style by removing std::enable_if
#ifdef K_DOXYGEN
#define KSTANDARDACTION_WITH_NEW_STYLE_CONNECT(name, enumValue) \
    inline QAction *name(const QObject *recvr, Func slot, QObject *parent);
#else
#define KSTANDARDACTION_WITH_NEW_STYLE_CONNECT(name, enumValue) \
    template<class Receiver, class Func> \
    inline typename std::enable_if<!std::is_convertible<Func, const char*>::value, QAction>::type *name(const Receiver *recvr, Func slot, QObject *parent) \
    { return create(enumValue, recvr, slot, parent); }
#endif
// clang-format on

/**
 * Create a new document or window.
 */
KIRIGAMIADDONSBASEAPP_EXPORT QAction *openNew(const QObject *recvr, const char *slot, QObject *parent);

/**
 * Create a new document or window.
 * @since 5.23
 */
KSTANDARDACTION_WITH_NEW_STYLE_CONNECT(openNew, New)

/**
 * Open an existing file.
 */
KIRIGAMIADDONSBASEAPP_EXPORT QAction *open(const QObject *recvr, const char *slot, QObject *parent);

/**
 * Open an existing file.
 * @since 5.23
 */
KSTANDARDACTION_WITH_NEW_STYLE_CONNECT(open, Open)

/**
 * Save the current document.
 */
KIRIGAMIADDONSBASEAPP_EXPORT QAction *save(const QObject *recvr, const char *slot, QObject *parent);

/**
 * Save the current document.
 * @since 5.23
 */
KSTANDARDACTION_WITH_NEW_STYLE_CONNECT(save, Save)

/**
 * Save the current document under a different name.
 */
KIRIGAMIADDONSBASEAPP_EXPORT QAction *saveAs(const QObject *recvr, const char *slot, QObject *parent);

/**
 * Save the current document under a different name.
 * @since 5.23
 */
KSTANDARDACTION_WITH_NEW_STYLE_CONNECT(saveAs, SaveAs)

/**
 * Revert the current document to the last saved version
 * (essentially will undo all changes).
 */
KIRIGAMIADDONSBASEAPP_EXPORT QAction *revert(const QObject *recvr, const char *slot, QObject *parent);

/**
 * Revert the current document to the last saved version
 * (essentially will undo all changes).
 * @since 5.23
 */
KSTANDARDACTION_WITH_NEW_STYLE_CONNECT(revert, Revert)

/**
 * Close the current document.
 */
KIRIGAMIADDONSBASEAPP_EXPORT QAction *close(const QObject *recvr, const char *slot, QObject *parent);

/**
 * Close the current document.
 * @since 5.23
 */
KSTANDARDACTION_WITH_NEW_STYLE_CONNECT(close, Close)

/**
 * Print the current document.
 */
KIRIGAMIADDONSBASEAPP_EXPORT QAction *print(const QObject *recvr, const char *slot, QObject *parent);

/**
 * Print the current document.
 * @since 5.23
 */
KSTANDARDACTION_WITH_NEW_STYLE_CONNECT(print, Print)

/**
 * Show a print preview of the current document.
 */
KIRIGAMIADDONSBASEAPP_EXPORT QAction *printPreview(const QObject *recvr, const char *slot, QObject *parent);

/**
 * Show a print preview of the current document.
 * @since 5.23
 */
KSTANDARDACTION_WITH_NEW_STYLE_CONNECT(printPreview, PrintPreview)

/**
 * Send the current document by mail.
 */
KIRIGAMIADDONSBASEAPP_EXPORT QAction *mail(const QObject *recvr, const char *slot, QObject *parent);

/**
 * Mail this document.
 * @since 5.23
 */
KSTANDARDACTION_WITH_NEW_STYLE_CONNECT(mail, Mail)

/**
 * Quit the program.
 *
 * Note that you probably want to connect this action to either QWidget::close()
 * or QApplication::closeAllWindows(), but not QApplication::quit(), so that
 * KMainWindow::queryClose() is called on any open window (to warn the user
 * about unsaved changes for example).
 */
KIRIGAMIADDONSBASEAPP_EXPORT QAction *quit(const QObject *recvr, const char *slot, QObject *parent);

/**
 * Quit the program.
 * @see quit(const QObject *recvr, const char *slot, QObject *parent)
 * @since 5.23
 */
KSTANDARDACTION_WITH_NEW_STYLE_CONNECT(quit, Quit)

/**
 * Undo the last operation.
 */
KIRIGAMIADDONSBASEAPP_EXPORT QAction *undo(const QObject *recvr, const char *slot, QObject *parent);

/**
 * Undo the last operation.
 * @since 5.23
 */
KSTANDARDACTION_WITH_NEW_STYLE_CONNECT(undo, Undo)

/**
 * Redo the last operation.
 */
KIRIGAMIADDONSBASEAPP_EXPORT QAction *redo(const QObject *recvr, const char *slot, QObject *parent);

/**
 * Redo the last operation.
 * @since 5.23
 */
KSTANDARDACTION_WITH_NEW_STYLE_CONNECT(redo, Redo)

/**
 * Cut selected area and store it in the clipboard.
 * Calls cut() on the widget with the current focus.
 */
KIRIGAMIADDONSBASEAPP_EXPORT QAction *cut(QObject *parent);

/**
 * Copy selected area and store it in the clipboard.
 * Calls copy() on the widget with the current focus.
 */
KIRIGAMIADDONSBASEAPP_EXPORT QAction *copy(QObject *parent);

/**
 * Paste the contents of clipboard at the current mouse or cursor
 * Calls paste() on the widget with the current focus.
 */
KIRIGAMIADDONSBASEAPP_EXPORT QAction *paste(QObject *parent);

/**
 * Calls selectAll() on the widget with the current focus.
 */
KIRIGAMIADDONSBASEAPP_EXPORT QAction *selectAll(QObject *parent);

/**
 * Cut selected area and store it in the clipboard.
 */
KIRIGAMIADDONSBASEAPP_EXPORT QAction *cut(const QObject *recvr, const char *slot, QObject *parent);

/**
 * Cut selected area and store it in the clipboard.
 * @since 5.23
 */
KSTANDARDACTION_WITH_NEW_STYLE_CONNECT(cut, Cut)

/**
 * Copy the selected area into the clipboard.
 */
KIRIGAMIADDONSBASEAPP_EXPORT QAction *copy(const QObject *recvr, const char *slot, QObject *parent);

/**
 * Copy the selected area into the clipboard.
 * @since 5.23
 */
KSTANDARDACTION_WITH_NEW_STYLE_CONNECT(copy, Copy)

/**
 * Paste the contents of clipboard at the current mouse or cursor
 * position.
 */
KIRIGAMIADDONSBASEAPP_EXPORT QAction *paste(const QObject *recvr, const char *slot, QObject *parent);

/**
 * Paste the contents of clipboard at the current mouse or cursor
 * position.
 * @since 5.23
 */
KSTANDARDACTION_WITH_NEW_STYLE_CONNECT(paste, Paste)

/**
 * Clear the content of the focus widget
 */
KIRIGAMIADDONSBASEAPP_EXPORT QAction *clear(const QObject *recvr, const char *slot, QObject *parent);

/**
 * Clear the content of the focus widget
 * @since 5.23
 */
KSTANDARDACTION_WITH_NEW_STYLE_CONNECT(clear, Clear)

/**
 * Select all elements in the current document.
 */
KIRIGAMIADDONSBASEAPP_EXPORT QAction *selectAll(const QObject *recvr, const char *slot, QObject *parent);

/**
 * Select all elements in the current document.
 * @since 5.23
 */
KSTANDARDACTION_WITH_NEW_STYLE_CONNECT(selectAll, SelectAll)

/**
 * Deselect any selected elements in the current document.
 */
KIRIGAMIADDONSBASEAPP_EXPORT QAction *deselect(const QObject *recvr, const char *slot, QObject *parent);

/**
 * Deselect any selected elements in the current document.
 * @since 5.23
 */
KSTANDARDACTION_WITH_NEW_STYLE_CONNECT(deselect, Deselect)

/**
 * Initiate a 'find' request in the current document.
 */
KIRIGAMIADDONSBASEAPP_EXPORT QAction *find(const QObject *recvr, const char *slot, QObject *parent);

/**
 * Initiate a 'find' request in the current document.
 * @since 5.23
 */
KSTANDARDACTION_WITH_NEW_STYLE_CONNECT(find, Find)

/**
 * Find the next instance of a stored 'find'.
 */
KIRIGAMIADDONSBASEAPP_EXPORT QAction *findNext(const QObject *recvr, const char *slot, QObject *parent);

/**
 * Find the next instance of a stored 'find'.
 * @since 5.23
 */
KSTANDARDACTION_WITH_NEW_STYLE_CONNECT(findNext, FindNext)

/**
 * Find a previous instance of a stored 'find'.
 */
KIRIGAMIADDONSBASEAPP_EXPORT QAction *findPrev(const QObject *recvr, const char *slot, QObject *parent);

/**
 * Find a previous instance of a stored 'find'.
 * @since 5.23
 */
KSTANDARDACTION_WITH_NEW_STYLE_CONNECT(findPrev, FindPrev)

/**
 * Find and replace matches.
 */
KIRIGAMIADDONSBASEAPP_EXPORT QAction *replace(const QObject *recvr, const char *slot, QObject *parent);

/**
 * Find and replace matches.
 * @since 5.23
 */
KSTANDARDACTION_WITH_NEW_STYLE_CONNECT(replace, Replace)

/**
 * View the document at its actual size.
 */
KIRIGAMIADDONSBASEAPP_EXPORT QAction *actualSize(const QObject *recvr, const char *slot, QObject *parent);

/**
 * View the document at its actual size.
 * @since 5.23
 */
KSTANDARDACTION_WITH_NEW_STYLE_CONNECT(actualSize, ActualSize)

/**
 * Fit the document view to the size of the current window.
 */
KIRIGAMIADDONSBASEAPP_EXPORT QAction *fitToPage(const QObject *recvr, const char *slot, QObject *parent);

/**
 * Fit the document view to the size of the current window.
 * @since 5.23
 */
KSTANDARDACTION_WITH_NEW_STYLE_CONNECT(fitToPage, FitToPage)

/**
 * Fit the document view to the width of the current window.
 */
KIRIGAMIADDONSBASEAPP_EXPORT QAction *fitToWidth(const QObject *recvr, const char *slot, QObject *parent);

/**
 * Fit the document view to the width of the current window.
 * @since 5.23
 */
KSTANDARDACTION_WITH_NEW_STYLE_CONNECT(fitToWidth, FitToWidth)

/**
 * Fit the document view to the height of the current window.
 */
KIRIGAMIADDONSBASEAPP_EXPORT QAction *fitToHeight(const QObject *recvr, const char *slot, QObject *parent);

/**
 * Fit the document view to the height of the current window.
 * @since 5.23
 */
KSTANDARDACTION_WITH_NEW_STYLE_CONNECT(fitToHeight, FitToHeight)

/**
 * Zoom in the current document view.
 */
KIRIGAMIADDONSBASEAPP_EXPORT QAction *zoomIn(const QObject *recvr, const char *slot, QObject *parent);

/**
 * Zoom in the current document view.
 * @since 5.23
 */
KSTANDARDACTION_WITH_NEW_STYLE_CONNECT(zoomIn, ZoomIn)

/**
 * Zoom out the current document view.
 */
KIRIGAMIADDONSBASEAPP_EXPORT QAction *zoomOut(const QObject *recvr, const char *slot, QObject *parent);

/**
 * Zoom out the current document view.
 * @since 5.23
 */
KSTANDARDACTION_WITH_NEW_STYLE_CONNECT(zoomOut, ZoomOut)

/**
 * Select the current zoom level.
 */
KIRIGAMIADDONSBASEAPP_EXPORT QAction *zoom(const QObject *recvr, const char *slot, QObject *parent);

/**
 * Select the current zoom level.
 * @since 5.23
 */
KSTANDARDACTION_WITH_NEW_STYLE_CONNECT(zoom, Zoom)

/**
 * Redisplay or redraw the document.
 */
KIRIGAMIADDONSBASEAPP_EXPORT QAction *redisplay(const QObject *recvr, const char *slot, QObject *parent);

/**
 * Redisplay or redraw the document.
 * @since 5.23
 */
KSTANDARDACTION_WITH_NEW_STYLE_CONNECT(redisplay, Redisplay)

/**
 * Move up (web style menu).
 */
KIRIGAMIADDONSBASEAPP_EXPORT QAction *up(const QObject *recvr, const char *slot, QObject *parent);

/**
 * Move up (web style menu).
 * @since 5.23
 */
KSTANDARDACTION_WITH_NEW_STYLE_CONNECT(up, Up)

/**
 * Move back (web style menu).
 */
KIRIGAMIADDONSBASEAPP_EXPORT QAction *back(const QObject *recvr, const char *slot, QObject *parent);

/**
 * Move back (web style menu).
 * @since 5.23
 */
KSTANDARDACTION_WITH_NEW_STYLE_CONNECT(back, Back)

/**
 * Move forward (web style menu).
 */
KIRIGAMIADDONSBASEAPP_EXPORT QAction *forward(const QObject *recvr, const char *slot, QObject *parent);

/**
 * Move forward (web style menu).
 * @since 5.23
 */
KSTANDARDACTION_WITH_NEW_STYLE_CONNECT(forward, Forward)

/**
 * Go to the "Home" position or document.
 */
KIRIGAMIADDONSBASEAPP_EXPORT QAction *home(const QObject *recvr, const char *slot, QObject *parent);

/**
 * Go to the "Home" position or document.
 * @since 5.23
 */
KSTANDARDACTION_WITH_NEW_STYLE_CONNECT(home, Home)

/**
 * Scroll up one page.
 */
KIRIGAMIADDONSBASEAPP_EXPORT QAction *prior(const QObject *recvr, const char *slot, QObject *parent);

/**
 * Scroll up one page.
 * @since 5.23
 */
KSTANDARDACTION_WITH_NEW_STYLE_CONNECT(prior, Prior)

/**
 * Scroll down one page.
 */
KIRIGAMIADDONSBASEAPP_EXPORT QAction *next(const QObject *recvr, const char *slot, QObject *parent);

/**
 * Scroll down one page.
 * @since 5.23
 */
KSTANDARDACTION_WITH_NEW_STYLE_CONNECT(next, Next)

/**
 * Jump to some specific location in the document.
 */
KIRIGAMIADDONSBASEAPP_EXPORT QAction *goTo(const QObject *recvr, const char *slot, QObject *parent);

/**
 * Jump to some specific location in the document.
 * @since 5.23
 */
KSTANDARDACTION_WITH_NEW_STYLE_CONNECT(goTo, Goto)

/**
 * Go to a specific page.
 */
KIRIGAMIADDONSBASEAPP_EXPORT QAction *gotoPage(const QObject *recvr, const char *slot, QObject *parent);

/**
 * Go to a specific page.
 * @since 5.23
 */
KSTANDARDACTION_WITH_NEW_STYLE_CONNECT(gotoPage, GotoPage)

/**
 * Go to a specific line.
 */
KIRIGAMIADDONSBASEAPP_EXPORT QAction *gotoLine(const QObject *recvr, const char *slot, QObject *parent);

/**
 * Go to a specific line.
 * @since 5.23
 */
KSTANDARDACTION_WITH_NEW_STYLE_CONNECT(gotoLine, GotoLine)

/**
 * Jump to the first page.
 */
KIRIGAMIADDONSBASEAPP_EXPORT QAction *firstPage(const QObject *recvr, const char *slot, QObject *parent);

/**
 * Jump to the first page.
 * @since 5.23
 */
KSTANDARDACTION_WITH_NEW_STYLE_CONNECT(firstPage, FirstPage)

/**
 * Jump to the last page.
 */
KIRIGAMIADDONSBASEAPP_EXPORT QAction *lastPage(const QObject *recvr, const char *slot, QObject *parent);

/**
 * Jump to the last page.
 * @since 5.23
 */
KSTANDARDACTION_WITH_NEW_STYLE_CONNECT(lastPage, LastPage)

/**
 * Move back (document style menu).
 */
KIRIGAMIADDONSBASEAPP_EXPORT QAction *documentBack(const QObject *recvr, const char *slot, QObject *parent);

/**
 * Move back (document style menu).
 * @since 5.23
 */
KSTANDARDACTION_WITH_NEW_STYLE_CONNECT(documentBack, DocumentBack)

/**
 * Move forward (document style menu).
 */
KIRIGAMIADDONSBASEAPP_EXPORT QAction *documentForward(const QObject *recvr, const char *slot, QObject *parent);

/**
 * Move forward (document style menu).
 * @since 5.23
 */
KSTANDARDACTION_WITH_NEW_STYLE_CONNECT(documentForward, DocumentForward)

/**
 * Add the current page to the bookmarks tree.
 */
KIRIGAMIADDONSBASEAPP_EXPORT QAction *addBookmark(const QObject *recvr, const char *slot, QObject *parent);

/**
 * Add the current page to the bookmarks tree.
 * @since 5.23
 */
KSTANDARDACTION_WITH_NEW_STYLE_CONNECT(addBookmark, AddBookmark)

/**
 * Edit the application bookmarks.
 */
KIRIGAMIADDONSBASEAPP_EXPORT QAction *editBookmarks(const QObject *recvr, const char *slot, QObject *parent);

/**
 * Edit the application bookmarks.
 * @since 5.23
 */
KSTANDARDACTION_WITH_NEW_STYLE_CONNECT(editBookmarks, EditBookmarks)

/**
 * Pop up the spell checker.
 */
KIRIGAMIADDONSBASEAPP_EXPORT QAction *spelling(const QObject *recvr, const char *slot, QObject *parent);

/**
 * Pop up the spell checker.
 * @since 5.23
 */
KSTANDARDACTION_WITH_NEW_STYLE_CONNECT(spelling, Spelling)

/**
 * Show/Hide the menubar.
 */
KIRIGAMIADDONSBASEAPP_EXPORT KirigamiToggleAction *showMenubar(const QObject *recvr, const char *slot, QObject *parent);

/**
 * The same as showMenubar(const QObject *, const char *, QObject *), but using new-style connect syntax
 * @see showMenubar(const QObject *, const char *, QObject *)
 * @since 5.23
 */
#ifdef K_DOXYGEN
inline KToggleAction *showMenubar(const QObject *recvr, Func slot, QObject *parent)
#else
template<class Receiver, class Func>
inline typename std::enable_if<!std::is_convertible<Func, const char *>::value, KirigamiToggleAction>::type *
showMenubar(const Receiver *recvr, Func slot, QObject *parent)
#endif
{
    QAction *ret = create(ShowMenubar, recvr, slot, parent);
    Q_ASSERT(qobject_cast<KirigamiToggleAction *>(ret));
    return static_cast<KirigamiToggleAction *>(ret);
}

/**
 * Display the configure keyboard shortcuts dialog.
 *
 * Note that you might be able to use the pre-built KXMLGUIFactory's function:
 * @code
 * KirigamiStandardAction::keyBindings(guiFactory(), &KXMLGUIFactory::showConfigureShortcutsDialog, actionCollection());
 * @endcode
 *
 */
KIRIGAMIADDONSBASEAPP_EXPORT QAction *keyBindings(const QObject *recvr, const char *slot, QObject *parent);

/**
 * Display the configure key bindings dialog.
 * @see keyBindings(const QObject *recvr, const char *slot, QObject *parent)
 * @since 5.23
 */
KSTANDARDACTION_WITH_NEW_STYLE_CONNECT(keyBindings, KeyBindings)

/**
 * Display the preferences/options dialog.
 */
KIRIGAMIADDONSBASEAPP_EXPORT QAction *preferences(const QObject *recvr, const char *slot, QObject *parent);

/**
 * Display the preferences/options dialog.
 * @since 5.23
 */
KSTANDARDACTION_WITH_NEW_STYLE_CONNECT(preferences, Preferences)

/**
 * Display the toolbar configuration dialog.
 */
KIRIGAMIADDONSBASEAPP_EXPORT QAction *configureToolbars(const QObject *recvr, const char *slot, QObject *parent);

/**
 * Display the toolbar configuration dialog.
 * @since 5.23
 */
KSTANDARDACTION_WITH_NEW_STYLE_CONNECT(configureToolbars, ConfigureToolbars)

/**
 * Display the notifications configuration dialog.
 */
KIRIGAMIADDONSBASEAPP_EXPORT QAction *configureNotifications(const QObject *recvr, const char *slot, QObject *parent);

/**
 * Display the notifications configuration dialog.
 * @since 5.23
 */
KSTANDARDACTION_WITH_NEW_STYLE_CONNECT(configureNotifications, ConfigureNotifications)

/**
 * Display the Switch Application Language dialog.
 * @since 5.67
 */
KIRIGAMIADDONSBASEAPP_EXPORT QAction *switchApplicationLanguage(const QObject *recvr, const char *slot, QObject *parent);

/**
 * Display the Switch Application Language dialog.
 * @since 5.67
 */
KSTANDARDACTION_WITH_NEW_STYLE_CONNECT(switchApplicationLanguage, SwitchApplicationLanguage)

/**
 * Display the handbook of the application.
 */
KIRIGAMIADDONSBASEAPP_EXPORT QAction *helpContents(const QObject *recvr, const char *slot, QObject *parent);

/**
 * Display the handbook of the application.
 * @since 5.23
 */
KSTANDARDACTION_WITH_NEW_STYLE_CONNECT(helpContents, HelpContents)

/**
 * Trigger the What's This cursor.
 */
KIRIGAMIADDONSBASEAPP_EXPORT QAction *whatsThis(const QObject *recvr, const char *slot, QObject *parent);

/**
 * Trigger the What's This cursor.
 * @since 5.23
 */
KSTANDARDACTION_WITH_NEW_STYLE_CONNECT(whatsThis, WhatsThis)

/**
 * Open up the Report Bug dialog.
 */
KIRIGAMIADDONSBASEAPP_EXPORT QAction *reportBug(const QObject *recvr, const char *slot, QObject *parent);

/**
 * Open up the Report Bug dialog.
 * @since 5.23
 */
KSTANDARDACTION_WITH_NEW_STYLE_CONNECT(reportBug, ReportBug)

/**
 * Display the application's About box.
 */
KIRIGAMIADDONSBASEAPP_EXPORT QAction *aboutApp(const QObject *recvr, const char *slot, QObject *parent);

/**
 * Display the application's About box.
 * @since 5.23
 */
KSTANDARDACTION_WITH_NEW_STYLE_CONNECT(aboutApp, AboutApp)

/**
 * Display the About KDE dialog.
 */
KIRIGAMIADDONSBASEAPP_EXPORT QAction *aboutKDE(const QObject *recvr, const char *slot, QObject *parent);

/**
 * Display the About KDE dialog.
 * @since 5.23
 */
KSTANDARDACTION_WITH_NEW_STYLE_CONNECT(aboutKDE, AboutKDE)

/**
 * Permanently deletes files or folders.
 * @since 5.25
 */
KIRIGAMIADDONSBASEAPP_EXPORT QAction *deleteFile(const QObject *recvr, const char *slot, QObject *parent);

/**
 * Permanently deletes files or folders.
 * @since 5.25
 */
KSTANDARDACTION_WITH_NEW_STYLE_CONNECT(deleteFile, DeleteFile)

/**
 * Renames files or folders.
 * @since 5.25
 */
KIRIGAMIADDONSBASEAPP_EXPORT QAction *renameFile(const QObject *recvr, const char *slot, QObject *parent);

/**
 * Renames files or folders.
 * @since 5.25
 */
KSTANDARDACTION_WITH_NEW_STYLE_CONNECT(renameFile, RenameFile)

/**
 * Moves files or folders to the trash.
 * @since 5.25
 */
KIRIGAMIADDONSBASEAPP_EXPORT QAction *moveToTrash(const QObject *recvr, const char *slot, QObject *parent);

/**
 * Moves files or folders to the trash.
 * @since 5.25
 */
KSTANDARDACTION_WITH_NEW_STYLE_CONNECT(moveToTrash, MoveToTrash)

/**
 * Open donation page on kde.org.
 * @since 5.26
 */
KIRIGAMIADDONSBASEAPP_EXPORT QAction *donate(const QObject *recvr, const char *slot, QObject *parent);

/**
 * Open donation page on kde.org.
 * @since 5.26
 */
KSTANDARDACTION_WITH_NEW_STYLE_CONNECT(donate, Donate)
}
