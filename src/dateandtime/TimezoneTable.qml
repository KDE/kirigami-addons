/*
 *   Copyright 2019 David Edmundson <davidedmundson@kde.org>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2 or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU Library General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

import QtQuick 2.0
import QtQuick.Controls 1.2 as QtControls
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.1

import org.kde.kirigamiaddons.dateandtime 0.1

ColumnLayout {
    QtControls.TextField {
            id: filter
            Layout.fillWidth: true
            placeholderText: i18n("Search Time Zones")
        }

        QtControls.TableView {
            id: timeZoneView

            signal toggleCurrent

            Layout.fillWidth: true
            Layout.fillHeight: true

            Keys.onSpacePressed: toggleCurrent()

            TimeZoneModel {
                id: timeZones

                onSelectedTimeZonesChanged: {
                    if (selectedTimeZones.length == 0) {
                        messageWidget.visible = true;

                        timeZones.selectLocalTimeZone();
                    }
                }
            }

            model: TimeZoneFilterModel {
                sourceModel: timeZones
                filterString: filter.text
            }

            QtControls.TableViewColumn {
                role: "city"
                title: i18n("City")
            }
            QtControls.TableViewColumn {
                role: "region"
                title: i18n("Region")
            }
            QtControls.TableViewColumn {
                role: "comment"
                title: i18n("Comment")
            }
        }
}
