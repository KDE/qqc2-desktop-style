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
import QtQuick.Templates 2.0 as T
import QtQuick.Controls 1.0 as QQC1
import QtQuick.Controls.Private 1.0

T.MenuItem {
    id: control

    implicitWidth: Math.max(background ? background.implicitWidth : 0,
                            contentItem.implicitWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(background ? background.implicitHeight : 0,
                             Math.max(contentItem.implicitHeight,
                                      indicator ? indicator.implicitHeight : 0) + topPadding + bottomPadding)
    baselineOffset: contentItem.y + contentItem.baselineOffset

    padding: 3
    hoverEnabled: true

    contentItem: Label {
        leftPadding: !control.mirrored ? (control.indicator ? control.indicator.width : 0) + control.spacing : 0
        rightPadding: control.mirrored ? (control.indicator ? control.indicator.width : 0) + control.spacing : 0

        text: control.text
        font: control.font
        color: control.hovered && !control.pressed ? SystemPaletteSingleton.highlightedText(control.enabled) : SystemPaletteSingleton.text(control.enabled)
        elide: Text.ElideRight
        visible: control.text
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
    }

    indicator: CheckIndicator {
        x: control.mirrored ? control.width - width - control.rightPadding : control.leftPadding
        y: control.topPadding + (control.availableHeight - height) / 2

        visible: control.checkable
        on: control.checked
    }

    background: Item {
        implicitWidth: 150

        Rectangle {
            anchors.fill: parent
            color: SystemPaletteSingleton.highlight(control.enabled)
            opacity: control.hovered && !control.pressed ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: 150 } }
        }
    }
}
