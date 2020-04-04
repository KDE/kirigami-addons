import QtQuick 2.3
import QtQuick.Layouts 1.2
import QtQuick.Controls 2.3

import org.kde.kirigami 2.4 as Kirigami

import org.kde.kirigamiaddons.dateandtime 0.1

/**
 * This Item provides an entry box for inputting a date.
 * It is represented in a form suitable for entering a known date (i.e date of birth, current date)
 * rather than date selection where a user might want a grid view.
 */
RowLayout {
    id: layout

    //DAVE - if I'm in an RTL country are my date formats pre-reversed?
    //i.e Wikipedia says afghan is d/m/yyyy   should year go on the left or the right?

    property date value

    property string dateFormat: Qt.locale().dateFormat(Locale.ShortFormat)

    //date formats can be in big endian (china), little endian (Europe), or absolutely mental endian
    //separators are also different
    Component.onCompleted: {
        value = new Date();

        //dave, some idiot could have added children externally, maybe  would be safer to make RowLayout internal?
        for (var i in layout.children) {
            layout.children[i].destroy();
        }

        var tabletMode = Kirigami.Settings.tabletMode

        var parse = /([^dMy]*)([dMy]+)([^dMy]*)([dMy]+)([^dMy]*)([dMy]+)([^dMy]*)/
        var parts = parse.exec(dateFormat);
        for(var i=1; i < parts.length; i++) {
            var part = parts[i];

            if (!part) {
                continue;
            }

            if (part.startsWith("d")) {
                if (tabletMode) {
                    daySelectTouchComponent.createObject(layout);
                } else {
                    daySelectComponent.createObject(layout);
                }
            }
            else if (part.startsWith("M")) {
                if (tabletMode) {
                    monthSelectTouchComponent.createObject(layout);
                } else {
                    monthSelectComponent.createObject(layout);
                }            }
            else if (part.startsWith("y")) {
                if (tabletMode) {
                    yearSelectTouchComponent.createObject(layout);
                } else {
                    yearSelectComponent.createObject(layout);
                }                   }
            else {
                labelComponent.createObject(layout, {"text": part})
            }
        }
    }

    Component {
        id: tumberDelegate
        Label {
            text: model.display
            color: Tumbler.tumbler.visualFocus ? Kirigami.Theme.highlightedTextColor : Kirigami.Theme.textColor
            opacity: 0.4 + Math.max(0, 1 - Math.abs(Tumbler.displacement)) * 0.6
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    Component {
        id: daySelectComponent
        SpinBox {
            from: 1
            to: 31
            editable: true
            value: layout.value.getDate();
            onValueModified: {
                var dt = layout.value;
                dt.setDate(value);
                layout.value = dt;
            }
        }
    }
    Component {
        id: daySelectTouchComponent
        Tumbler {
            delegate: tumberDelegate
            model: NumberModel {
                minimumValue: 1
                maximumValue: 31
            }
        }
        //Tumbler doesn't have a separate user modified signal...booooooo!!!!!
    }

    Component {
        id: monthSelectComponent
        SpinBox {
            from: 1
            to: 12
            editable: true
            value: layout.value.getMonth() + 1;
            onValueModified: {
                var dt = layout.value;
                dt.setMonth(value - 1);
                layout.value = dt;
            }
        }
    }
    Component {
        id: monthSelectTouchComponent
        Tumbler {
            delegate: tumberDelegate
            model: NumberModel {
                minimumValue: 1
                maximumValue: 12
            }
        }
    }
    Component {
        id: yearSelectComponent
        SpinBox {
            from: 1970
            to: 2100 //I assume we'll have a new LTS release by then
            editable: true
            textFromValue: function(value) {return value} //default implementation does toLocaleString which looks super weird
            value: layout.value.getFullYear();
            onValueModified: {
                var dt = layout.value;
                dt.setFullYear(value);
                layout.value = dt;
            }
        }
    }
    Component {
        id: yearSelectTouchComponent
        Tumbler {
            delegate: tumberDelegate
            model: NumberModel {
                minimumValue: 1970
                maximumValue: 2100
            }
        }
    }

    Component {
        id: labelComponent
        Label {
        }
    }
}
