/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.
    SPDX-FileCopyrightText: 2023 ivan tkachenko <me@ratijas.tk>

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/

import QtQuick
import QtQuick.Templates as T
import org.kde.kirigami as Kirigami
import org.kde.desktop.private as Private
import org.kde.desktop.impl as StyleImpl

T.Slider {
    id: controlRoot

    Kirigami.Theme.colorSet: Kirigami.Theme.Button

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    hoverEnabled: true

    handle: Private.DefaultSliderHandle {
        control: controlRoot
    }

    snapMode: T.Slider.SnapOnRelease

    background: StyleImpl.StyleItem {
        control: controlRoot
        elementType: "slider"
        sunken: controlRoot.pressed

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
