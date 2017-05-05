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

T.ToolBar {
    id: control

    implicitWidth: Math.max(background ? background.implicitWidth : 0, contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(background ? background.implicitHeight : 0, contentHeight + topPadding + bottomPadding)

    contentWidth: contentChildren[0].implicitWidth
    contentHeight: contentChildren[0].implicitHeight

    contentItem: Item { }

    background: Rectangle {
        implicitHeight: 40
        color: SystemPaletteSingleton.window(control.enabled)
        Rectangle {
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }
            height: 1
            color: SystemPaletteSingleton.text(control.enabled)
            opacity: 0.3
        }
    }
}
