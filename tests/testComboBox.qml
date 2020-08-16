import QtQuick 2.3
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.3

ApplicationWindow
{
    visible: true

    ColumnLayout {
        anchors.fill: parent
        ComboBox {
            Layout.fillWidth: true
            textRole: "key"
            model: ListModel {
                id: comboModel
                ListElement { key: "First"; value: 123 }
                ListElement { key: "Second"; value: 456 }
                ListElement { key: "Third"; value: 789 }
            }
        }

        ComboBox {
            Layout.fillWidth: true
            textRole: "key"
            model: comboModel
            editable: true
        }

        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: comboModel
            delegate: Label { text: key }
        }
    }
}
