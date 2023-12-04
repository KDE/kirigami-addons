import org.kde.kirigamiaddons.formcard 1.0 as FormCard
import org.kde.about 1.0

FormCard.AboutPage {
    title: i18n("About")
    aboutData: {
        "displayName" : "Addons Example",
        "productName" : "",
        "componentName" : "addonsexample",
        "shortDescription" : "This program shows how to use AboutKDE and AboutPage",
        "homepage" : "https://kde.org",
        "bugAddress" : "",
        "version" : "1.0",
        "otherText" : "Optional text shown in the About",
        "authors" : [
            {
                "name" : "John Doe",
                "task" : "Maintainer",
                "emailAddress" : "",
                "webAddress" : "",
                "ocsUsername" : ""
            }
        ],
        "credits" : [],
        "translators" : [],
        "licenses" : [
            {
                "name" : "GPL v3",
                "text" : "Long license text goes here",
                "spdx" : "GPL-3.0"
            }
        ],
        "copyrightStatement" : "© 2023",
        "desktopFileName" : ""
    }

}
