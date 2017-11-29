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
import org.kde.qqc2desktopstyle.private 1.0 as StylePrivate
import QtQuick.Templates @QQC2_VERSION@ as T

T.ScrollBar {
    id: controlRoot

    implicitWidth: background.implicitWidth
    implicitHeight: background.implicitHeight

    hoverEnabled: true

    visible: controlRoot.size < 1.0

    background: MouseArea {
        id: mouseArea
        anchors.fill: parent
        visible: controlRoot.size < 1.0
        hoverEnabled: true
        onPositionChanged: style.activeControl = style.hitTest(mouse.x, mouse.y)
        onExited: style.activeControl = "groove";
        onPressed: {
            if (style.activeControl == "down") {
                buttonTimer.increment = 0.02;
                buttonTimer.running = true;
                mouse.accepted = true
            } else if (style.activeControl == "up") {
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

        StylePrivate.StyleItem {
            id: style
            control: controlRoot
            anchors.fill: parent
            elementType: "scrollbar"
            hover: activeControl != "none"
            activeControl: "none"
            sunken: controlRoot.pressed
            minimum: 0
            maximum: (controlRoot.height/controlRoot.size - controlRoot.height)
            value: controlRoot.position * (controlRoot.height/controlRoot.size)
            horizontal: controlRoot.orientation == Qt.Horizontal
            enabled: controlRoot.enabled

            visible: controlRoot.size < 1.0
            opacity: mouseArea.containsMouse ? 1 : 0
            Behavior on opacity {
                OpacityAnimator {
                    duration: 250
                }
            }

            Timer {
                id: buttonTimer
                property real increment
                repeat: true
                interval: 150
                onTriggered: {
                    controlRoot.position += increment;
                }
            }
        }
        StylePrivate.StyleItem {
            anchors.fill: parent
            control: controlRoot
            elementType: "scrollbar"
            activeControl: "none"
            sunken: false
            minimum: 0
            maximum: style.maximum
            value: style.value
            horizontal: style.horizontal
            enabled: controlRoot.enabled

            visible: controlRoot.size < 1.0
            opacity: !mouseArea.containsMouse ? 1 : 0
            Behavior on opacity {
                OpacityAnimator {
                    duration: 250
                }
            }
        }
    }

    contentItem: Item {}
}
