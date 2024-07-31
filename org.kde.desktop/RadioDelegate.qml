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

T.RadioDelegate {
    id: controlRoot

    // Use ListView/GridView attached property of the item delegate directly or in
    // the case of draggable item delegate, take the one from the parent.
    readonly property var _listView: ListView ? ListView : parent.ListView
    readonly property var _gridView: GridView ? GridView : parent.GridView

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding,
                             implicitIndicatorHeight + topPadding + bottomPadding,
                             Kirigami.Units.gridUnit * 2)

    hoverEnabled: true

    spacing: Kirigami.Units.smallSpacing
    padding: Kirigami.Settings.tabletMode ? Kirigami.Units.largeSpacing : Kirigami.Units.mediumSpacing
    horizontalPadding: Kirigami.Units.smallSpacing * 2
    leftPadding: !mirrored ? horizontalPadding + implicitIndicatorWidth + spacing : horizontalPadding
    rightPadding: mirrored ? horizontalPadding + implicitIndicatorWidth + spacing : horizontalPadding

    icon.width: Kirigami.Units.iconSizes.smallMedium
    icon.height: Kirigami.Units.iconSizes.smallMedium

    T.ToolTip.visible: (Kirigami.Settings.tabletMode ? down : hovered) && (contentItem.truncated ?? false)
    T.ToolTip.text: text
    T.ToolTip.delay: Kirigami.Units.toolTipDelay

    topInset: if (TableView.view || Kirigami.Theme.useAlternateBackgroundColor) {
        return 0;
    } else if (controlRoot.index !== undefined && index === 0) {
        return Kirigami.Units.smallSpacing;
    } else {
        return Math.round(Kirigami.Units.smallSpacing / 2);
    }
    bottomInset: if (TableView.view || Kirigami.Theme.useAlternateBackgroundColor) {
        return 0;
    } else if (controlRoot.index !== undefined && _listView.view && index === _listView.view.count - 1) {
        return Kirigami.Units.smallSpacing;
    } else {
        return Math.round(Kirigami.Units.smallSpacing / 2);
    }
    rightInset: Kirigami.Theme.useAlternateBackgroundColor || TableView.view ? 0 : Kirigami.Units.smallSpacing
    leftInset: Kirigami.Theme.useAlternateBackgroundColor || TableView.view ? 0 : Kirigami.Units.smallSpacing

    highlighted: _listView.isCurrentItem || _gridView.isCurrentItem

    contentItem: RowLayout {
        LayoutMirroring.enabled: controlRoot.mirrored
        spacing: controlRoot.spacing

        property alias truncated: textLabel.truncated

        Kirigami.Icon {
            Layout.alignment: Qt.AlignVCenter
            visible: controlRoot.icon.name !== "" || controlRoot.icon.source.toString() !== ""
            source: controlRoot.icon.name !== "" ? controlRoot.icon.name : controlRoot.icon.source
            Layout.preferredHeight: controlRoot.icon.height
            Layout.preferredWidth: controlRoot.icon.width
        }

        Label {
            id: textLabel

            Layout.alignment: Qt.AlignLeft
            Layout.fillWidth: true

            text: controlRoot.text
            font: controlRoot.font
            elide: Text.ElideRight
            visible: controlRoot.text
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
        }
    }

    indicator: Private.CheckIndicator {
        elementType: "radiobutton"
        x: !controlRoot.mirrored ? controlRoot.horizontalPadding : controlRoot.width - width - controlRoot.horizontalPadding
        y: controlRoot.topPadding + (controlRoot.availableHeight - height) / 2
        control: controlRoot
        drawIcon: false
    }

    background: Private.DefaultListItemBackground {
        control: controlRoot
    }
}
