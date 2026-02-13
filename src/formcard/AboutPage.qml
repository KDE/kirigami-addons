// SPDX-FileCopyrightText: 2018 Aleix Pol Gonzalez <aleixpol@blue-systems.com>
// SPDX-FileCopyrightText: 2021 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Window
import QtQuick.Layouts
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
    property url getInvolvedUrl: aboutData.desktopFileName.startsWith("org.kde.") ? "https://community.kde.org/Get_Involved" : ""

    /*!
       \brief This property holds a link to a "Donate" page.

       Default: "https://www.kde.org/donate" when the
       application ID starts with "org.kde.", otherwise empty.
     */
    property url donateUrl: aboutData.desktopFileName.startsWith("org.kde.") ? "https://www.kde.org/donate" : ""

    title: i18nd("kirigami-addons6", "About %1", page.aboutData.displayName)

    FormCard {
        Layout.topMargin: Kirigami.Units.largeSpacing * 4

        AbstractFormDelegate {
            id: generalDelegate
            Layout.fillWidth: true
            background: null
            contentItem: RowLayout {
                spacing: Kirigami.Units.smallSpacing * 2

                Kirigami.Icon {
                    Layout.preferredHeight: Kirigami.Units.iconSizes.huge
                    Layout.preferredWidth: height
                    Layout.maximumWidth: page.width / 3;
                    Layout.rightMargin: Kirigami.Units.largeSpacing
                    source: Kirigami.Settings.applicationWindowIcon || page.aboutData.programLogo || page.aboutData.programIconName || page.aboutData.componentName
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Kirigami.Units.smallSpacing

                    Kirigami.Heading {
                        Layout.fillWidth: true
                        text: page.aboutData.displayName + " " + page.aboutData.version
                        wrapMode: Text.WordWrap
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
        }

        FormDelegateSeparator {}

        FormTextDelegate {
            id: copyrightDelegate
            text: i18nd("kirigami-addons6", "Copyright")
            descriptionItem.textFormat: Text.PlainText
            description: aboutData.copyrightStatement
        }
    }

    FormHeader {
        visible: aboutData.otherText.length > 0
        title: i18nd("kirigami-addons6", "Description")
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
        title: i18ndp("kirigami-addons6", "License", "Licenses", aboutData.licenses.length)
        visible: aboutData.licenses.length
    }

    FormCard {
        visible: aboutData.licenses.length

        Repeater {
            model: aboutData.licenses
            delegate: FormButtonDelegate {
                text: modelData.name
                Layout.fillWidth: true
                onClicked: {
                    licenseSheet.text = modelData.text;
                    licenseSheet.title = modelData.name;
                    licenseSheet.open();
                }
            }
        }

        data: KirigamiComponents.MessageDialog {
            id: licenseSheet

            property alias text: bodyLabel.text

            parent: QQC2.Overlay.overlay

            leftPadding: 0
            rightPadding: 0
            bottomPadding: 0
            topPadding: 0

            header: Kirigami.Heading {
                text: licenseSheet.title
                elide: QQC2.Label.ElideRight
                padding: licenseSheet.padding
                topPadding: Kirigami.Units.largeSpacing
                bottomPadding: Kirigami.Units.largeSpacing

                Kirigami.Separator {
                    anchors {
                        left: parent.left
                        right: parent.right
                        bottom: parent.bottom
                    }
                }
            }

            contentItem: QQC2.ScrollView {
                id: scrollView

                Kirigami.SelectableLabel {
                    id: bodyLabel
                    text: licenseSheet.text
                    textMargin: Kirigami.Units.gridUnit
                }
            }

            footer: null
        }
    }

    FormCard {
        Layout.topMargin: Kirigami.Units.gridUnit

        // hide FormCard if all contents are not visible
        visible: getInvolvedDelegate.visible
              || donateDelegate.visible
              || homepageDelegate.visible
              || bugDelegate.visible

        FormLinkDelegate {
            id: getInvolvedDelegate
            icon.name: "globe-symbolic"
            text: i18nd("kirigami-addons6", "Homepage")
            url: aboutData.homepage
            visible: aboutData.homepage.length > 0
        }

        FormDelegateSeparator {
            above: getInvolvedDelegate
            below: donateDelegate
            visible: aboutData.homepage.length > 0
        }

        FormLinkDelegate {
            id: donateDelegate
            icon.name: "donate-symbolic"
            text: i18nd("kirigami-addons6", "Donate")
            url: donateUrl + "?app=" + page.aboutData.componentName
            visible: donateUrl.toString().length > 0
        }

        FormDelegateSeparator {
            above: donateDelegate
            below: homepageDelegate
            visible: donateUrl.toString().length > 0
        }

        FormLinkDelegate {
            id: homepageDelegate
            icon.name: "applications-development-symbolic"
            text: i18nd("kirigami-addons6", "Get Involved")
            url: page.getInvolvedUrl
            visible: page.getInvolvedUrl != ""
        }

        FormDelegateSeparator {
            above: homepageDelegate
            below: bugDelegate
            visible: page.getInvolvedUrl != ""
        }

        FormLinkDelegate {
            id: bugDelegate
            url: {
                if (aboutData.bugAddress !== "submit@bugs.kde.org") {
                    return aboutData.bugAddress
                }
                const elements = aboutData.productName.split('/');
                let url = `https://bugs.kde.org/enter_bug.cgi?format=guided&product=${elements[0]}&version=${aboutData.version}`;
                if (elements.length === 2) {
                    url += "&component=" + elements[1];
                }
                return url;
            }

            icon.name: "tools-report-bug-symbolic"
            text: i18nd("kirigami-addons6", "Report a Bug")
            visible: url.length > 0
        }
    }

    FormHeader {
        title: i18nd("kirigami-addons6", "Libraries in use")

        actions: QQC2.Action {
            text: i18ndc("kirigami-addons6", "@action:button", "Copy to Clipboard")
            icon.name: 'edit-copy-symbolic'
            onTriggered: {
                FormCardModule.AboutComponent.copyToClipboard();
                page.QQC2.ApplicationWindow.window.showPassiveNotification(i18ndc("kirigami-addons6", "@info", "System information copied to clipboard."), 'short');
            }
        }
    }

    FormCard {
        Repeater {
            model: FormCardModule.AboutComponent.components
            delegate: libraryDelegate
        }
    }

    FormHeader {
        title: i18nd("kirigami-addons6", "Authors")
        visible: aboutData.authors !== undefined && aboutData.authors.length > 0
    }

    FormCard {
        visible: aboutData.authors !== undefined && aboutData.authors.length > 0

        Repeater {
            id: authorsRepeater
            model: aboutData.authors
            delegate: personDelegate
        }
    }

    FormHeader {
        title: i18nd("kirigami-addons6", "Credits")
        visible: aboutData.credits !== undefined && aboutData.credits.length > 0
    }

    FormCard {
        visible: aboutData.credits !== undefined && aboutData.credits.length > 0

        Repeater {
            id: repCredits
            model: aboutData.credits
            delegate: personDelegate
        }
    }

    FormHeader {
        title: i18nd("kirigami-addons6", "Translators")
        visible: aboutData.translators !== undefined && aboutData.translators.length > 0
    }

    FormCard {
        visible: aboutData.translators !== undefined && aboutData.translators.length > 0

        Repeater {
            id: repTranslators
            model: aboutData.translators
            delegate: personDelegate
        }
    }

    data: [
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
                        QQC2.ToolTip.delay: Kirigami.Units.toolTipDelay
                        QQC2.ToolTip.visible: hovered
                        QQC2.ToolTip.text: i18nd("kirigami-addons6", "Visit %1's KDE Store page", modelData.name)
                        onClicked: Qt.openUrlExternally("https://store.kde.org/u/%1".arg(modelData.ocsUsername))
                    }

                    QQC2.ToolButton {
                        visible: typeof(modelData.emailAddress) !== "undefined" && modelData.emailAddress.length > 0
                        icon.name: "mail-sent-symbolic"
                        QQC2.ToolTip.delay: Kirigami.Units.toolTipDelay
                        QQC2.ToolTip.visible: hovered
                        QQC2.ToolTip.text: i18nd("kirigami-addons6", "Send an email to %1", modelData.emailAddress)
                        onClicked: Qt.openUrlExternally("mailto:%1".arg(modelData.emailAddress))
                    }

                    QQC2.ToolButton {
                        visible: typeof(modelData.webAddress) !== "undefined" && modelData.webAddress.length > 0
                        icon.name: "globe-symbolic"
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

                        QQC2.ToolTip.delay: Kirigami.Units.toolTipDelay
                        QQC2.ToolTip.visible: hovered
                        QQC2.ToolTip.text: !visible ? "" : delegate.modelData.licenses.name

                        KirigamiComponents.MessageDialog {
                            id: licenseSheet

                            title: delegate.modelData.name

                            parent: licenseButton.QQC2.Overlay.overlay
                            implicitWidth: Math.min(parent.width - Kirigami.Units.gridUnit * 2, implicitContentWidth)

                            leftPadding: 0
                            rightPadding: 0
                            bottomPadding: 0
                            topPadding: 0

                            header: QQC2.Control {
                                padding: licenseSheet.padding
                                topPadding: Kirigami.Units.largeSpacing
                                bottomPadding: Kirigami.Units.largeSpacing

                                contentItem: RowLayout {
                                    spacing: Kirigami.Units.largeSpacing

                                    Kirigami.Heading {
                                        text: licenseSheet.title
                                        elide: QQC2.Label.ElideRight
                                        padding: 0
                                        leftPadding: Kirigami.Units.largeSpacing
                                        Layout.fillWidth: true
                                    }

                                    QQC2.ToolButton {
                                        icon.name: hovered ? "window-close" : "window-close-symbolic"
                                        text: i18ndc("kirigami-addons6", "@action:button", "Close")
                                        display: QQC2.ToolButton.IconOnly
                                        onClicked: licenseSheet.close()
                                    }
                                }

                                Kirigami.Separator {
                                    anchors {
                                        left: parent.left
                                        right: parent.right
                                        bottom: parent.bottom
                                    }
                                }
                            }

                            contentItem: QQC2.ScrollView {
                                Kirigami.SelectableLabel {
                                    id: bodyLabel
                                    text: delegate.modelData.licenses.text
                                    textMargin: Kirigami.Units.gridUnit
                                    onLinkActivated: (link) => { Qt.openUrlExternally(link); }
                                }
                            }

                            footer: null
                        }

                        onClicked: licenseSheet.open()
                    }

                    QQC2.ToolButton {
                        visible: typeof(modelData.webAddress) !== "undefined" && modelData.webAddress.length > 0
                        icon.name: "globe"
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
