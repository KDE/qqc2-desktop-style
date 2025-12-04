/*
    SPDX-FileCopyrightText: 2024 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.
    SPDX-FileCopyrightText: 2023 ivan tkachenko <me@ratijas.tk>

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/

import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import org.kde.kirigami as Kirigami
import org.kde.desktop.private as Private

T.SwipeDelegate {
    id: controlRoot

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding,
                             implicitIndicatorHeight + topPadding + bottomPadding)

    spacing: Kirigami.Units.mediumSpacing
    padding: Kirigami.Units.mediumSpacing + Kirigami.Units.smallSpacing
    // We want an uniform space between the items, including the first.
    // the delegate will have a space only on top, in the form of a big top padding,
    // while the bottom one will have a tiny padding and no inset as the spacing between items
    // will be done by the top inset of the next item
    bottomPadding: Kirigami.Units.smallSpacing
    leftPadding: !mirrored ? horizontalPadding + (indicator ? (controlRoot.display === T.AbstractButton.TextUnderIcon ? 0 : implicitIndicatorWidth) + spacing : 0) : horizontalPadding
    rightPadding: mirrored ? horizontalPadding + (indicator ? (controlRoot.display === T.AbstractButton.TextUnderIcon ? 0 : implicitIndicatorWidth) + spacing : 0) : horizontalPadding

    icon.width: Kirigami.Units.iconSizes.smallMedium
    icon.height: Kirigami.Units.iconSizes.smallMedium

    T.ToolTip.visible: (Kirigami.Settings.tabletMode ? down : hovered) && (contentItem.truncated ?? false)
    T.ToolTip.text: action instanceof Kirigami.Action ? action.tooltip : text
    T.ToolTip.delay: Kirigami.Settings.tabletMode ? Qt.styleHints.mousePressAndHoldInterval : Kirigami.Units.toolTipDelay

    // inset is padding minus a small spacing
    leftInset: TableView.view ? 0 : Math.max(0, leftPadding - Kirigami.Units.smallSpacing)
    rightInset: TableView.view ? 0 : Math.max(0, rightPadding - Kirigami.Units.smallSpacing)
    topInset: TableView.view ? 0 : Math.max(0, topPadding - Kirigami.Units.smallSpacing)
    bottomInset: TableView.view ? 0 : Math.max(0, bottomPadding - Kirigami.Units.smallSpacing)

    // This kind of long animation is one we don't want a duration, but a velocity otherwise
    // a close animation from the edge is too fast, while if it just has to cover few pixels, is too slow
    swipe.transition: Transition {
        SmoothedAnimation {
            // is about 3 on default duration
            velocity: Kirigami.Units.longDuration / 80
            easing.type: Easing.InOutCubic
        }
    }

    contentItem: RowLayout {
        LayoutMirroring.enabled: controlRoot.mirrored
        spacing: controlRoot.spacing

        property alias truncated: textLabel.truncated

        Kirigami.Icon {
            selected: controlRoot.highlighted || controlRoot.down
            Layout.alignment: Qt.AlignVCenter
            visible: controlRoot.icon.name.length > 0 || controlRoot.icon.source.toString().length > 0
            source: controlRoot.icon.name.length > 0 ? controlRoot.icon.name : controlRoot.icon.source
            Layout.preferredHeight: controlRoot.icon.height
            Layout.preferredWidth: controlRoot.icon.width
        }

        Label {
            id: textLabel

            Layout.alignment: Qt.AlignLeft
            Layout.fillWidth: true

            text: controlRoot.text
            font: controlRoot.font
            color: controlRoot.highlighted || controlRoot.down
                ? Kirigami.Theme.highlightedTextColor
                : (controlRoot.enabled ? Kirigami.Theme.textColor : Kirigami.Theme.disabledTextColor)

            elide: Text.ElideRight
            visible: controlRoot.text
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
        }
    }

    background: Item {
        // SwipeDelegate doesn't apply correctly left/right insets so apply them manually
        Private.DefaultListItemBackground {
            visible: swipe.position === 0
            anchors {
                left: parent.left
                top: parent.top
                bottom: parent.bottom
                leftMargin: controlRoot.leftInset
            }
            width: controlRoot.width - controlRoot.leftInset - controlRoot.rightInset
            control: controlRoot
        }
    }
}
