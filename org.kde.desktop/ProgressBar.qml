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
//QQC1 is needed for StyleItem to fully work
import QtQuick.Controls 1.0 as QQC1
import QtQuick.Controls.Private 1.0
import QtQuick.Templates 2.0 as T

T.ProgressBar {
    id: control

    implicitWidth: 250
    implicitHeight: 22

    hoverEnabled: true

    contentItem: Item {}
    
    background: StyleItem {
        elementType: "progressbar"

        maximum: indeterminate ? 0 : control.to*100
        minimum: indeterminate ? 0 : control.from*100
        value: indeterminate ? 0 : ((!control.inverted ? control.visualPosition : 1 - control.visualPosition)*control.to*100)
        horizontal: true
        enabled: control.enabled
        Timer {
            interval: 50
            running: control.indeterminate
            repeat: true
            onTriggered: parent.updateItem();
        }
    }
}
