/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.
    SPDX-FileCopyrightText: 2023 ivan tkachenko <me@ratijas.tk>

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQuick
import QtQuick.Templates as T
import org.kde.kirigami as Kirigami
import org.kde.desktop.private as Private

T.RadioDelegate {
    id: controlRoot

    implicitWidth: contentItem.implicitWidth + leftPadding + rightPadding
    implicitHeight: Math.max(contentItem.implicitHeight,
                             indicator ? indicator.implicitHeight : 0) + topPadding + bottomPadding
    hoverEnabled: true

    padding: Kirigami.Settings.tabletMode ? Kirigami.Units.largeSpacing : Kirigami.Units.smallSpacing
    horizontalPadding: padding * 2

    contentItem: Label {
        readonly property int indicatorEffectiveWidth: (
                controlRoot.indicator
                && typeof controlRoot.indicator.pixelMetric === "function"
                && controlRoot.icon.name === ""
                && controlRoot.icon.source.toString() === ""
            ) ? controlRoot.indicator.pixelMetric("exclusiveindicatorwidth") + controlRoot.spacing
              : controlRoot.indicator.width

        leftPadding: controlRoot.indicator && !controlRoot.mirrored ? indicatorEffectiveWidth : 0
        rightPadding: controlRoot.indicator && controlRoot.mirrored ? indicatorEffectiveWidth : 0

        text: controlRoot.text
        font: controlRoot.font
        color: (controlRoot.pressed && !controlRoot.checked && !controlRoot.sectionDelegate) ? Kirigami.Theme.highlightedTextColor : Kirigami.Theme.textColor
        elide: Text.ElideRight
        visible: controlRoot.text
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
    }

    indicator: CheckIndicator {
        elementType: "radiobutton"
        x: controlRoot.mirrored ? controlRoot.leftPadding : controlRoot.width - width - controlRoot.rightPadding
        y: controlRoot.topPadding + (controlRoot.availableHeight - height) / 2

        control: controlRoot
    }

    background: Private.DefaultListItemBackground {
        control: controlRoot
    }
}
