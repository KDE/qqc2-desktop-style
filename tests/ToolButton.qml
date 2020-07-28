import QtQuick 2.3
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.3

ApplicationWindow
{
    visible: true
    width: 800
    height: 600

    GridLayout {
        anchors.fill: parent
        anchors.margins: 10
        rows: 6
        flow: GridLayout.TopToBottom

        Label {
            text: "Flat"
        }

        ToolButton {
            icon.name: "documentinfo"
            text: "Tool Button Default"
            flat: true
        }

        ToolButton {
            icon.name: "documentinfo"
            text: "Tool Button Icon Only"
            display: ToolButton.IconOnly
            flat: true
        }

        ToolButton {
            icon.name: "documentinfo"
            text: "Tool Button Text Only"
            display: ToolButton.TextOnly
            flat: true
        }

        ToolButton {
            icon.name: "documentinfo"
            text: "Tool Button Text Beside Icon"
            display: ToolButton.TextBesideIcon
            flat: true
        }

        ToolButton {
            icon.name: "documentinfo"
            text: "Tool Button Text Below Icon"
            display: ToolButton.TextUnderIcon
            flat: true
        }

        Label {
            text: "Non-Flat"
        }

        ToolButton {
            icon.name: "documentinfo"
            text: "Tool Button Default"
            flat: false
        }

        ToolButton {
            icon.name: "documentinfo"
            text: "Tool Button Icon Only"
            display: ToolButton.IconOnly
            flat: false
        }

        ToolButton {
            icon.name: "documentinfo"
            text: "Tool Button Text Only"
            display: ToolButton.TextOnly
            flat: false
        }

        ToolButton {
            icon.name: "documentinfo"
            text: "Tool Button Text Beside Icon"
            display: ToolButton.TextBesideIcon
            flat: false
        }

        ToolButton {
            icon.name: "documentinfo"
            text: "Tool Button Text Below Icon"
            display: ToolButton.TextUnderIcon
            flat: false
        }
    }
}
