/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQuick
import QtQuick.Controls as Controls
import QtQuick.Templates as T
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

    visible: parent && text.length > 0 && (Kirigami.Settings.tabletMode ? parent.pressed : (parent.hasOwnProperty("hovered") ? parent.hovered : parent.hasOwnProperty("containsMouse") && parent.containsMouse))
    delay: Kirigami.Settings.tabletMode ? Qt.styleHints.mousePressAndHoldInterval : Kirigami.Units.toolTipDelay
    // Never time out while being hovered; it's annoying
    timeout: -1

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

    contentItem: Item {
        implicitWidth: Math.min(label.maxTextLength, label.contentWidth)
        implicitHeight: label.implicitHeight

        Controls.Label {
            id: label

            // This value is basically arbitrary. It just looks nice.
            readonly property double maxTextLength: Kirigami.Units.gridUnit * 14

            // Strip out ampersands right before non-whitespace characters, i.e.
            // those used to determine the alt key shortcut
            // (except when the word ends in ; (HTML entities))
            text: control.text.replace(/(&)(?!;)\S+(?>\s)/g, "")
            // Using Wrap instead of WordWrap to prevent tooltips with long URLs
            // from overflowing
            wrapMode: Text.Wrap
            font: control.font
            color: Kirigami.Theme.textColor

            Kirigami.Theme.colorSet: Kirigami.Theme.Tooltip
            // ensure that long text actually gets wrapped
            onLineLaidOut: (line) => {
                if (line.implicitWidth > maxTextLength)
                    line.width = maxTextLength
            }
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
