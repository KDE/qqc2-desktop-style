/*
 *   Copyright 2016 Marco Martin <mart@kde.org>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU Library General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

import QtQuick 2.6
import QtQuick.Controls 2.0
import QtQuick.Controls.impl 2.0
import QtQuick.Templates 2.0 as T
import QtQuick.Controls 1.0 as QQC1
import QtQuick.Controls.Private 1.0

T.Dial {
    id: control

    implicitWidth: 128
    implicitHeight: 128

    background: DialRing {
        width: control.availableWidth
        height: control.availableHeight
        color: control.visualFocus ? SystemPaletteSingleton.highlight(control.enabled) : SystemPaletteSingleton.text(control.enabled)
        progress: control.position
        opacity: control.enabled ? 0.5 : 0.3
    }

    handle: Rectangle {
        x: (control.width/2) + Math.cos((-(control.angle-90)*Math.PI)/180) * (control.width/2-width/2) - width/2
        y: (control.height/2) + Math.sin(((control.angle-90)*Math.PI)/180) * (control.height/2-height/2) - height/2
        width: 18
        height: width
        radius: 8
        color: control.visualFocus ? SystemPaletteSingleton.highlight(control.enabled) : SystemPaletteSingleton.text(control.enabled)
    }
}
