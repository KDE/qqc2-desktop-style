/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQuick 2.6
import org.kde.qqc2desktopstyle.private 1.0 as StylePrivate
import QtQuick.Templates 2.15 as T
import org.kde.kirigami 2.4 as Kirigami

T.Slider {
    id: controlRoot
    Kirigami.Theme.colorSet: Kirigami.Theme.Button

    implicitWidth: background.horizontal ? Kirigami.Units.gridUnit * 12 : background.implicitWidth
    implicitHeight: background.horizontal ? background.implicitHeight : Kirigami.Units.gridUnit * 12

    hoverEnabled: true
    LayoutMirroring.enabled: Qt.application.layoutDirection === Qt.RightToLeft

    handle: Item {
        anchors.verticalCenter: controlRoot.verticalCenter
    }

    snapMode: T.Slider.SnapOnRelease

    background: StylePrivate.StyleItem {
        control: controlRoot
        elementType: "slider"
        sunken: controlRoot.pressed
        implicitWidth: 200
        contentWidth: horizontal ? controlRoot.implicitWidth : (Kirigami.Settings.tabletMode ? 24 : 22)
        contentHeight: horizontal ? (Kirigami.Settings.tabletMode ? 24 : 22) : controlRoot.implicitHeight
        anchors.verticalCenter: controlRoot.verticalCenter

        maximum: 10000 * controlRoot.to
        minimum: 10000 * controlRoot.from
        step: 10000 * controlRoot.stepSize
        value: 10000 * controlRoot.value
        horizontal: controlRoot.orientation === Qt.Horizontal
        enabled: controlRoot.enabled
        hasFocus: controlRoot.activeFocus
        hover: controlRoot.hovered
        activeControl: controlRoot.stepSize > 0 ? "ticks" : ""

        // `wheelEnabled: true` doesn't work since it doesn't snap to tickmarks,
        // so we have to implement the scroll handling ourselves. See
        // https://bugreports.qt.io/browse/QTBUG-93081
        MouseArea {
            property int wheelDelta: 0

            anchors {
                fill: parent
                leftMargin: controlRoot.leftPadding
                rightMargin: controlRoot.rightPadding
            }

            acceptedButtons: Qt.NoButton

            onWheel: {
                const lastValue = controlRoot.value
                const delta = wheel.angleDelta.y || wheel.angleDelta.x
                wheelDelta += delta;
                // magic number 120 for common "one click"
                // See: https://doc.qt.io/qt-5/qml-qtquick-wheelevent.html#angleDelta-prop
                while (wheelDelta >= 120) {
                    wheelDelta -= 120;
                    controlRoot.decrease();
                }
                while (wheelDelta <= -120) {
                    wheelDelta += 120;
                    controlRoot.increase();
                }
                if (lastValue !== controlRoot.value) {
                    controlRoot.moved();
                }
            }
        }
    }
}
