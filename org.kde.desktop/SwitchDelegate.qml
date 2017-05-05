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


import QtQuick 2.5
import QtQuick.Controls.Private 1.0
import QtQuick.Templates 2.0 as T
import "private"

T.SwitchDelegate {
    id: control

    implicitWidth: contentItem.implicitWidth + leftPadding + rightPadding
    implicitHeight: Math.max(contentItem.implicitHeight,
                                      indicator ? indicator.implicitHeight : 0) + topPadding + bottomPadding
    hoverEnabled: true

    padding: 4
    spacing: 4
    rightPadding: 20

    contentItem: Label {
        leftPadding: control.mirrored ? (control.indicator ? control.indicator.width : 0) + control.spacing : 0
        rightPadding: !control.mirrored ? (control.indicator ? control.indicator.width : 0) + control.spacing : 0

        text: control.text
        font: control.font
        color: (control.pressed && !control.checked && !control.sectionDelegate) ? SystemPaletteSingleton.highlightedText(control.enabled) : SystemPaletteSingleton.text(control.enabled)
        elide: Text.ElideRight
        visible: control.text
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
    }

    indicator: SwitchIndicator {
        x: control.mirrored ? control.leftPadding : control.width - width - control.rightPadding
        y: control.topPadding + (control.availableHeight - height) / 2

        control: control
    }

    background: DefaultListItemBackground {}
}
