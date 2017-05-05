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
//QQC1 is needed for StyleItem to fully work
import QtQuick.Controls 1.0 as QQC1
import QtQuick.Controls.Private 1.0
import QtQuick.Templates 2.0 as T

T.Slider {
    id: control

    implicitWidth: background.implicitWidth
    implicitHeight: background.implicitHeight

    hoverEnabled: true

    handle: Item {}
    
    snapMode: T.Slider.SnapOnRelease

    background: StyleItem {
        elementType: "slider"
        sunken: control.pressed
        implicitWidth: 200
        contentHeight: horizontal ? 22 : implicitWidth
        contentWidth: horizontal ? implicitWidth : 22

        maximum: control.to*100
        minimum: control.from*100
        step: control.stepSize*100
        value: (horizontal ? control.visualPosition : 1 - control.visualPosition)*control.to*100
        horizontal: control.orientation === Qt.Horizontal
        enabled: control.enabled
        hasFocus: control.activeFocus
        hover: control.hovered
        activeControl: control.stepSize > 0 ? "ticks" : ""
    }
}
