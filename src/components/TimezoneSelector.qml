/*
    SPDX-FileCopyrightText: 2024 Niccolò Venerandi <niccolo@venerandi.com>

    SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import QtQuick.Dialogs
import QtQuick.Controls

import QtPositioning
import QtLocation
import QtCore

import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.components 1.0 as Components

/**
 * @brief An element that shows all available timezones through a map and comboboxes, and allows you to select one.
 * @inherit QtQuick.Item
 */
Item {
    id: root

//BEGIN properties
    /**
    * @brief This property holds the selected timezone.
    *
    * This timezone will be highlighted on the map and shown
    * in the comboboxes. You can both read and write to this
    * property.
    * @property string selectedTimeZone
    */
    property string selectedTimeZone: ""
    /**
     * @brief This property holds the currently hovered timezone.
     *
     * This is a read-only property that allows you to know
     * which timezone the user is hovering.
     */
    property string hoveredTimeZone: ""
//END properties

    property var availableMapTimeZones: geoDatabase.model[0].data.map(zone => zone?.properties?.tzid)

    GeoJsonData {
        id: geoDatabase
        // GeoJsonData does not support qrc paths, so we have to install
        // the timezones file into the shared folder.
        sourceUrl: StandardPaths.locate(StandardPaths.GenericDataLocation, "timezonefiles", StandardPaths.LocateDirectory)  + "/timezones.json"
    }

    // These values get populated by GeoJsonDelegates when the
    // component is instantiated.
    property var availableTimeZones: Components.TimeZoneUtils.availableTimeZoneIds()
    property var areasByRegion: {
        const result = {}

        availableTimeZones.forEach(str => {
            let tzid = String(str)
            if (tzid.includes('/')) {

                let [prefix, suffix] = root.split(tzid)

                if (!result[prefix]) {
                    result[prefix] = []
                }

                result[prefix].push(suffix)
            }
        });

        return result
    }
    property var regionsModel: Object.keys(areasByRegion)

    // This is to convert between the technical name of a timezone,
    // e.g. something/some_thing, to one we can display in the UI.
    // Note that doing this only to the displayText would only
    // apply it to the selected element, all other items in the combobox
    // would remain "technical"
    function understandable(id) {
        return id.replace("/", ", ").replace("_", " ")
    }
    function technical(id) {
        return id.replace(", ", "/").replace(" ", "_")
    }
    // This splits "a/b/c_d" to ["a", "b, c d"]
    function split(id) {
        let i = id.indexOf("/")
        return [root.understandable(id.slice(0, i)), root.understandable(id.slice(i + 1))]
    }

    Kirigami.InlineMessage {
        anchors {
            left: parent.left
            top: parent.top
            right: parent.right
        }
        text: i18n("The currently selected timezone is not available for visualization on this map")
        visible: !root.availableMapTimeZones.includes(root.selectedTimeZone)
        z: 999
    }

    MapView {
        id: view

        anchors.fill: parent

        map.plugin: Plugin {
            name: "osm"
            PluginParameter {
                name: 'osm.mapping.offline.directory'
                value: ":/kirigami-addons/timezone/offline_tiles"
            }
        }
        map.zoomLevel: 0
        map.minimumZoomLevel: 0
        // Weirdly enough, the included offline maps of zoom level 0-4
        // only work until a zoom level of ~3.90, whereas zoom level
        // 4 (or even 3.99) would require offline maps for zoom level 5.
        map.maximumZoomLevel: 3.90
        map.maximumTilt: 0
        // No maximumBearing property exists, apparently
        map.onBearingChanged: {
            map.bearing = 0
        }
        map.activeMapType: map.supportedMapTypes[0]

        property variant referenceSurface: QtLocation.ReferenceSurface.Map

        Behavior on map.zoomLevel {
            NumberAnimation {
                duration: Kirigami.Units.shortDuration
                easing.type: Easing.InOutCubic
            }
        }
        Behavior on map.center {
            CoordinateAnimation {
                duration: Kirigami.Units.shortDuration
                easing.type: Easing.InOutCubic
            }
        }

        MapItemView {
            parent: view.map
            model: geoDatabase.model
            delegate: GeoJsonDelegate {}
        }

        RowLayout {
            anchors {
                right: parent.right
                rightMargin: Kirigami.Units.smallSpacing * 2
                bottom: parent.bottom
                bottomMargin: Kirigami.Units.smallSpacing * 2
            }

            QQC2.Button {
                id: zoomInButton

                text: i18n("Zoom in")
                display: QQC2.AbstractButton.IconOnly
                icon.name: "zoom-in-map-symbolic"
                activeFocusOnTab: false
                enabled: view.map.zoomLevel < view.map.maximumZoomLevel

                onClicked: view.map.zoomLevel += 0.5
                onDoubleClicked: view.map.zoomLevel += 0.5

                QQC2.ToolTip {
                    text: zoomInButton.text
                }
            }

            QQC2.Button {
                id: zoomOutButton

                text: i18n("Zoom out")
                display: QQC2.AbstractButton.IconOnly
                icon.name: "zoom-out-map-symbolic"
                activeFocusOnTab: false
                enabled: view.map.zoomLevel > view.map.minimumZoomLevel

                onClicked: view.map.zoomLevel -= 0.5
                onDoubleClicked: view.map.zoomLevel -= 0.5

                QQC2.ToolTip {
                    text: zoomOutButton.text
                }
            }
        }

        FloatingToolBar {

            anchors.bottom: parent.bottom
            anchors.bottomMargin: Kirigami.Units.gridUnit
            anchors.horizontalCenter: parent.horizontalCenter

            width: mainLayout.implicitWidth + Kirigami.Units.gridUnit
            height: mainLayout.implicitHeight + Kirigami.Units.gridUnit

            contentItem: RowLayout {
                id: mainLayout
                anchors.centerIn: parent
                spacing: Kirigami.Units.smallSpacing

                QQC2.ComboBox {
                    id: regionComboBox
                    model: [chooseText, ...regionsModel]

                    property string chooseText: i18nc("Placeholder for empty time zone combobox selector", "Choose…")

                    displayText: currentText

                    Connections {
                        target: root
                        function onSelectedTimeZoneChanged() {
                            regionComboBox.currentIndex = regionComboBox.model.indexOf(root.split(root.selectedTimeZone)[0])
                        }
                    }

                    onActivated: {
                        if (regionComboBox.currentText === chooseText) return;
                        if (regionComboBox.currentText !== root.split(root.selectedTimeZone)[0]) {
                            let locations = root.areasByRegion[regionComboBox.currentText]
                            locationComboBox.model = locations
                            locationComboBox.popup.visible = true
                        }
                    }
                }

                QQC2.Label {
                    text: locationComboBox.visible ? i18nc("Full context is: '<region> region, <zone> time zone.' in the context of time zone selection.", "region, ") : i18nc("Full context is: 'Choose region' in the context of time zone region selection.", "region")
                }

                QQC2.ComboBox {
                    id: locationComboBox

                    visible: regionComboBox.currentText !== regionComboBox.chooseText
                    displayText: currentText

                    Connections {
                        target: root
                        function onSelectedTimeZoneChanged() {
                            let [prefix, suffix] = root.split(root.selectedTimeZone)
                            locationComboBox.model = root.areasByRegion[prefix]
                            locationComboBox.currentIndex = locationComboBox.model.indexOf(suffix)
                        }
                    }

                    onActivated: {
                        root.selectedTimeZone = root.technical(regionComboBox.currentText) + '/' + root.technical(locationComboBox.currentText)
                    }
                }

                QQC2.Label {
                    text: i18nc("Full context is: '<region> region, <zone> time zone.' in the context of time zone selection.", "time zone.")
                    visible: locationComboBox.visible
                }
            }
        }
    }

}
