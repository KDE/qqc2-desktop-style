/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQuick 2.6
import org.kde.qqc2desktopstyle.private 1.0 as StylePrivate

Item {
    property alias control: slider.control

    implicitWidth: 32
    implicitHeight : 22

    StylePrivate.StyleItem {
        id: slider
        anchors.fill: parent
        elementType: "slider"
        sunken: control.pressed
        value: control.checked || control.pressed ? 1 : 0
        minimum: 0
        maximum: 1
        hover: control.hovered
        enabled: control.enabled
    }
}

