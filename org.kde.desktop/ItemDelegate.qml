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
    id: controlRoot

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding,
                             implicitIndicatorHeight + topPadding + bottomPadding)

    hoverEnabled: true

    padding: Kirigami.Settings.tabletMode ? Kirigami.Units.largeSpacing : Kirigami.Units.smallSpacing
    horizontalPadding: padding * 2
    spacing: Kirigami.Units.smallSpacing

    contentItem: RowLayout {
        LayoutMirroring.enabled: controlRoot.mirrored
        spacing: controlRoot.spacing

        Kirigami.Icon {
            Layout.alignment: Qt.AlignVCenter
            visible: controlRoot.icon.name !== "" || controlRoot.icon.source.toString() !== ""
            source: controlRoot.icon.name !== "" ? controlRoot.icon.name : controlRoot.icon.source
            Layout.preferredHeight: Kirigami.Units.iconSizes.small
            Layout.preferredWidth: Layout.preferredHeight
        }

        Label {
            text: controlRoot.text
            font: controlRoot.font
            color: controlRoot.highlighted || controlRoot.checked || (controlRoot.pressed && !controlRoot.checked && !controlRoot.sectionDelegate)
                ? Kirigami.Theme.highlightedTextColor
                : (controlRoot.enabled ? Kirigami.Theme.textColor : Kirigami.Theme.disabledTextColor)
            elide: Text.ElideRight
            visible: controlRoot.text
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            Layout.alignment: Qt.AlignLeft
            Layout.fillWidth: true
        }

        Item {
            visible: controlRoot.indicator !== null

            Layout.preferredWidth: controlRoot.indicator?.width ?? 0
        }
    }

    background: Private.DefaultListItemBackground {
        control: controlRoot
    }
}
