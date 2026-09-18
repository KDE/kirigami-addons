// SPDX-FileCopyrightText: 2025 Marco Martin <notmart@gmail.com>
// SPDX-License-Identifier: LGPL-2.1-or-later

#pragma once

#include "actiondata.h"
#include <KStandardActions>

/*!
 * \qmltype StandardActionData
 * \inqmlmodule org.kde.kirigamiaddons.actions
 * \brief A declarative action based on a KDE standard action.
 *
 * StandardActionData provides the conventional name, label, icon and default
 * shortcut for the selected StandardAction. It must be declared as a child of
 * ActionCollection.
 *
 * \qml
 * KirigamiActions.ActionCollection {
 *     application: root.application
 *     KirigamiActions.StandardActionData {
 *         standardAction: KirigamiActions.StandardActionData.Copy
 *     }
 * }
 * \endqml
 *
 * \sa ActionCollection
 * \sa ActionData
 *
 * \since 1.14.0
 */
/*!
 * \class StandardActionData
 * \inmodule KirigamiAddonsActions
 * \internal Not exposed to C++; use the StandardActionData QML type.
 */
class StandardActionData : public ActionData
{
    Q_OBJECT
    QML_ELEMENT
    /*! \qmlproperty StandardAction StandardActionData::standardAction
     * The KDE standard action represented by this object.
     *
     * \since 1.14.0
     */
    Q_PROPERTY(StandardAction standardAction READ standardAction WRITE setStandardAction NOTIFY standardActionChanged FINAL REQUIRED)
public:
    enum StandardAction {
        ActionNone = KStandardActions::ActionNone,
        New = KStandardActions::New, Open = KStandardActions::Open, OpenRecent = KStandardActions::OpenRecent,
        Save = KStandardActions::Save, SaveAs = KStandardActions::SaveAs, Revert = KStandardActions::Revert,
        Close = KStandardActions::Close, Print = KStandardActions::Print, PrintPreview = KStandardActions::PrintPreview,
        Mail = KStandardActions::Mail, Quit = KStandardActions::Quit, Undo = KStandardActions::Undo,
        Redo = KStandardActions::Redo, Cut = KStandardActions::Cut, Copy = KStandardActions::Copy,
        Paste = KStandardActions::Paste, SelectAll = KStandardActions::SelectAll, Deselect = KStandardActions::Deselect,
        Find = KStandardActions::Find, FindNext = KStandardActions::FindNext, FindPrev = KStandardActions::FindPrev,
        Replace = KStandardActions::Replace, ActualSize = KStandardActions::ActualSize,
        FitToPage = KStandardActions::FitToPage, FitToWidth = KStandardActions::FitToWidth,
        FitToHeight = KStandardActions::FitToHeight, ZoomIn = KStandardActions::ZoomIn,
        ZoomOut = KStandardActions::ZoomOut, Zoom = KStandardActions::Zoom, Redisplay = KStandardActions::Redisplay,
        Up = KStandardActions::Up, Back = KStandardActions::Back, Forward = KStandardActions::Forward,
        Home = KStandardActions::Home, Prior = KStandardActions::Prior, Next = KStandardActions::Next,
        Goto = KStandardActions::Goto, GotoPage = KStandardActions::GotoPage, GotoLine = KStandardActions::GotoLine,
        FirstPage = KStandardActions::FirstPage, LastPage = KStandardActions::LastPage,
        DocumentBack = KStandardActions::DocumentBack, DocumentForward = KStandardActions::DocumentForward,
        AddBookmark = KStandardActions::AddBookmark, EditBookmarks = KStandardActions::EditBookmarks,
        Spelling = KStandardActions::Spelling, ShowMenubar = KStandardActions::ShowMenubar,
        ShowToolbar = KStandardActions::ShowToolbar, ShowStatusbar = KStandardActions::ShowStatusbar,
        KeyBindings = KStandardActions::KeyBindings, Preferences = KStandardActions::Preferences,
        ConfigureToolbars = KStandardActions::ConfigureToolbars, HelpContents = KStandardActions::HelpContents,
        WhatsThis = KStandardActions::WhatsThis, ReportBug = KStandardActions::ReportBug,
        AboutApp = KStandardActions::AboutApp, AboutKDE = KStandardActions::AboutKDE,
        ConfigureNotifications = KStandardActions::ConfigureNotifications,
        FullScreen = KStandardActions::FullScreen, Clear = KStandardActions::Clear,
        SwitchApplicationLanguage = KStandardActions::SwitchApplicationLanguage,
        DeleteFile = KStandardActions::DeleteFile, RenameFile = KStandardActions::RenameFile,
        MoveToTrash = KStandardActions::MoveToTrash, Donate = KStandardActions::Donate,
        HamburgerMenu = KStandardActions::HamburgerMenu
    };
    Q_ENUM(StandardAction)
    explicit StandardActionData(QObject *parent = nullptr);
    StandardAction standardAction() const;
    void setStandardAction(StandardAction action);
Q_SIGNALS:
    void standardActionChanged();
private:
    StandardAction m_standardAction = ActionNone;
};
