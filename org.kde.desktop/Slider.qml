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
    palette: Kirigami.Theme.palette
    Kirigami.Theme.colorSet: Kirigami.Theme.Button

    implicitWidth: background.horizontal ? Kirigami.Units.gridUnit * 12 : background.implicitWidth
    implicitHeight: background.horizontal ? background.implicitHeight : Kirigami.Units.gridUnit * 12

    hoverEnabled: true
    LayoutMirroring.enabled: Qt.application.layoutDirection === Qt.RightToLeft

    handle: Item {}

    snapMode: T.Slider.SnapOnRelease

    background: StylePrivate.StyleItem {
        control: controlRoot
        elementType: "slider"
        sunken: controlRoot.pressed
        implicitWidth: 200
        contentWidth: horizontal ? controlRoot.implicitWidth : 22
        contentHeight: horizontal ? 22 : controlRoot.implicitHeight

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
