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
import org.kde.kirigami 2.2 as Kirigami

T.ScrollBar {
    id: controlRoot

    @DISABLE_UNDER_QQC2_2_3@ palette: Kirigami.Theme.palette
    implicitWidth: background.implicitWidth
    implicitHeight: background.implicitHeight

    hoverEnabled: true

    visible: controlRoot.size < 1.0
    stepSize: 0.02

    background: MouseArea {
        id: mouseArea
        anchors.fill: parent
        visible: controlRoot.size < 1.0
        hoverEnabled: true
        state: "inactive"
        onPositionChanged: style.activeControl = style.hitTest(mouse.x, mouse.y)
        onExited: style.activeControl = "groove";
        onPressed: {
            if (style.activeControl == "down") {
                buttonTimer.increment = 1;
                buttonTimer.running = true;
                mouse.accepted = true
            } else if (style.activeControl == "up") {
                buttonTimer.increment = -1;
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
            opacity: 1

            Timer {
                id: buttonTimer
                property real increment
                repeat: true
                interval: 150
                onTriggered: {
                    if (increment > 0) {
                        controlRoot.increase();
                    } else {
                        controlRoot.decrease();
                    }
                }
            }
        }
        StylePrivate.StyleItem {
            id: inactiveStyle
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
            opacity: 1
        }
        states: [
            State {
                name: "hover"
                when: mouseArea.containsMouse
                PropertyChanges {
                    target: style
                    opacity: 1
                }
                PropertyChanges {
                    target: inactiveStyle
                    opacity: 0
                }
            },
            State {
                name: "inactive"
                when: !mouseArea.containsMouse
                PropertyChanges {
                    target: style
                    opacity: 0
                }
                PropertyChanges {
                    target: inactiveStyle
                    opacity: 1
                }
            }
        ]
        transitions: [
            Transition {
                ParallelAnimation {
                    NumberAnimation {
                        target: style
                        property: "opacity"
                        duration: Kirigami.Units.shortDuration
                        easing.type: Easing.InOutQuad
                    }
                    NumberAnimation {
                        target: inactiveStyle
                        property: "opacity"
                        duration: Kirigami.Units.shortDuration
                        easing.type: Easing.InOutQuad
                    }
                }
            }
        ]
    }

    contentItem: Item {}
}
