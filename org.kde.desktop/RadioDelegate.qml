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

    implicitWidth: contentItem.implicitWidth + leftPadding + rightPadding
    implicitHeight: Math.max(contentItem.implicitHeight,
                             indicator ? indicator.implicitHeight : 0) + topPadding + bottomPadding
    hoverEnabled: true

    spacing: Kirigami.Units.smallSpacing
    padding: Kirigami.Settings.tabletMode ? Kirigami.Units.largeSpacing : Kirigami.Units.smallSpacing
    horizontalPadding: padding * 2
    leftPadding: !mirrored ? horizontalPadding + implicitIndicatorWidth + spacing : horizontalPadding
    rightPadding: mirrored ? horizontalPadding + implicitIndicatorWidth + spacing : horizontalPadding

    icon.width: Kirigami.Units.iconSizes.smallMedium
    icon.height: Kirigami.Units.iconSizes.smallMedium

    contentItem: RowLayout {
        LayoutMirroring.enabled: controlRoot.mirrored
        spacing: controlRoot.spacing

        Kirigami.Icon {
            Layout.alignment: Qt.AlignVCenter
            visible: controlRoot.icon.name !== "" || controlRoot.icon.source.toString() !== ""
            source: controlRoot.icon.name !== "" ? controlRoot.icon.name : controlRoot.icon.source
            Layout.preferredHeight: controlRoot.icon.height
            Layout.preferredWidth: controlRoot.icon.width
        }

        Label {
            text: controlRoot.text
            font: controlRoot.font
            color: (controlRoot.pressed && !controlRoot.checked && !controlRoot.sectionDelegate) ? Kirigami.Theme.highlightedTextColor : Kirigami.Theme.textColor
            elide: Text.ElideRight
            visible: controlRoot.text
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
        }
    }

    indicator: CheckIndicator {
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
