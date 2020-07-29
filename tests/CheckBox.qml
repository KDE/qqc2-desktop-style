import QtQuick 2.3
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.3

ApplicationWindow {
    height: layout.implicitHeight
    width: layout.implicitWidth
    ColumnLayout {
        id: layout

        CheckBox {
        }

        CheckBox {
            text: "text"
        }

        CheckBox {
            icon.name: "checkmark"
        }

        CheckBox {
            text: "text plus icon"
            icon.name: "checkmark"
        }

        CheckBox {
            text: "focused"
            focus: true
        }

        CheckBox {
            text: "checked"
            checkState: Qt.Checked
        }

        CheckBox {
            text: "partially checked"
            checkState: Qt.PartiallyChecked
            tristate: true
        }

        CheckBox {
            text: "disabled"
            enabled: false
        }

        CheckBox {
            text: "disabled and checked"
            enabled: false
            checkState: Qt.Checked
        }

        CheckBox {
            text: "disabled and icon"
            enabled: false
            icon.name: "checkmark"
        }
    }
}

