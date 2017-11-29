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
import QtQuick.Templates @QQC2_VERSION@ as T
import org.kde.kirigami 2.2 as Kirigami

T.ToolBar {
    id: controlRoot

    implicitWidth: Math.max(background ? background.implicitWidth : 0, contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(background ? background.implicitHeight : 0, contentHeight + topPadding + bottomPadding)

    contentWidth: contentChildren[0].implicitWidth
    contentHeight: contentChildren[0].implicitHeight

    contentItem: Item {}

    background: Rectangle {
        implicitHeight: 40
        color: Kirigami.Theme.backgroundColor
        Kirigami.Separator {
            anchors {
                left: parent.left
                right: parent.right
                top: controlRoot.parent.footer && controlRoot.parent.footer == controlRoot ? parent.top : undefined
                bottom: controlRoot.parent.footer && controlRoot.parent.footer == controlRoot ? undefined : parent.bottom
            }
        }
    }
}
