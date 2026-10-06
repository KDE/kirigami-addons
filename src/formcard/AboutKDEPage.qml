// SPDX-FileCopyrightText: 2022 Joshua Goins <josh@redstrate.com>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Window
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.coreaddons as Core

/*!
   \qmltype AboutKDEPage
   \inqmlmodule org.kde.kirigamiaddons.formcard
   \brief An "About KDE" page using Form components.

   This component consists of a full, internationalized "About KDE" page
   that can be instantiated directly without passing any properties.

   \since 0.11.0
 */
FormCardPage {
    id: page

    title: i18nd("kirigami-addons6", "About KDE")

    readonly property string _bugReportUrl: {
        const bugAddress = Core.AboutData.bugAddress ?? "";
        if (bugAddress !== "submit@bugs.kde.org") {
            // A plain email address can only be opened with a mailto: scheme.
            if (bugAddress.includes("@") && !bugAddress.includes(":")) {
                return "mailto:" + bugAddress;
            }
            return bugAddress;
        }
        const elements = Core.AboutData.productName.split('/');
        let url = `https://bugs.kde.org/enter_bug.cgi?format=guided&product=${elements[0]}&version=${Core.AboutData.version}`;
        if (elements.length === 2) {
            url += "&component=" + elements[1];
        }
        return url;
    }

    FormCard {
        autoSeparators: true
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
                    source: "kde"
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Kirigami.Units.smallSpacing

                    Kirigami.Heading {
                        Layout.fillWidth: true
                        text: i18nd("kirigami-addons6", "KDE")
                        wrapMode: Text.WordWrap
                    }

                    Kirigami.Heading {
                        Layout.fillWidth: true
                        level: 3
                        type: Kirigami.Heading.Type.Secondary
                        wrapMode: Text.WordWrap
                        text: i18nd("kirigami-addons6", "Be Free!")
                    }
                }
            }
        }

        FormTextDelegate {
            text: i18nd("kirigami-addons6", "KDE is a world-wide community of software engineers, artists, writers, translators and creators who are committed to Free Software development. KDE produces the Plasma desktop environment, hundreds of applications, and the many software libraries that support them.\n\n\
KDE is a cooperative enterprise: no single entity controls its direction or products. Instead, we work together to achieve the common goal of building the world's finest Free Software. Everyone is welcome to join and contribute to KDE, including you.")
            textItem.wrapMode: Text.WordWrap
        }

        FormLinkDelegate {
            icon.name: "globe-symbolic"
            text: i18nd("kirigami-addons6", "Homepage")
            url: "https://kde.org/"
        }
    }

    FormHeader {
        title: i18nd("kirigami-addons6", "Report bugs")
        visible: page._bugReportUrl.length > 0
    }

    FormCard {
        // The text refers to the "Report a bug" button, so hide everything without it.
        visible: page._bugReportUrl.length > 0
        autoSeparators: true
        FormTextDelegate {
            text: i18nd("kirigami-addons6", "Software can always be improved, and the KDE team is ready to do so. However, you - the user - must tell us when something does not work as expected or could be done better.\n\n\
KDE has a bug tracking system. Use the button below to file a bug, or use the program's About page to report a bug specific to this application.\n\n\
If you have a suggestion for improvement then you are welcome to use the bug tracking system to register your wish. Make sure you use the severity called \"Wishlist\".")
            textItem.wrapMode: Text.WordWrap
        }

        FormLinkDelegate {
            url: page._bugReportUrl
            icon.name: "tools-report-bug-symbolic"
            text: i18nd("kirigami-addons6", "Report a bug")
        }
    }

    FormHeader {
        title: i18nd("kirigami-addons6", "Join us")
    }

    FormCard {
        autoSeparators: true
        FormTextDelegate {
            text: i18nd("kirigami-addons6", "You do not have to be a software developer to be a member of the KDE team. You can join the language teams that translate program interfaces. You can provide graphics, themes, sounds, and improved documentation. You decide!")
            textItem.wrapMode: Text.WordWrap
        }

        FormLinkDelegate {
            text: i18nd("kirigami-addons6", "Get Involved")
            icon.name: "system-user-list"
            url: "https://community.kde.org/Get_Involved"
        }

        FormLinkDelegate {
            icon.name: 'applications-development-symbolic'
            text: i18nd("kirigami-addons6", "Developer Documentation")
            url: "https://develop.kde.org/"
        }
    }

    FormHeader {
        title: i18nd("kirigami-addons6", "Support us")
    }

    FormCard {
        autoSeparators: true
        FormTextDelegate {
            text: i18nd("kirigami-addons6", "KDE software is and will always be available free of charge, however creating it is not free.\n\n\
To support development the KDE community has formed the KDE e.V., a non-profit organization legally founded in Germany. KDE e.V. represents the KDE community in legal and financial matters.\n\n\
KDE benefits from many kinds of contributions, including financial. We use the funds to reimburse members and others for expenses they incur when contributing. Further funds are used for legal support and organizing conferences and meetings.\n\n\
We would like to encourage you to support our efforts with a financial donation.\n\n\
Thank you very much in advance for your support.")
            textItem.wrapMode: Text.WordWrap
        }

        FormLinkDelegate {
            text: i18nd("kirigami-addons6", "KDE e.V.")
            icon.name: 'kde-symbolic'
            url: "https://ev.kde.org/"
        }

        FormLinkDelegate {
            text: i18nd("kirigami-addons6", "Donate")
            icon.name: 'donate-symbolic'
            // Lets KDE know which application the donation came from, like AboutPage does.
            url: Core.AboutData.componentName.length > 0 ? "https://www.kde.org/donate?app=" + encodeURIComponent(Core.AboutData.componentName) : "https://www.kde.org/donate"
        }
    }
}
