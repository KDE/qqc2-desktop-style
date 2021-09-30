import QtQuick 2.15
import QtQuick.Templates 2.15 as T
import org.kde.kirigami 2.15 as Kirigami

T.Control {
    implicitWidth: 18
    implicitHeight: 18
    contentItem: Rectangle {
        property bool horizontal: control.orientation === Qt.Horizontal
        implicitWidth: 18
        implicitHeight: 18
        radius: width / 2
        property color borderColor: Kirigami.Theme.textColor
        border.color: control.activeFocus ? Kirigami.Theme.highlightColor : Qt.rgba(borderColor.r, borderColor.g, borderColor.b, 0.3)
        color: Kirigami.Theme.backgroundColor
        Rectangle {
            z: -1
            x: 1
            y: 1
            width: parent.width
            height: parent.height
            radius: width / 2
            color: Qt.rgba(0, 0, 0, 0.15)
        }
    }
}