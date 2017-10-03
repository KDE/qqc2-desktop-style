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
import QtQuick.Controls 2.0
import QtQuick.Controls.impl 2.0
import QtQuick.Templates 2.0 as T
import org.kde.kirigami 2.2 as Kirigami

T.Dial {
    id: control

    implicitWidth: 128
    implicitHeight: 128

    background: DialRing {
        width: control.availableWidth
        height: control.availableHeight
        color: control.visualFocus ? Kirigami.Theme.highlightColor : Kirigami.Theme.textColor
        progress: control.position
        opacity: control.enabled ? 0.5 : 0.3
    }

    handle: Rectangle {
        x: (control.width/2) + Math.cos((-(control.angle-90)*Math.PI)/180) * (control.width/2-width/2) - width/2
        y: (control.height/2) + Math.sin(((control.angle-90)*Math.PI)/180) * (control.height/2-height/2) - height/2
        width: 18
        height: width
        radius: 8
        color: control.visualFocus ? Kirigami.Theme.highlightColor : Kirigami.Theme.textColor
    }
}
