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
import QtQuick.Templates 2.0 as T
//for systempalettesingleton
import QtQuick.Controls 1.0 as QQC1
import QtQuick.Controls.Private 1.0

T.RangeSlider {
    id: control

    implicitWidth: Math.max(background ? background.implicitWidth : 0,
        Math.max(first.handle ? first.handle.implicitWidth : 0,
                 second.handle ? second.handle.implicitWidth : 0) + leftPadding + rightPadding)
    implicitHeight: Math.max(background ? background.implicitHeight : 0,
        Math.max(first.handle ? first.handle.implicitHeight : 0,
                 second.handle ? second.handle.implicitHeight : 0) + topPadding + bottomPadding)

    padding: 6

    first.handle: Rectangle {
        property bool horizontal: control.orientation === Qt.Horizontal
        x: control.leftPadding + (horizontal ? control.first.visualPosition * (control.availableWidth - width) : (control.availableWidth - width) / 2)
        y: control.topPadding + (horizontal ? (control.availableHeight - height) / 2 : control.first.visualPosition * (control.availableHeight - height))
        implicitWidth: 18
        implicitHeight: 18
        radius: width / 2
        property color borderColor: SystemPaletteSingleton.text(control.enabled)
        border.color: control.activeFocus ? SystemPaletteSingleton.highlight(control.enabled) : Qt.rgba(borderColor.r, borderColor.g, borderColor.b, 0.3)
        color: SystemPaletteSingleton.window(control.enabled)
        Rectangle {
            z: -1
            x: 1
            y: 1
            width: parent.width
            height: parent.height
            radius: width / 2
            color: Qt.rgba(0, 0, 0, 0.15)
        }
    }

    second.handle: Rectangle {
        property bool horizontal: control.orientation === Qt.Horizontal
        x: control.leftPadding + (horizontal ? control.second.visualPosition * (control.availableWidth - width) : (control.availableWidth - width) / 2)
        y: control.topPadding + (horizontal ? (control.availableHeight - height) / 2 : control.second.visualPosition * (control.availableHeight - height))
        implicitWidth: 18
        implicitHeight: 18
        radius: width / 2
        property color borderColor: SystemPaletteSingleton.text(control.enabled)
        border.color: control.activeFocus ? SystemPaletteSingleton.highlight(control.enabled) : Qt.rgba(borderColor.r, borderColor.g, borderColor.b, 0.3)
        color: SystemPaletteSingleton.window(control.enabled)
        Rectangle {
            z: -1
            x: 1
            y: 1
            width: parent.width
            height: parent.height
            radius: width / 2
            color: Qt.rgba(0, 0, 0, 0.15)
        }
    }

    background: Rectangle {
        readonly property bool horizontal: control.orientation === Qt.Horizontal
        implicitWidth: horizontal ? 200 : 6
        implicitHeight: horizontal ? 6 : 200
        width: horizontal ? control.availableWidth : implicitWidth
        height: horizontal ? implicitHeight : control.availableHeight
        radius: Math.round(Math.min(width/2, height/2))
        property color bgColor: SystemPaletteSingleton.text(control.enabled)
        color: Qt.rgba(bgColor.r, bgColor.g, bgColor.b, 0.3)
        anchors.centerIn: parent

        Rectangle {
            x: parent.horizontal ? control.first.position * parent.width : 0
            y: parent.horizontal ? 0 : control.second.visualPosition * parent.height + 6
            width: parent.horizontal ? control.second.position * parent.width - control.first.position * parent.width - 6 : 6
            height: parent.horizontal ? 6 : control.second.position * parent.height - control.first.position * parent.height - 6
            color: SystemPaletteSingleton.highlight(control.enabled)
        }
    }
}
