import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import QtQuick.Layouts 1.15

import org.kde.kirigami 2.20 as Kirigami
import org.kde.kirigamiaddons.labs.toolbar 0.1

QQC2.ToolBar {
    id: toolBar
    property list<Kirigami.Action> actions
    property alias defaultLayout: manager.defaultLayout

    RowLayout {
        Repeater {
            id: repeater
            model: ToolBarStateManager {
                id: manager
                actions: toolBar.actions
            }

            delegate: QQC2.ToolButton {
                id: button
                text: model.text
                icon.name: model.icon
                onClicked: toolBar.actions[model.indexInAll].triggered()
                onPressAndHold: {
                    let dialog = buttonEditDialog.createObject(applicationWindow().overlay, {
                        manager: manager,
                        index: model.index,
                        text: button.text,
                    })
                    dialog.displayChanged.connect(mode => button.display = mode)
                    dialog.textChanged.connect(() => button.text = dialog.text)
                    dialog.open()
                }
            }
        }
    }

    Component {
        id: buttonEditDialog
        ButtonEditDialog {

        }
    }
}
