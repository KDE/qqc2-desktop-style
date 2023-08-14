/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.
    SPDX-FileCopyrightText: 2023 ivan tkachenko <me@ratijas.tk>

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/

import QtQuick
import org.kde.qqc2desktopstyle.private as StylePrivate
import QtQuick.Templates as T
import org.kde.kirigami 2 as Kirigami

T.Slider {
    id: controlRoot

    Kirigami.Theme.colorSet: Kirigami.Theme.Button

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    hoverEnabled: true

    handle: Item {
        anchors.verticalCenter: controlRoot.verticalCenter
    }

    snapMode: T.Slider.SnapOnRelease

    background: StylePrivate.StyleItem {
        control: controlRoot
        elementType: "slider"
        sunken: controlRoot.pressed

        // Normally, you would rely on implicit size provided by
        // QStyle::sizeFromContents, but it seems like no style ever
        // implemented it for Sliders, at least not for the ones without ticks.
        //
        // Tablet Mode check is artificial, and does not affect actual
        // rendering in any way, at least in Breeze or any other shipped style.
        contentWidth: controlRoot.horizontal ? Kirigami.Units.gridUnit * 12 : (Kirigami.Settings.tabletMode ? 24 : 22)
        contentHeight: controlRoot.vertical ? Kirigami.Units.gridUnit * 12 : (Kirigami.Settings.tabletMode ? 24 : 22)
        // Most styles draw sliders at the top of their available area, rather than centered.
        anchors.verticalCenter: controlRoot.verticalCenter

        minimum: 0
        maximum: 100000
        step: 100000 * (controlRoot.stepSize / (controlRoot.to - controlRoot.from))
        value: 100000 * position

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
            LayoutMirroring.enabled: false

            acceptedButtons: Qt.NoButton

            onWheel: wheel => {
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
