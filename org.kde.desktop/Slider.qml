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
import org.kde.qqc2desktopstyle.private 1.0 as StylePrivate
import QtQuick.Templates @QQC2_VERSION@ as T
import org.kde.kirigami 2.4 as Kirigami

T.Slider {
    id: controlRoot
    @DISABLE_UNDER_QQC2_2_4@ palette: Kirigami.Theme.palette
    Kirigami.Theme.colorSet: Kirigami.Theme.Button

    implicitWidth: background.implicitWidth
    implicitHeight: background.implicitHeight

    hoverEnabled: true

    handle: Item {}
    
    snapMode: T.Slider.SnapOnRelease

    background: StylePrivate.StyleItem {
        control: controlRoot
        elementType: "slider"
        sunken: controlRoot.pressed
        implicitWidth: 200
        contentHeight: horizontal ? 22 : implicitWidth
        contentWidth: horizontal ? implicitWidth : 22

        maximum: controlRoot.to*100
        minimum: controlRoot.from*100
        step: controlRoot.stepSize*100
        value: (horizontal ? controlRoot.visualPosition : 1 - controlRoot.visualPosition)*controlRoot.to*100
        horizontal: controlRoot.orientation === Qt.Horizontal
        enabled: controlRoot.enabled
        hasFocus: controlRoot.activeFocus
        hover: controlRoot.hovered
        activeControl: controlRoot.stepSize > 0 ? "ticks" : ""
    }
}
