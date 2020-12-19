/*
    SPDX-FileCopyrightText: 2018 Oleg Chernovskiy <adonai@xaker.ru>
    SPDX-FileCopyrightText: 2018 The Qt Company Ltd.

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQuick 2.6
import org.kde.kirigami 2.4 as Kirigami
import QtQuick.Templates @QQC2_VERSION@ as T

T.BusyIndicator {
    id: controlRoot

    palette: Kirigami.Theme.palette
    implicitWidth: contentItem.implicitWidth + leftPadding + rightPadding
    implicitHeight: contentItem.implicitHeight + topPadding + bottomPadding

    padding: 6
    spacing: Kirigami.Units.smallSpacing

    hoverEnabled: true

    contentItem: Kirigami.Icon {
        source: "view-refresh"
        opacity: controlRoot.running ? 1 : 0
        smooth: true

        // appearing/fading opacity change
        Behavior on opacity {
            OpacityAnimator { duration: 250 }
        }

        // rotating loading icon
        RotationAnimator {
            target: controlRoot.contentItem
            running: controlRoot.visible && controlRoot.running
            from: 0
            to: 360
            loops: Animation.Infinite
            duration: 2000
        }
    }
}
