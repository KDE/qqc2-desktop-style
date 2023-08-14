/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.
    SPDX-FileCopyrightText: 2023 ivan tkachenko <me@ratijas.tk>

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/

import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import org.kde.kirigami as Kirigami
import org.kde.desktop.private as Private

T.ItemDelegate {
    id: root

    readonly property int _index: index !== undefined ? index : model.index
    readonly property int _count: ListView.view.count ?? GridView.view.count

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding,
                             implicitIndicatorHeight + topPadding + bottomPadding)

    hoverEnabled: true

    spacing: Kirigami.Units.mediumSpacing
    padding: Kirigami.Units.mediumSpacing
    horizontalPadding: padding + Kirigami.Units.smallSpacing
    leftPadding: !mirrored ? horizontalPadding + (indicator ? implicitIndicatorWidth + spacing : 0) : horizontalPadding
    rightPadding: mirrored ? horizontalPadding + (indicator ? implicitIndicatorWidth + spacing : 0) : horizontalPadding

    verticalPadding: padding
    topPadding: verticalPadding + (_index === 0 ? Math.round(Kirigami.Units.smallSpacing / 2) : 0)
    bottomPadding: verticalPadding + (_index === _count -1 ? Math.round(Kirigami.Units.smallSpacing / 2) : 0)

    topInset: Math.round(Kirigami.Units.smallSpacing / (_index === 0 ? 1 : 2))
    bottomInset: Math.round(Kirigami.Units.smallSpacing / (_index === _count -1 ? 1 : 2))
    rightInset: Kirigami.Units.smallSpacing
    leftInset: Kirigami.Units.smallSpacing

    icon.width: Kirigami.Units.iconSizes.smallMedium
    icon.height: Kirigami.Units.iconSizes.smallMedium

    T.ToolTip.visible: (Kirigami.Settings.tabletMode ? down : hovered) && (contentItem.truncated ?? false)
    T.ToolTip.text: text
    T.ToolTip.delay: Kirigami.Units.toolTipDelay

    contentItem: RowLayout {
        LayoutMirroring.enabled: controlRoot.mirrored
        spacing: controlRoot.spacing

        property alias truncated: textLabel.truncated

        Kirigami.Icon {
            selected: controlRoot.highlighted || controlRoot.down
            Layout.alignment: Qt.AlignVCenter
            visible: root.icon.name !== "" || root.icon.source.toString() !== ""
            source: root.icon.name !== "" ? root.icon.name : root.icon.source
            Layout.preferredHeight: controlRoot.icon.height
            Layout.preferredWidth: controlRoot.icon.width
        }

        Label {
            id: textLabel

            text: root.text
            font: root.font
            color: root.highlighted || root.down
                ? Kirigami.Theme.highlightedTextColor
                : (root.enabled ? Kirigami.Theme.textColor : Kirigami.Theme.disabledTextColor)
            elide: Text.ElideRight
            visible: root.text
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            Layout.alignment: Qt.AlignLeft
            Layout.fillWidth: true
        }
    }

    background: Rectangle {
        radius: Kirigami.Units.smallSpacing

        color: if (root.highlighted || root.checked || (root.down && !root.checked) || root.visualFocus) {
            const highlight = Kirigami.ColorUtils.tintWithAlpha(Kirigami.Theme.backgroundColor, Kirigami.Theme.highlightColor, 0.20);
            if (root.hovered) {
                Kirigami.ColorUtils.tintWithAlpha(highlight, Kirigami.Theme.textColor, 0.10)
            } else {
                highlight
            }
        } else if (root.hovered) {
            Kirigami.ColorUtils.tintWithAlpha(Kirigami.Theme.backgroundColor, Kirigami.Theme.textColor, 0.10)
        } else {
           Kirigami.Theme.backgroundColor
        }

        border {
            color: Kirigami.Theme.highlightColor
            width: root.visualFocus || root.activeFocus ? 1 : 0
        }

        Behavior on color {
            ColorAnimation {
                duration: Kirigami.Units.shortDuration
            }
        }
    }
}
