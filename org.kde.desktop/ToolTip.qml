/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQuick 2.6
import QtQuick.Controls 2.15 as Controls
import QtQuick.Templates 2.15 as T
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.12 as Kirigami

T.ToolTip {
    id: control

    Kirigami.Theme.colorSet: Kirigami.Theme.Tooltip
    Kirigami.Theme.inherit: false

    x: parent ? Math.round((parent.width - implicitWidth) / 2) : 0
    y: -implicitHeight - 3

    // Always show the tooltip on top of everything else
    z: 999

    // Math.ceil() prevents blurry edges and prevents unnecessary text wrapping
    // (vs using floor or sometimes round).
    implicitWidth: Math.ceil(contentItem.implicitWidth) + leftPadding + rightPadding
    implicitHeight: Math.ceil(contentItem.implicitHeight) + topPadding + bottomPadding

    margins: 6
    padding: 6

    visible: parent && (Kirigami.Settings.tabletMode ? parent.pressed : (parent.hasOwnProperty("hovered") ? parent.hovered : parent.hasOwnProperty("containsMouse") && parent.containsMouse))
    delay: Kirigami.Settings.tabletMode ? Qt.styleHints.mousePressAndHoldInterval : Kirigami.Units.toolTipDelay
    // Timeout based on text length, from QTipLabel::restartExpireTimer
    timeout: 10000 + 40 * Math.max(0, text.length - 100)

    closePolicy: T.Popup.CloseOnEscape | T.Popup.CloseOnPressOutsideParent | T.Popup.CloseOnReleaseOutsideParent

    enter: Transition {
        NumberAnimation {
            property: "opacity"
            from: 0.0
            to: 1.0
            duration: Kirigami.Units.longDuration
            easing.type: Easing.OutCubic
        }
    }

    exit: Transition {
        NumberAnimation {
            property: "opacity"
            from: 1.0
            to: 0.0
            duration: Kirigami.Units.longDuration
            easing.type: Easing.OutCubic
        }
    }

    // FIXME: use a top-level Item here so that ToolTip instances with child
    // items can safely use anchors
    contentItem: RowLayout {
        Controls.Label {
            // Strip out ampersands right before non-whitespace characters, i.e.
            // those used to determine the alt key shortcut
            text: control.text.replace(/&(?=\S)/g, "")
            // Using Wrap instead of WordWrap to prevent tooltips with long URLs
            // from overflowing
            wrapMode: Text.Wrap
            font: control.font
            color: Kirigami.Theme.textColor

            Kirigami.Theme.colorSet: Kirigami.Theme.Tooltip
            Layout.fillWidth: true
            // This value is basically arbitrary. It just looks nice.
            Layout.maximumWidth: Kirigami.Units.gridUnit * 14
        }
    }

    // TODO: Consider replacing this with a StyleItem
    background: Kirigami.ShadowedRectangle {
        radius: 3
        color: Kirigami.Theme.backgroundColor
        Kirigami.Theme.colorSet: Kirigami.Theme.Tooltip

        // Roughly but doesn't exactly match the medium shadow setting for Breeze menus/tooltips.
        // TODO: Find a way to more closely match the user's Breeze settings.
        shadow.xOffset: 0
        shadow.yOffset: 4
        shadow.size: 16
        shadow.color: Qt.rgba(0, 0, 0, 0.2)

        border.width: 1
        // TODO: Replace this with a frame or separator color role if that becomes a thing.
        // Matches the color used by Breeze::Style::drawPanelTipLabelPrimitive()
        border.color: Kirigami.ColorUtils.linearInterpolation(background.color, Kirigami.Theme.textColor, 0.25)
    }
}
