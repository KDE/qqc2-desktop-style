import QtQuick 2.5
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.12

ColumnLayout {
    anchors.fill: parent
    anchors.margins: 20

    spacing: 0

    TabBar {
        id: tabView

        TabButton {
            text: "White"
        }
        TabButton {
            text: "Green"
        }
        TabButton {
            text: "Blue"
        }
    }

    Frame {
        Layout.fillWidth: true
        Layout.fillHeight: true

        StackLayout { //or SwipeView + clip for animated?
            anchors.fill: parent

            currentIndex: tabView.currentIndex

            Rectangle {
                color: "white"
            }
            Rectangle {
                color: "Green"
            }
            Rectangle {
                color: "Blue"
            }
        }
    }
}
