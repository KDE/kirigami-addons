// SPDX-FileCopyrightText: 2018 Aleix Pol Gonzalez <aleixpol@blue-systems.com>
// SPDX-FileCopyrightText: 2021 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.20 as Kirigami

import "private" as Private

/**
 * @brief An AboutPage that displays the about data using Form components.
 *
 * This component consists of an internationalized "About" page with the
 * metadata of your program.
 *
 * It allows to show the copyright notice of the application together with
 * the contributors and some information of which platform it's running on.
 *
 * @since KirigamiAddons 0.11.0
 * @inherit org:kde::kirigami::ScrollablePage
 */
Kirigami.ScrollablePage {
    id: page

    /**
     * @brief This property holds an object with the same shape as KAboutData.
     *
     * Set this property to either a KAboutData instance exposed from C++, or directly via a JSON object.
     *
     * Example usage:
     * @code{json}
     * aboutData: {
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
       @endcode
     *
     * @see KAboutData
     */
    property var aboutData

    /**
     * @brief This property holds a link to a "Get Involved" page.
     *
     * default: `"https://community.kde.org/Get_Involved" when the
     * application ID starts with "org.kde.", otherwise empty.`
     */
    property url getInvolvedUrl: aboutData.desktopFileName.startsWith("org.kde.") ? "https://community.kde.org/Get_Involved" : ""

    /**
     * @brief This property holds a link to a "Donate" page.
     *
     * default: `"https://www.kde.org/donate" when the application ID starts with "org.kde.", otherwise empty.`
     */
    property url donateUrl: aboutData.desktopFileName.startsWith("org.kde.") ? "https://www.kde.org/donate" : ""

    /**
     * @brief This property holds extra content that is added at the end of the AboutPage
     */
    property alias extraContent: column.children

    leftPadding: 0
    rightPadding: 0
    topPadding: Kirigami.Units.gridUnit
    bottomPadding: Kirigami.Units.gridUnit

    title: i18nd("kirigami-addons", "About %1", page.aboutData.displayName)

    ColumnLayout {
        id: column
        width: parent.width

        FormCard {
            Layout.fillWidth: true
            contentItem: ColumnLayout {
                spacing: 0

                AbstractFormDelegate {
                    id: generalDelegate
                    Layout.fillWidth: true
                    background: null
                    contentItem: RowLayout {
                        spacing: Kirigami.Units.smallSpacing * 2

                        Kirigami.Icon {
                            Layout.rowSpan: 3
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
                    text: i18nd("kirigami-addons", "Copyright")
                    descriptionItem.textFormat: Text.PlainText
                    description: aboutData.otherText + (aboutData.otherText.length > 0 ? '</br>' : '')
                        + aboutData.copyrightStatement
                }

                FormCardHeader {
                    title: i18ndp("kirigami-addons", "License", "Licenses", aboutData.licenses.length)
                }

                Kirigami.OverlaySheet {
                    id: licenseSheet
                    property alias text: bodyLabel.text

                    contentItem: Kirigami.SelectableLabel {
                        id: bodyLabel

                        Layout.preferredWidth: Kirigami.Units.gridUnit * 15

                        text: licenseSheet.text
                    }
                }

                Repeater {
                    model: aboutData.licenses
                    FormButtonDelegate {
                        text: modelData.name
                        Layout.fillWidth: true
                        onClicked: {
                            licenseSheet.text = modelData.text
                            licenseSheet.title = modelData.name
                            licenseSheet.open()
                        }
                    }
                }
            }
        }

        FormCard {
            Layout.topMargin: Kirigami.Units.largeSpacing
            Layout.fillWidth: true
            contentItem: ColumnLayout {
                spacing: 0

                FormButtonDelegate {
                    id: getInvolvedDelegate
                    text: i18nd("kirigami-addons", "Homepage")
                    onClicked: Qt.openUrlExternally(aboutData.homepage)
                    visible: aboutData.homepage.length > 0
                }

                FormDelegateSeparator {
                    above: getInvolvedDelegate
                    below: donateDelegate

                    visible: getInvolvedDelegate.visible
                }

                FormButtonDelegate {
                    id: donateDelegate
                    text: i18nd("kirigami-addons", "Donate")
                    onClicked: Qt.openUrlExternally(donateUrl + "?app=" + page.aboutData.componentName)
                    visible: donateUrl.toString().length > 0
                }

                FormDelegateSeparator {
                    above: donateDelegate
                    below: homepageDelegate

                    visible: donateDelegate.visible
                }

                FormButtonDelegate {
                    id: homepageDelegate
                    text: i18nd("kirigami-addons", "Get Involved")
                    onClicked: Qt.openUrlExternally(page.getInvolvedUrl)
                    visible: page.getInvolvedUrl.toString().length > 0
                }

                FormDelegateSeparator {
                    above: homepageDelegate
                    below: bugDelegate

                    visible: homepageDelegate.visible
                }

                FormButtonDelegate {
                    id: bugDelegate
                    readonly property string theUrl: {
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

                    text: i18nd("kirigami-addons", "Report a bug")
                    onClicked: Qt.openUrlExternally(theUrl)
                    visible: theUrl.length > 0
                }
            }
        }

        FormCard {
            Layout.topMargin: Kirigami.Units.largeSpacing
            Layout.fillWidth: true
            contentItem: ColumnLayout {
                spacing: 0
                FormCardHeader {
                    title: i18nd("kirigami-addons", "Libraries in use")
                    visible: Kirigami.Settings.information
                    Layout.fillWidth: true
                }

                Repeater {
                    model: Kirigami.Settings.information
                    delegate: FormTextDelegate {
                        id: libraries
                        Layout.fillWidth: true
                        text: modelData
                    }
                }

                Repeater {
                    model: aboutData.components
                    delegate: libraryDelegate
                }
            }
        }

        FormCard {
            Layout.topMargin: Kirigami.Units.largeSpacing
            Layout.fillWidth: true
            contentItem: ColumnLayout {
                spacing: 0

                FormCardHeader {
                    title: i18nd("kirigami-addons", "Authors")
                    visible: aboutData.authors.length > 0
                    Layout.fillWidth: true
                }

                Repeater {
                    id: authorsRepeater
                    model: aboutData.authors
                    delegate: personDelegate
                }

                FormCardHeader {
                    title: i18nd("kirigami-addons", "Credits")
                    visible: aboutData.credits.length > 0
                    Layout.fillWidth: true
                }

                Repeater {
                    id: repCredits
                    model: aboutData.credits
                    delegate: personDelegate
                }

                FormCardHeader {
                    title: i18nd("kirigami-addons", "Translators")
                    visible: aboutData.translators.length > 0
                    Layout.fillWidth: true
                }

                Repeater {
                    id: repTranslators
                    model: aboutData.translators
                    delegate: personDelegate
                }
            }
        }
    }

    Component {
        id: libraryDelegate

        AbstractFormDelegate {
            Layout.fillWidth: true
            background: null
            contentItem: RowLayout {
                spacing: Kirigami.Units.smallSpacing * 2

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Kirigami.Units.smallSpacing

                    QQC2.Label {
                        Layout.fillWidth: true
                        text: modelData.name + ' ' + modelData.version
                        elide: Text.ElideRight
                    }

                    QQC2.Label {
                        id: internalDescriptionItem
                        Layout.fillWidth: true
                        text: modelData.description
                        color: Kirigami.Theme.disabledTextColor
                        font: Kirigami.Theme.smallFont
                        elide: Text.ElideRight
                        visible: text.length > 0
                    }
                }

                QQC2.ToolButton {
                    visible: modelData.licenses !== 0
                    icon.name: "license"
                    QQC2.ToolTip.delay: Kirigami.Units.toolTipDelay
                    QQC2.ToolTip.visible: hovered
                    QQC2.ToolTip.text: !visible ? "" : modelData.licenses.name

                    Kirigami.OverlaySheet {
                        id: licenseSheet

                        title: modelData.licenses.name

                        contentItem: Kirigami.SelectableLabel {
                            Layout.preferredWidth: Kirigami.Units.gridUnit * 15

                            text: modelData.licenses.text
                        }
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

    Component {
        id: personDelegate

        AbstractFormDelegate {
            Layout.fillWidth: true
            background: null
            contentItem: RowLayout {
                spacing: Kirigami.Units.smallSpacing * 2

                Kirigami.Avatar {
                    id: avatarIcon

                    // TODO FIXME kf6 https://phabricator.kde.org/T15993
                    property bool hasRemoteAvatar: false // (typeof(modelData.ocsUsername) !== "undefined" && modelData.ocsUsername.length > 0)
                    implicitWidth: Kirigami.Units.iconSizes.medium
                    implicitHeight: implicitWidth
                    initialsMode: Kirigami.Avatar.ImageMode.AlwaysShowImage
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
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Kirigami.Units.smallSpacing

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
                    icon.name: "get-hot-new-stuff"
                    QQC2.ToolTip.delay: Kirigami.Units.toolTipDelay
                    QQC2.ToolTip.visible: hovered
                    QQC2.ToolTip.text: qsTr("Visit %1's KDE Store page").arg(modelData.name)
                    onClicked: Qt.openUrlExternally("https://store.kde.org/u/%1".arg(modelData.ocsUsername))
                }

                QQC2.ToolButton {
                    visible: typeof(modelData.emailAddress) !== "undefined" && modelData.emailAddress.length > 0
                    icon.name: "mail-sent"
                    QQC2.ToolTip.delay: Kirigami.Units.toolTipDelay
                    QQC2.ToolTip.visible: hovered
                    QQC2.ToolTip.text: qsTr("Send an email to %1").arg(modelData.emailAddress)
                    onClicked: Qt.openUrlExternally("mailto:%1".arg(modelData.emailAddress))
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
}