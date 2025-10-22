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

    spacing: Kirigami.Units.smallSpacing

    // HACK: We want equal padding around the top, left, and right edges of the first item, but
    // we don't want this to cause unnecessary extra padding *between* list items. The best way
    // to accomplish that would be with https://bugreports.qt.io/browse/QTBUG-127729, but that
    // hasn't been implemented yet.
    //
    // Thus, this hack: we make all the items have a little bit of extra padding on top, and an
    // equal amount less on the bottom. This produces the desired visual result, with the only
    // side effect being click targets shifted up by 2 pixels from what you might expect.
    readonly property int __edgePadding: Kirigami.Units.largeSpacing
    topPadding: __edgePadding
    leftPadding: !mirrored ? __edgePadding + (indicator ? (controlRoot.display === T.AbstractButton.TextUnderIcon ? 0 : implicitIndicatorWidth) + spacing : 0) : __edgePadding
    rightPadding: mirrored ? __edgePadding + (indicator ? (controlRoot.display === T.AbstractButton.TextUnderIcon ? 0 : implicitIndicatorWidth) + spacing : 0) : __edgePadding
    bottomPadding: __edgePadding - __edgeInset

    readonly property int __edgeInset: Kirigami.Units.smallSpacing
    topInset: TableView.view ? 0 : __edgeInset
    leftInset: TableView.view ? 0 : __edgeInset
    rightInset: TableView.view ? 0 : __edgeInset
    bottomInset: 0

    readonly property int __iconSize: controlRoot.display === T.AbstractButton.TextUnderIcon ? Kirigami.Units.iconSizes.medium : Kirigami.Units.iconSizes.smallMedium
    icon.width: __iconSize
    icon.height:__iconSize

    T.ToolTip.visible: (Kirigami.Settings.tabletMode ? down : hovered) && (contentItem.truncated ?? false)
    T.ToolTip.text: action instanceof Kirigami.Action ? action.tooltip : text
    T.ToolTip.delay: Kirigami.Settings.tabletMode ? Qt.styleHints.mousePressAndHoldInterval : Kirigami.Units.toolTipDelay

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

    background: Private.DefaultListItemBackground {
        // This is intentional and ensures the inset is not directly applied to
        // the background, allowing it to determine how to handle the inset.
        // left and right anchors would break SwipeDelegate
        anchors {
            top: parent.top
            bottom:parent.bottom
        }
        control: controlRoot
    }
}
