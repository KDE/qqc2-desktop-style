/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQuick 2.6
import org.kde.qqc2desktopstyle.private 1.0 as StylePrivate
import QtQuick.Templates @QQC2_VERSION@ as T
import org.kde.kirigami 2.4 as Kirigami

T.Slider {
    id: controlRoot
    @DISABLE_UNDER_QQC2_2_4@ palette: Kirigami.Theme.palette
    Kirigami.Theme.colorSet: Kirigami.Theme.Button

    implicitWidth: Kirigami.Units.gridUnit * 12
    implicitHeight: background.implicitHeight

    hoverEnabled: true
    LayoutMirroring.enabled: Qt.application.layoutDirection === Qt.RightToLeft

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
        value: controlRoot.value*100
        horizontal: controlRoot.orientation === Qt.Horizontal
        enabled: controlRoot.enabled
        hasFocus: controlRoot.activeFocus
        hover: controlRoot.hovered
        activeControl: controlRoot.stepSize > 0 ? "ticks" : ""
    }
}
