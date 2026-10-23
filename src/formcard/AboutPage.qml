// SPDX-FileCopyrightText: 2018 Aleix Pol Gonzalez <aleixpol@blue-systems.com>
// SPDX-FileCopyrightText: 2021 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Window
import QtQuick.Layouts
import org.kde.kirigamiaddons.private
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.components as KirigamiComponents
import org.kde.kirigamiaddons.formcard as FormCardModule
import org.kde.coreaddons as Core

import "private" as Private

/*!
   \qmltype AboutPage
   \inqmlmodule org.kde.kirigamiaddons.formcard
   \brief An AboutPage that displays the about data using Form components.

   This component consists of an internationalized "About" page with the
   metadata of your program.

   It allows to show the copyright notice of the application together with
   the contributors and some information of which platform it's running on.

   \since 0.11.0
 */
FormCardPage {
    id: page

    /*!
       \brief This property holds an object with the same shape as KAboutData.

       Set this property to either a KAboutData instance exposed from C++, or directly via a JSON object.

       Example usage:
       \code{json}
       aboutData: {
          "displayName" : "KirigamiApp",
          "productName" : "kirigami/app",
          "componentName" : "kirigamiapp",
          "shortDescription" : "A Kirigami example",
          "homepage" : "",
          "bugAddress" : "submit@bugs.kde.org",
          "version" : "5.14.80",
          "otherText" : "",
          "authors" : [
              {
                  "name" : "...",
                  "task" : "...",
                  "emailAddress" : "somebody@kde.org",
                  "webAddress" : "",
                  "ocsUsername" : ""
              }
          ],
          "credits" : [],
          "translators" : [],
          "licenses" : [
              {
                  "name" : "GPL v2",
                  "text" : "long, boring, license text",
                  "spdx" : "GPL-2.0"
              }
          ],
          "releases" : [
              {
                  "version" : "1.0.0",
                  "date" : "2025-01-01",
                  "description" : "Initial release.",
                  "url" : "https://example.org/releases/1.0.0"
              }
          ],
          "copyrightStatement" : "© 2010-2018 Plasma Development Team",
          "desktopFileName" : "org.kde.kirigamiapp"
       }
       \endcode

       \sa KAboutData
     */
    property var aboutData: Core.AboutData

    /*!
       \brief This property holds a link to a "Get Involved" page.

       Default: "https://community.kde.org/Get_Involved" when the
       application ID starts with "org.kde.", otherwise empty.
     */
    property url getInvolvedUrl: {
        if (aboutData.hasOwnProperty("url") && aboutData.url(Core.AboutUrlType?.Contribute) !== "")
            return aboutData.url(Core.AboutUrlType?.Contribute);
        return aboutData.desktopFileName.startsWith("org.kde.") ? "https://community.kde.org/Get_Involved" : "";
    }

    /*!
       \brief This property holds a link to a "Donate" page.

       Default: "https://www.kde.org/donate" when the
       application ID starts with "org.kde.", otherwise empty.
     */
    property url donateUrl: {
        if (page.aboutData.hasOwnProperty("url") && aboutData.url(Core.AboutUrlType?.Donation) !== "")
            return aboutData.url(Core.AboutUrlType?.Donation);
        return aboutData.desktopFileName.startsWith("org.kde.") ? "https://www.kde.org/donate" : ""
    }

    /*!
       \brief This property defines whether to show "Libraries in use".

       Default: true
     */
    property bool showLibraries: true

    Binding {
        target: FormCardModule.AboutComponent
        property: "currentVersion"
        value: page.aboutData.version
    }

    Binding {
        target: FormCardModule.AboutComponent
        property: "releaseVersions"
        value: page.aboutData.releases ? page.aboutData.releases.map(release => release.version) : []
    }

    title: I18n.i18n("About %1", page.aboutData.displayName)

    FormCard {
        Layout.topMargin: Kirigami.Units.largeSpacing * 4
        autoSeparators: true

        AbstractFormDelegate {
            id: generalDelegate

            readonly property bool hasReleases: (page.aboutData.releases?.length ?? 0) > 0

            Layout.fillWidth: true
            focusPolicy: hasReleases ? Qt.StrongFocus : Qt.NoFocus
            hoverEnabled: hasReleases
            Accessible.role: hasReleases ? Accessible.Button : Accessible.StaticText
            Accessible.name: hasReleases
                ? I18n.i18nc("@action:button", "Show release history for %1 %2", page.aboutData.displayName, page.aboutData.version)
                : page.aboutData.displayName + " " + page.aboutData.version
            background.visible: hasReleases

            contentItem: RowLayout {
                spacing: Kirigami.Units.smallSpacing * 2

                Kirigami.Icon {
                    Layout.preferredHeight: Kirigami.Units.iconSizes.huge
                    Layout.preferredWidth: height
                    Layout.maximumWidth: page.width / 3;
                    Layout.rightMargin: Kirigami.Units.largeSpacing
                    source: page.aboutData.programLogo || Kirigami.Settings.applicationWindowIcon || page.aboutData.componentName
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Kirigami.Units.smallSpacing

                    RowLayout {
                        spacing: Kirigami.Units.smallSpacing

                        Kirigami.Heading {
                            Layout.fillWidth: true
                            text: page.aboutData.displayName + " " + page.aboutData.version
                            wrapMode: Text.WordWrap
                        }

                        Kirigami.Badge {
                            visible: FormCardModule.AboutComponent.hasNewReleases
                            text: I18n.i18n("What's new")
                            type: Kirigami.Badge.Type.Positive
                        }
                    }


                    Kirigami.Heading {
                        Layout.fillWidth: true
                        level: 3
                        type: Kirigami.Heading.Type.Secondary
                        wrapMode: Text.WordWrap
                        text: page.aboutData.shortDescription
                    }
                }
            }

            onClicked: {
                if (generalDelegate.hasReleases) {
                    releasesLoader.active = true;
                }
            }
        }

        FormTextDelegate {
            id: copyrightDelegate
            visible: aboutData.copyrightStatement.length > 0
            text: I18n.i18n("Copyright")
            descriptionItem.textFormat: Text.PlainText
            description: aboutData.copyrightStatement
        }
    }

    FormHeader {
        visible: aboutData.otherText.length > 0
        title: I18n.i18n("Description")
    }

    FormCard {
        visible: aboutData.otherText.length > 0
        FormTextDelegate {
            Layout.fillWidth: true
            textItem.wrapMode: Text.WordWrap
            text: aboutData.otherText
        }
    }

    FormHeader {
        title: I18n.i18np("License", "Licenses", aboutData.licenses.length)
        visible: aboutData.licenses.length
    }

    FormCard {
        visible: aboutData.licenses.length

        Repeater {
            model: aboutData.licenses
            delegate: FormButtonDelegate {
                text: modelData.name
                Layout.fillWidth: true
                onClicked: licenseLoader.open(modelData.name, modelData.text)
            }
        }
    }

    FormGridContainer {
        Layout.topMargin: Kirigami.Units.gridUnit
        Layout.fillWidth: true

        // hide the container if all contents are not visible
        visible: getInvolvedDelegate.visible
              || donateDelegate.visible
              || homepageDelegate.visible
              || bugDelegate.visible
              || matrixRoomDelegate.visible
              || mastodonDelegate.visible
              || sourceCodeDelegate.visible

        FormLinkDelegate {
            id: getInvolvedDelegate
            icon.name: "globe-symbolic"
            text: I18n.i18n("Homepage")
            url: aboutData.homepage
            visible: aboutData.homepage.length > 0
        }

        FormLinkDelegate {
            id: donateDelegate
            icon.name: "donate-symbolic"
            text: I18n.i18n("Donate")
            url: {
                if (page.donateUrl.toString().length === 0) {
                    return "";
                }
                const url = new URL(page.donateUrl.toString());
                const query = url.search ? url.search + "&" : "?";
                url.search = query + "app=" + encodeURIComponent(page.aboutData.componentName);
                return url.toString();
            }
            visible: donateUrl.toString().length > 0
        }

        FormLinkDelegate {
            id: homepageDelegate
            icon.name: "applications-development-symbolic"
            text: I18n.i18n("Get Involved")
            url: page.getInvolvedUrl
            visible: page.getInvolvedUrl != ""
        }

        FormLinkDelegate {
            id: bugDelegate
            url: {
                const bugAddress = aboutData.bugAddress ?? "";
                if (bugAddress !== "submit@bugs.kde.org") {
                    // A plain email address can only be opened with a mailto: scheme.
                    if (bugAddress.includes("@") && !bugAddress.includes(":")) {
                        return "mailto:" + bugAddress;
                    }
                    return bugAddress;
                }
                const elements = aboutData.productName.split('/');
                const url = new URL("https://bugs.kde.org/enter_bug.cgi");
                const params = new URLSearchParams();
                params.set("format", "guided");
                params.set("product", elements[0]);
                params.set("version", page.aboutData.version);
                if (elements.length === 2) {
                    params.set("component", elements[1]);
                }
                url.search = params.toString();
                return url.toString();
            }

            icon.name: "tools-report-bug-symbolic"
            text: I18n.i18n("Report a Bug")
            visible: url.length > 0
        }

        FormLinkDelegate {
            id: matrixRoomDelegate
            url: {
                if (!page.aboutData.hasOwnProperty("url")) // since KF 6.29
                    return "";
                const s = page.aboutData.url(Core.AboutUrlType?.XKDEMatrixRoom);
                return s.startsWith("http") ? s : s != "" ? "https://matrix.to/#/" + s : "";
            }
            icon.name: "im-matrix"
            text: I18n.i18n("Matrix Channel")
            visible: url.length > 0
        }

        FormLinkDelegate {
            id: mastodonDelegate
            url: {
                if (!page.aboutData.hasOwnProperty("url")) // since KF 6.29
                    return "";
                const s = page.aboutData.url(Core.AboutUrlType?.XKDEMastodon);
                if (s == "" || s.startsWith("http"))
                    return s;
                const m = s.match(/^(@\S*)@(\S+)$/);
                return m ? ("https://" + m[2] + "/" + m[1]) : ""
            }
            icon.name: "im-mastodon"
            text: I18n.i18n("Mastodon")
            visible: url.length > 0
        }

        FormLinkDelegate {
            id: sourceCodeDelegate
            url: {
                if (!page.aboutData.hasOwnProperty("url")) // since KF 6.29
                    return "";
                page.aboutData.url(Core.AboutUrlType?.VCSBrowser)
            }
            icon.name: "code-context-symbolic"
            text: I18n.i18n("Source Code")
            visible: url.length > 0
        }
    }

    FormHeader {
        title: I18n.i18n("Libraries in use")
        visible: page.showLibraries

        actions: QQC2.Action {
            text: I18n.i18nc("@action:button", "Copy to Clipboard")
            icon.name: 'edit-copy-symbolic'
            onTriggered: {
                FormCardModule.AboutComponent.copyToClipboard();
                page.QQC2.ApplicationWindow.window.showPassiveNotification(I18n.i18nc("@info", "System information copied to clipboard."), 'short');
            }
        }
    }

    FormCard {
        visible: page.showLibraries
        autoSeparators: true
        Repeater {
            model: page.showLibraries ? FormCardModule.AboutComponent.components : null
            delegate: libraryDelegate
        }
    }

    FormHeader {
        title: I18n.i18n("Authors")
        visible: aboutData.authors !== undefined && aboutData.authors.length > 0
    }

    FormCard {
        visible: aboutData.authors !== undefined && aboutData.authors.length > 0
        autoSeparators: true

        Repeater {
            id: authorsRepeater
            model: aboutData.authors
            delegate: personDelegate
        }
    }

    FormHeader {
        title: I18n.i18n("Credits")
        visible: aboutData.credits !== undefined && aboutData.credits.length > 0
    }

    FormCard {
        visible: aboutData.credits !== undefined && aboutData.credits.length > 0
        autoSeparators: true

        Repeater {
            id: repCredits
            model: aboutData.credits
            delegate: personDelegate
        }
    }

    FormHeader {
        title: I18n.i18n("Translators")
        visible: aboutData.translators !== undefined && aboutData.translators.length > 0
    }

    FormCard {
        visible: aboutData.translators !== undefined && aboutData.translators.length > 0
        autoSeparators: true

        Repeater {
            id: repTranslators
            model: aboutData.translators
            delegate: personDelegate
        }
    }

    data: [
        Loader {
            id: releasesLoader
            active: false
            sourceComponent: Private.AboutReleaseDialog {
                releases: page.aboutData.releases
                onClosed: releasesLoader.active = false
            }
            onLoaded: {
                if (status === Loader.Ready) {
                    item.showOnlyNewReleases = FormCardModule.AboutComponent.hasNewReleases;
                    item.open();
                    FormCardModule.AboutComponent.updateLastSeenVersion();
                }
            }
        },
        Loader {
            id: licenseLoader

            property string licenseTitle
            property string licenseText

            function open(title: string, text: string): void {
                licenseTitle = title;
                licenseText = text;
                active = true;
            }

            active: false
            sourceComponent: Private.AboutLicenseDialog {
                title: licenseLoader.licenseTitle
                text: licenseLoader.licenseText
                onClosed: licenseLoader.active = false
            }
            onLoaded: {
                if (status === Loader.Ready) {
                    item.open();
                }
            }
        },
        Component {
            id: personDelegate

            AbstractFormDelegate {
                Layout.fillWidth: true
                background: null
                contentItem: RowLayout {
                    spacing: Private.FormCardUnits.horizontalSpacing

                    KirigamiComponents.Avatar {
                        id: avatarIcon

                        implicitWidth: Kirigami.Units.iconSizes.medium
                        implicitHeight: implicitWidth
                        name: modelData.name
                        source: if (!!modelData.avatarUrl && modelData.avatarUrl.toString().startsWith('https://')) {
                            const url = new URL(modelData.avatarUrl);
                            const params = new URLSearchParams(url.search);
                            params.append("s", width);
                            url.search = params.toString();
                            return url;
                        } else {
                            return '';
                        }

                        Layout.rightMargin: Private.FormCardUnits.horizontalSpacing
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: Private.FormCardUnits.verticalSpacing

                        QQC2.Label {
                            Layout.fillWidth: true
                            text: modelData.name
                            elide: Text.ElideRight
                        }

                        QQC2.Label {
                            id: internalDescriptionItem
                            Layout.fillWidth: true
                            text: modelData.task
                            color: Kirigami.Theme.disabledTextColor
                            font: Kirigami.Theme.smallFont
                            elide: Text.ElideRight
                            visible: text.length > 0
                        }
                    }

                    QQC2.ToolButton {
                        visible: typeof(modelData.ocsUsername) !== "undefined" && modelData.ocsUsername.length > 0
                        icon.name: "get-hot-new-stuff-symbolic"
                        text: I18n.i18n("Visit %1's KDE Store page", modelData.name)
                        display: QQC2.ToolButton.IconOnly
                        QQC2.ToolTip.delay: Kirigami.Units.toolTipDelay
                        QQC2.ToolTip.visible: hovered
                        QQC2.ToolTip.text: I18n.i18n("Visit %1's KDE Store page", modelData.name)
                        onClicked: Qt.openUrlExternally("https://store.kde.org/u/%1".arg(modelData.ocsUsername))
                    }

                    QQC2.ToolButton {
                        visible: typeof(modelData.emailAddress) !== "undefined" && modelData.emailAddress.length > 0
                        icon.name: "mail-sent-symbolic"
                        text: I18n.i18n("Send an email to %1", modelData.emailAddress)
                        display: QQC2.ToolButton.IconOnly
                        QQC2.ToolTip.delay: Kirigami.Units.toolTipDelay
                        QQC2.ToolTip.visible: hovered
                        QQC2.ToolTip.text: I18n.i18n("Send an email to %1", modelData.emailAddress)
                        onClicked: Qt.openUrlExternally("mailto:%1".arg(modelData.emailAddress))
                    }

                    QQC2.ToolButton {
                        visible: typeof(modelData.webAddress) !== "undefined" && modelData.webAddress.length > 0
                        icon.name: "globe-symbolic"
                        text: I18n.i18nc("@action:button", "Visit %1's website", modelData.name)
                        display: QQC2.ToolButton.IconOnly
                        QQC2.ToolTip.delay: Kirigami.Units.toolTipDelay
                        QQC2.ToolTip.visible: hovered
                        QQC2.ToolTip.text: (typeof(modelData.webAddress) === "undefined" && modelData.webAddress.length > 0) ? "" : modelData.webAddress
                        onClicked: Qt.openUrlExternally(modelData.webAddress)
                    }
                }
            }
        },
        Component {
            id: libraryDelegate

            AbstractFormDelegate {
                id: delegate

                required property var modelData

                Layout.fillWidth: true
                background: null
                contentItem: RowLayout {
                    spacing: Private.FormCardUnits.horizontalSpacing

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: Private.FormCardUnits.verticalSpacing

                        QQC2.Label {
                            Layout.fillWidth: true
                            text: delegate.modelData.name + ' ' + delegate.modelData.version
                            wrapMode: Text.WordWrap
                        }

                        QQC2.Label {
                            id: internalDescriptionItem
                            Layout.fillWidth: true
                            text: delegate.modelData.description
                            color: Kirigami.Theme.disabledTextColor
                            font: Kirigami.Theme.smallFont
                            wrapMode: Text.WordWrap
                            visible: text.length > 0
                        }
                    }

                    QQC2.ToolButton {
                        id: licenseButton
                        visible: modelData.licenses.key !== 0
                        icon.name: "license-symbolic"
                        text: I18n.i18nc("@action:button", "Show license for %1", delegate.modelData.name)
                        display: QQC2.ToolButton.IconOnly

                        QQC2.ToolTip.delay: Kirigami.Units.toolTipDelay
                        QQC2.ToolTip.visible: hovered
                        QQC2.ToolTip.text: !visible ? "" : delegate.modelData.licenses.name

                        onClicked: licenseLoader.open(delegate.modelData.name, delegate.modelData.licenses.text)
                    }

                    QQC2.ToolButton {
                        visible: typeof(modelData.webAddress) !== "undefined" && modelData.webAddress.length > 0
                        icon.name: "globe-symbolic"
                        text: I18n.i18nc("@action:button", "Visit %1's website", delegate.modelData.name)
                        display: QQC2.ToolButton.IconOnly
                        QQC2.ToolTip.delay: Kirigami.Units.toolTipDelay
                        QQC2.ToolTip.visible: hovered
                        QQC2.ToolTip.text: (typeof(modelData.webAddress) === "undefined" && modelData.webAddress.length > 0) ? "" : modelData.webAddress
                        onClicked: Qt.openUrlExternally(modelData.webAddress)
                    }
                }
            }
        }
    ]
}
