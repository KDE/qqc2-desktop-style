import QtQuick 2.3
import QtQuick.Controls 2.3

ScrollView {
    height: 100
    width: 300
    ListView {
        model: 100
        delegate: Text {
            text: modelData
        }
    }
}
