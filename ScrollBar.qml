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
import QtQuick.Controls.Private 1.0
import QtQuick.Templates 2.1 as T
import org.kde.kirigami 1.0

T.ScrollBar {
    id: control

    implicitWidth: background.implicitWidth
    implicitHeight: background.implicitHeight

    hoverEnabled: Qt.styleHints.useHoverEffects

    visible: control.size < 1.0
    property bool _desktopStyle : true

    background: MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onPositionChanged: style.activeControl = style.hitTest(mouse.x, mouse.y)
        onExited: style.activeControl = "none";
        onPressed: {
            if (parent.activeControl == "down") {
                buttonTimer.increment = 0.02;
                buttonTimer.running = true;
                mouse.accepted = true
            } else if (parent.activeControl == "up") {
                buttonTimer.increment = -0.02;
                buttonTimer.running = true;
                mouse.accepted = true
            } else {
                mouse.accepted = false
            }
        }
        onReleased: {
            buttonTimer.running = false;
            mouse.accepted = false
        }
        onCanceled: buttonTimer.running = false;

        implicitWidth: style.horizontal ? 200 : style.pixelMetric("scrollbarExtent")
        implicitHeight: style.horizontal ? style.pixelMetric("scrollbarExtent") : 200

        StyleItem {
            id: style
            anchors.fill: parent
            elementType: "scrollbar"
            hover: activeControl != "none"
            activeControl: "none"
            sunken: control.pressed
            minimum: 0
            maximum: (control.height/control.size - control.height)
            value: control.position * (control.height/control.size)
            horizontal: control.orientation == Qt.Horizontal
            enabled: control.enabled

            visible: control.size < 1.0
            opacity: mouseArea.containsMouse ? 1 : 0
            Behavior on opacity {
                OpacityAnimator {
                    duration: Units.longDuration
                }
            }

            Timer {
                id: buttonTimer
                property real increment
                repeat: true
                interval: 150
                onTriggered: {
                    control.position += increment;
                }
            }
        }
    }

    contentItem: Item {
        visible: control.size < 1.0
        Rectangle {
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: parent.top
                bottom: parent.bottom
            }
            radius: Math.min(width, height)
            color: Theme.textColor
            opacity: !mouseArea.containsMouse ? 0.3 : 0
            width: Units.smallSpacing
            Behavior on opacity {
                OpacityAnimator {
                    duration: Units.longDuration
                }
            }
        }
    }

}
