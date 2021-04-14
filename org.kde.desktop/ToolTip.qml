/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls @QQC2_VERSION@ as Controls
import QtQuick.Templates @QQC2_VERSION@ as T
import org.kde.kirigami 2.12 as Kirigami

T.ToolTip {
    id: controlRoot

    // 180pt | 2.5in | 63.5mm
    // This value is basically arbitrary. It just looks nice.
    property real __preferredWidth: Screen.pixelDensity * 63.5 * Screen.devicePixelRatio

    contentWidth: {
        // Always ceil text widths since they're usually not integers.
        // Using round or floor can cause text to wrap or elide.
        let implicitContentOrFirstChildWidth = Math.ceil(implicitContentWidth || (contentChildren.length === 1 ? contentChildren[0].implicitWidth : 0))

        /* HACK: Adding 1 prevents the right side from sometimes having an
         * unnecessary amount of padding. This could fail to fix the issue
         * in some contexts, but it seems to work with Noto Sans at 10pts,
         * 10.5pts and 11pts.
         */
        // If contentWidthSource isn't available, cWidth = 0
        let cWidth = Math.ceil(contentWidthSource.contentWidth ?? -1) + 1 
        return cWidth > 0 ? cWidth : implicitContentOrFirstChildWidth
    }

    palette: Kirigami.Theme.palette
    Kirigami.Theme.colorSet: Kirigami.Theme.Tooltip
    Kirigami.Theme.inherit: false

    x: parent ? Math.round((parent.width - implicitWidth) / 2) : 0
    y: -implicitHeight - 3

    // Always show the tooltip on top of everything else
    z: 999

    // Math.ceil() prevents blurry edges and prevents unecessary text wrapping
    // (vs using floor or sometimes round).
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             Math.ceil(contentHeight) + topPadding + bottomPadding)

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

        // This code looks ugly, but I can't think of anything less ugly
        // that is just as reliable. TextMetrics doesn't support WordWrap.
        Text {
            id: contentWidthSource
            visible: false
            width: controlRoot.__preferredWidth
            text: parent.text
            font: parent.font
            wrapMode: parent.wrapMode
            renderType: parent.renderType
            horizontalAlignment: parent.horizontalAlignment
            verticalAlignment: parent.verticalAlignment
            elide: parent.elide
            fontSizeMode: parent.fontSizeMode
            lineHeight: parent.lineHeight
            lineHeightMode: parent.lineHeightMode
            // Make the 1st line the longest to make text alignment a bit prettier.
            maximumLineCount: 1
            minimumPixelSize: parent.minimumPixelSize
            minimumPointSize: parent.minimumPointSize
            style: parent.style
            textFormat: parent.textFormat
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
