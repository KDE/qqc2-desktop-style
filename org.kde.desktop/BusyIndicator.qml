/*
 * Copyright 2018 Oleg Chernovskiy <adonai@xaker.ru>
 * Copyright 2018 The Qt Company Ltd.
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
import org.kde.kirigami 2.2 as Kirigami
import QtQuick.Templates @QQC2_VERSION@ as T

T.BusyIndicator {
    id: controlRoot

    implicitWidth: contentItem.implicitWidth + leftPadding + rightPadding
    implicitHeight: contentItem.implicitHeight + topPadding + bottomPadding

    padding: 6
    spacing: Kirigami.Units.smallSpacing

    hoverEnabled: true

    contentItem: Kirigami.Icon {
        source: "view-refresh"
        opacity: controlRoot.running ? 1 : 0

        // appearing/fading opacity change
        Behavior on opacity {
            OpacityAnimator { duration: 250 }
        }

        // rotating loading icon
        RotationAnimator {
            target: controlRoot
            running: controlRoot.visible && controlRoot.running
            from: 360
            to: 0
            loops: Animation.Infinite
            duration: 1000
        }
    }
}
