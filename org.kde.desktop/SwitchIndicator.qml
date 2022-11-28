/*
    SPDX-FileCopyrightText: 2022 Tanbir Jishan <tantalising007@gmail.com>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/

import QtQuick 2.15
import org.kde.kirigami 2.8 as Kirigami

Item {
    id: indicator
    implicitWidth: implicitHeight * 2
    implicitHeight: Kirigami.Units.gridUnit
    layer.enabled: control.opacity < 1.0

    property Item control
    property alias handle: handle

    Kirigami.Theme.colorSet: Kirigami.Theme.Button
    Kirigami.Theme.inherit: false

    QtObject { // colors collected in one place so that main code remains clean and these properties are not exposed
        id: colorFactory

        readonly property color switchColor: control.checked ? Qt.rgba(Kirigami.Theme.highlightColor.r, Kirigami.Theme.highlightColor.g, Kirigami.Theme.highlightColor.b, 0.5) : blendBackgroundWithTextColorWithRatio(0.9)
        readonly property color switchBorderColor: control.checked ? Kirigami.Theme.highlightColor : handleBorderColor

        readonly property color handleColor: Kirigami.Theme.backgroundColor
        readonly property color handleBorderColor: (control.hovered || control.visualFocus) ? Kirigami.Theme.hoverColor : blendBackgroundWithTextColorWithRatio(0.7)

        function blendBackgroundWithTextColorWithRatio(factor) {
            // blending of background color with text color for producing a border color. The usual ratios are 70:30, 80:20 and 75:25. The more the background color, the more the contrast.
            return Qt.tint(Kirigami.Theme.textColor, Qt.rgba(Kirigami.Theme.backgroundColor.r, Kirigami.Theme.backgroundColor.g, Kirigami.Theme.backgroundColor.b, factor))
        }
    }

    Rectangle {
        id: background

        anchors {
            fill: parent
            // margins so that the background is a bit shorter than the handle
            topMargin: Math.floor(parent.height / 6)
            bottomMargin: Math.floor(parent.height / 6)
        }

        radius: Math.round(height / 2)
        color: colorFactory.switchColor
        border.color: colorFactory.switchBorderColor

        Behavior on color {
            ColorAnimation {
                easing.type: Easing.InCubic
                duration: Kirigami.Units.shortDuration
            }
        }
    }

    Rectangle {
        id: handle

        // It's necessary to use x position instead of anchors so that the handle position can be dragged
        x: Math.min(parent.width - width, control.visualPosition * parent.width)

        anchors {
            top: parent.top
            bottom: parent.bottom
        }

        width: height
        radius: Math.floor(width / 2)
        color: colorFactory.handleColor
        border.color: colorFactory.handleBorderColor

        Behavior on x {
            enabled: !control.pressed
            SmoothedAnimation {
                duration: Kirigami.Units.shortDuration
            }
        }

        Behavior on color {
            ColorAnimation {
                easing.type: Easing.InCubic
                duration: Kirigami.Units.shortDuration
            }
        }
    }
}
