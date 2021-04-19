import QtQuick 2.3
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.3

ApplicationWindow {
    height: layout.implicitHeight
    width: 300
    ColumnLayout {
        width: parent.width
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

        CheckBox {
            Layout.fillWidth: true
            text: "This is a very long piece of text that really should be rewritten to be shorter, but sometimes life just isn't that simple."
        }
    }
}

