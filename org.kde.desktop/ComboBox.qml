/*
 * Copyright 2017 Marco Martin <mart@kde.org>
 * Copyright 2017 The Qt Company Ltd.
 *
 * GNU Lesser General Public License Usage
 * Alternatively, this file may be used under the terms of the GNU Lesser
 * General Public License version 3 as published by the Free Software
 * Foundation and appearing in the file LICENSE.LGPLv3 included in the
 * packaging of this file. Please review the following information to
 * ensure the GNU Lesser General Public License version 3 requirements
 * will be met: https://www.gnu.org/licenses/lgpl.html.
 *
 * GNU General Public License Usage
 * Alternatively, this file may be used under the terms of the GNU
 * General Public License version 2.0 or later as published by the Free
 * Software Foundation and appearing in the file LICENSE.GPL included in
 * the packaging of this file. Please review the following information to
 * ensure the GNU General Public License version 2.0 requirements will be
 * met: http://www.gnu.org/licenses/gpl-2.0.html.
 */


import QtQuick 2.6
import QtQuick.Window 2.2
import QtQuick.Templates 2.0 as T
import QtQuick.Controls 2.0 as Controls
import org.kde.qqc2desktopstyle.private 1.0 as StylePrivate
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

    background: StylePrivate.StyleItem {
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
            color: StylePrivate.SystemPaletteSingleton.base(control.enabled)
            property color borderColor: StylePrivate.SystemPaletteSingleton.text(control.enabled)
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
