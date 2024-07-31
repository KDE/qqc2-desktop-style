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

    // Use ListView/GridView attached property of the item delegate directly or in
    // the case of draggable item delegate, take the one from the parent.
    property var _listView: ListView ? ListView : parent.ListView

    property var _gridView: GridView ? GridView : parent.GridView

    readonly property bool _useAlternatingColors: {
        if (TableView.view?.alternatingRows && row % 2) {
            return true;
        } else if (Kirigami.Theme.useAlternateBackgroundColor && index % 2) {
            return true;
        }
        return false
    }

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding,
                             implicitIndicatorHeight + topPadding + bottomPadding,
                             Kirigami.Units.gridUnit * 2)

    hoverEnabled: true

    padding: Kirigami.Units.mediumSpacing

    horizontalPadding: padding + (TableView.view ? 0 : Math.round(Kirigami.Units.smallSpacing / 2))
    leftPadding: horizontalPadding
    rightPadding: horizontalPadding

    verticalPadding: padding
    topPadding: verticalPadding
    bottomPadding: verticalPadding

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
    rightInset: if (Kirigami.Theme.useAlternateBackgroundColor || TableView.view) {
        return 0;
    } else {
        console.log("hasInset")
        return Kirigami.Units.smallSpacing;
    }
    leftInset: Kirigami.Theme.useAlternateBackgroundColor || TableView.view ? 0 : Kirigami.Units.smallSpacing

    icon.width: Kirigami.Units.iconSizes.smallMedium
    icon.height: Kirigami.Units.iconSizes.smallMedium

    T.ToolTip.visible: (Kirigami.Settings.tabletMode ? down : hovered) && (contentItem.truncated ?? false)
    T.ToolTip.text: text
    T.ToolTip.delay: Kirigami.Units.toolTipDelay

    highlighted: _listView.isCurrentItem || _gridView.isCurrentItem

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
        control: controlRoot
    }
}
