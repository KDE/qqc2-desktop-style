/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQuick 2.6
import QtQuick.Controls @QQC2_VERSION@ as Controls
import QtQuick.Templates @QQC2_VERSION@ as T
import org.kde.kirigami 2.12 as Kirigami

T.ToolTip {
    id: controlRoot

    @DISABLE_UNDER_QQC2_2_4@ palette: Kirigami.Theme.palette
    Kirigami.Theme.colorSet: Kirigami.Theme.Tooltip
    Kirigami.Theme.inherit: false

    x: parent ? Math.round((parent.width - implicitWidth) / 2) : 0
    y: -implicitHeight - 3

    // Always show the tooltip on top of everything else
    z: 999

    implicitWidth: contentItem.implicitWidth + leftPadding + rightPadding
    implicitHeight: contentItem.implicitHeight + topPadding + bottomPadding

    margins: 6
    padding: 6

    visible: parent && (Kirigami.Settings.tabletMode ? parent.pressed : (parent.hasOwnProperty("hovered") ? parent.hovered : parent.hasOwnProperty("containsMouse") && parent.containsMouse))
    delay: Kirigami.Settings.tabletMode ? Qt.styleHints.mousePressAndHoldInterval : Kirigami.Units.toolTipDelay
    // Timeout based on text length, from QTipLabel::restartExpireTimer
    timeout: 10000 + 40 * Math.max(0, text.length - 100)

    closePolicy: T.Popup.CloseOnEscape | T.Popup.CloseOnPressOutsideParent | T.Popup.CloseOnReleaseOutsideParent

    contentItem: Controls.Label {
        text: controlRoot.text
        wrapMode: Text.WordWrap
        font: controlRoot.font
        Kirigami.Theme.colorSet: Kirigami.Theme.Tooltip
        color: Kirigami.Theme.textColor
    }

    background: Kirigami.ShadowedRectangle {
        radius: 3
        opacity: 0.95
        color: Kirigami.Theme.backgroundColor
        Kirigami.Theme.colorSet: Kirigami.Theme.Tooltip

        shadow.xOffset: 0
        shadow.yOffset: 2
        shadow.size: 4
        shadow.color: Qt.rgba(0, 0, 0, 0.3)
    }
}
