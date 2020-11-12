/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQuick 2.6
import org.kde.qqc2desktopstyle.private 1.0 as StylePrivate
import QtQuick.Templates @QQC2_VERSION@ as T
import org.kde.kirigami 2.11 as Kirigami

T.ScrollBar {
    id: controlRoot

    @DISABLE_UNDER_QQC2_2_4@ palette: Kirigami.Theme.palette
    implicitWidth: background.implicitWidth
    implicitHeight: background.implicitHeight

    hoverEnabled: true

    visible: controlRoot.size < 1.0 && controlRoot.policy !== T.ScrollBar.AlwaysOff
    stepSize: 0.02
    interactive: !Kirigami.Settings.hasTransientTouchInput

    onPositionChanged: {
        disappearTimer.restart();
        handleGraphics.handleState = Math.min(1, handleGraphics.handleState + 0.1)
    }

    contentItem: Item {
        visible: !controlRoot.interactive

        Rectangle {
            id: handleGraphics
            property real handleState: 0

            x: Math.round(controlRoot.orientation == Qt.Vertical
                ? (Qt.application.layoutDirection === Qt.LeftToRight
                    ? (parent.width - width) - (parent.width/2 - width/2) * handleState
                    : (parent.width/2 - width/2) * handleState)
                : 0)

            y: Math.round(controlRoot.orientation == Qt.Horizontal
                ? (parent.height - height) - (parent.height/2 - height/2) * handleState
                : 0)


            NumberAnimation {
                id: resetAnim
                target: handleGraphics
                property: "handleState"
                from: handleGraphics.handleState
                to: 0
                duration: Kirigami.Units.longDuration
                easing.type: Easing.InOutQuad
            }

            width: Math.round(controlRoot.orientation == Qt.Vertical
                    ? Math.max(2, Kirigami.Units.smallSpacing * handleState)
                    : parent.width)
            height: Math.round(controlRoot.orientation == Qt.Horizontal
                    ? Math.max(2, Kirigami.Units.smallSpacing * handleState)
                    : parent.height)
            radius: Math.min(width, height)
            color: Kirigami.Theme.textColor
            opacity: 0.3
            Timer {
                id: disappearTimer
                interval: 1000
                onTriggered: {
                    resetAnim.restart();
                    handleGraphics.handleState = 0;
                }
            }
        }
    }

    background: MouseArea {
        id: mouseArea
        anchors.fill: parent
        visible: controlRoot.size < 1.0 && interactive
        hoverEnabled: true
        state: "inactive"
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton
        onExited: style.activeControl = "groove";
        onPressed: {
            var jump_position = Math.min(1 - controlRoot.size, Math.max(0, mouse.y/(controlRoot.orientation == Qt.Vertical ? height: width) - controlRoot.size/2));
            if (mouse.buttons & Qt.MiddleButton) {
                style.activeControl = "handle";
                controlRoot.position = jump_position;
                mouse.accepted = true;
            } else if (style.activeControl == "down") {
                buttonTimer.increment = 1;
                buttonTimer.running = true;
                mouse.accepted = true
            } else if (style.activeControl == "up") {
                buttonTimer.increment = -1;
                buttonTimer.running = true;
                mouse.accepted = true
            } else if (style.activeControl == "downPage") {
                if (style.styleHint("scrollToClickPosition")) {
                    controlRoot.position = jump_position;
                } else {
                    buttonTimer.increment = controlRoot.size;
                    buttonTimer.running = true;
                }
                mouse.accepted = true
            } else if (style.activeControl == "upPage") {
                if (style.styleHint("scrollToClickPosition")) {
                    controlRoot.position = jump_position;
                } else {
                    buttonTimer.increment = -controlRoot.size;
                    buttonTimer.running = true;
                }
                mouse.accepted = true
            } else {
                mouse.accepted = false
            }
        }
        onPositionChanged: {
            style.activeControl = style.hitTest(mouse.x, mouse.y)
            if (mouse.buttons & Qt.MiddleButton) {
                style.activeControl = "handle";
                controlRoot.position = Math.min(1 - controlRoot.size, Math.max(0, mouse.y/style.length - controlRoot.size/2));
                mouse.accepted = true;
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

            readonly property real length: (controlRoot.orientation == Qt.Vertical ? height : width)

            control: controlRoot
            anchors.fill: parent
            elementType: "scrollbar"
            hover: activeControl != "none"
            activeControl: "none"
            sunken: controlRoot.pressed
            minimum: 0
            maximum: style.length/controlRoot.size - style.length
            value: controlRoot.position * (style.length/controlRoot.size)
            horizontal: controlRoot.orientation == Qt.Horizontal
            enabled: controlRoot.enabled

            visible: controlRoot.size < 1.0
            opacity: 1

            Timer {
                id: buttonTimer
                property real increment
                repeat: true
                interval: 150
                triggeredOnStart: true
                onTriggered: {
                    if (increment == 1) {
                        controlRoot.increase();
                    } else if (increment == -1) {
                        controlRoot.decrease();
                    } else {
                        controlRoot.position = Math.min(1 - controlRoot.size, Math.max(0, controlRoot.position + increment));
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
}
