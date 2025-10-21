/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.
    SPDX-FileCopyrightText: 2023 ivan tkachenko <me@ratijas.tk>
    SPDX-FileCopyrightText: 2025 Nate Graham <nate@kde.org>

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

    spacing: Kirigami.Units.smallSpacing
    padding: Kirigami.Settings.tabletMode ? Kirigami.Units.largeSpacing : Kirigami.Units.mediumSpacing
    leftPadding: !mirrored ? horizontalPadding + (controlRoot.display === T.AbstractButton.TextUnderIcon ? 0 : implicitIndicatorWidth) + spacing : horizontalPadding
    rightPadding: mirrored ? horizontalPadding + (controlRoot.display === T.AbstractButton.TextUnderIcon ? 0 : implicitIndicatorWidth) + spacing : horizontalPadding
    // Provides padding around the background hover/highlight effect
    leftInset: TableView.view ? 0 : Math.ceil(horizontalPadding / 2)
    rightInset: TableView.view ? 0 : Math.ceil(horizontalPadding / 2)
    topInset: TableView.view ? 0 : Math.ceil(verticalPadding / 2)
    bottomInset: TableView.view ? 0 : Math.ceil(verticalPadding / 2)

    readonly property int __iconSize: controlRoot.display === T.AbstractButton.TextUnderIcon ? Kirigami.Units.iconSizes.medium : Kirigami.Units.iconSizes.smallMedium
    icon.width: __iconSize
    icon.height:__iconSize

    T.ToolTip.visible: (Kirigami.Settings.tabletMode ? down : hovered) && (contentItem.truncated ?? false)
    T.ToolTip.text: action instanceof Kirigami.Action ? action.tooltip : text
    T.ToolTip.delay: Kirigami.Settings.tabletMode ? Qt.styleHints.mousePressAndHoldInterval : Kirigami.Units.toolTipDelay


    contentItem: GridLayout {
        LayoutMirroring.enabled: controlRoot.mirrored
        rows: controlRoot.display === T.AbstractButton.TextUnderIcon ? 2 : 1
        columns: controlRoot.display === T.AbstractButton.TextBesideIcon ? 2 : 1
        rowSpacing: controlRoot.spacing
        columnSpacing: controlRoot.spacing

        property alias truncated: textLabel.truncated

        Kirigami.Icon {
            selected: controlRoot.highlighted || controlRoot.down
            Layout.preferredHeight: controlRoot.icon.height
            Layout.preferredWidth: controlRoot.icon.width
            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
            visible: controlRoot.display !== T.AbstractButton.TextOnly
                && (controlRoot.icon.name.length > 0 || controlRoot.icon.source.toString().length > 0)
            source: controlRoot.icon.name.length > 0 ? controlRoot.icon.name : controlRoot.icon.source
        }

        Label {
            id: textLabel

            Layout.fillWidth: true
            Layout.fillHeight: true

            text: controlRoot.text
            font: controlRoot.font
            color: controlRoot.highlighted || controlRoot.down
                ? Kirigami.Theme.highlightedTextColor
                : (controlRoot.enabled ? Kirigami.Theme.textColor : Kirigami.Theme.disabledTextColor)

            elide: Text.ElideRight
            visible: controlRoot.display !== T.AbstractButton.IconOnly && controlRoot.text
            wrapMode: controlRoot.display === T.AbstractButton.TextUnderIcon ? Text.Wrap : Text.NoWrap
            horizontalAlignment: controlRoot.display === T.AbstractButton.TextUnderIcon ? Text.AlignHCenter : Text.AlignLeft
            verticalAlignment: controlRoot.display === T.AbstractButton.TextUnderIcon ? Text.AlignTop : Text.AlignVCenter
        }
    }

    background: Private.DefaultListItemBackground {
        // This is intentional and ensures the inset is not directly applied to
        // the background, allowing it to determine how to handle the inset.
        anchors.fill: parent
        control: controlRoot
    }
}
