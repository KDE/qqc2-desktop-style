/*
 *   Copyright 2016 Marco Martin <mart@kde.org>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2, or
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

import QtQuick 2.6
import QtQuick.Window 2.2
import QtQuick.Templates 2.0 as T
import QtQuick.Controls 2.0 as Controls
//those for Settings
import QtQuick.Controls 1.0
import QtQuick.Controls.Private 1.0
import QtGraphicalEffects 1.0

T.ComboBox {
    id: control

    implicitWidth: background.implicitWidth + leftPadding + rightPadding
    implicitHeight: background.implicitHeight
    baselineOffset: contentItem.y + contentItem.baselineOffset

    hoverEnabled: true
    padding: 5
    leftPadding: padding + 5
    rightPadding: padding + 5

    delegate: ItemDelegate {
        width: control.popup.width
        text: control.textRole ? (Array.isArray(control.model) ? modelData[control.textRole] : model[control.textRole]) : modelData
        highlighted: control.highlightedIndex == index
        property bool separatorVisible: false
    }

    indicator: Item {}

    contentItem: Item {}

    background: StyleItem {
        id: styleitem
        elementType: "combobox"
        anchors.fill: parent
        hover: control.hovered
        hasFocus: control.activeFocus
        enabled: control.enabled
        text: control.displayText
    }

    popup: T.Popup {
        y: control.height
        width: Math.max(control.width, 150)
        implicitHeight: contentItem.implicitHeight
        topMargin: 6
        bottomMargin: 6

        contentItem: ListView {
            id: listview
            clip: true
            implicitHeight: contentHeight
            model: control.popup.visible ? control.delegateModel : null
            currentIndex: control.highlightedIndex
            highlightRangeMode: ListView.ApplyRange
            highlightMoveDuration: 0
            T.ScrollBar.vertical: Controls.ScrollBar { }
        }
        background: Rectangle {
            anchors {
                fill: parent
                margins: -1
            }
            radius: 2
            color: SystemPaletteSingleton.base(control.enabled)
            property color borderColor: SystemPaletteSingleton.text(control.enabled)
            border.color: Qt.rgba(borderColor.r, borderColor.g, borderColor.b, 0.3)
            layer.enabled: true
            
            layer.effect: DropShadow {
                transparentBorder: true
                radius: 4
                samples: 8
                horizontalOffset: 2
                verticalOffset: 2
                color: Qt.rgba(0, 0, 0, 0.3)
            }
        }
    }
}
