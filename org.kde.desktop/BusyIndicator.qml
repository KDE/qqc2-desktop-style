/*
    SPDX-FileCopyrightText: 2018 Oleg Chernovskiy <adonai@xaker.ru>
    SPDX-FileCopyrightText: 2018 The Qt Company Ltd.

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQuick 2.6
import org.kde.kirigami 2.4 as Kirigami
import QtQuick.Templates 2.15 as T

T.BusyIndicator {
    id: controlRoot

    implicitWidth: contentItem.implicitWidth + leftPadding + rightPadding
    implicitHeight: contentItem.implicitHeight + topPadding + bottomPadding

    padding: 6
    spacing: Kirigami.Units.smallSpacing

    hoverEnabled: true

    contentItem: Kirigami.Icon {
        source: "process-working-symbolic"
        opacity: controlRoot.running ? 1 : 0
        smooth: true

        // appearing/fading opacity change
        Behavior on opacity {
            OpacityAnimator { duration: Kirigami.Units.longDuration }
        }

        // rotating loading icon
        RotationAnimator {
            target: controlRoot.contentItem
            // Don't want it to animate at all if the user has disabled animations
            running: controlRoot.visible && controlRoot.running && Kirigami.Units.longDuration > 1
            from: 0
            to: 360
            loops: Animation.Infinite
            // Not using a standard duration value because we don't want the
            // animation to spin faster or slower based on the user's animation
            // scaling preferences; it doesn't make sense in this context
            duration: 2000
        }
    }
}
