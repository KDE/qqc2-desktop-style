/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.
    SPDX-FileCopyrightText: 2023 ivan tkachenko <me@ratijas.tk>

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQuick 2.5
import QtQuick.Templates 2.15 as T
import org.kde.kirigami 2.4 as Kirigami
import "private"

T.CheckDelegate {
    id: controlRoot

    implicitWidth: contentItem.implicitWidth + leftPadding + rightPadding
    implicitHeight: Math.max(contentItem.implicitHeight,
                                      indicator ? indicator.implicitHeight : 0) + topPadding + bottomPadding

    spacing: indicator && typeof indicator.pixelMetric === "function" ? indicator.pixelMetric("checkboxlabelspacing") : Kirigami.Units.smallSpacing

    hoverEnabled: true

    padding: Kirigami.Settings.tabletMode ? Kirigami.Units.largeSpacing : Kirigami.Units.smallSpacing

    topPadding: padding
    leftPadding: padding * 2
    rightPadding: padding * 2
    bottomPadding: padding

    contentItem: Label {
        readonly property int indicatorEffectiveWidth: (
                controlRoot.indicator
                && typeof controlRoot.indicator.pixelMetric === "function"
                && controlRoot.icon.name === ""
                && controlRoot.icon.source.toString() === ""
            ) ? controlRoot.indicator.pixelMetric("indicatorwidth") + controlRoot.spacing
              : controlRoot.indicator.width

        leftPadding: controlRoot.indicator && !controlRoot.mirrored ? indicatorEffectiveWidth : 0
        rightPadding: controlRoot.indicator && controlRoot.mirrored ? indicatorEffectiveWidth : 0

        text: controlRoot.text
        font: controlRoot.font
        color: (((controlRoot.pressed && !controlRoot.checked) || controlRoot.highlighted) && !controlRoot.sectionDelegate) ? Kirigami.Theme.highlightedTextColor : Kirigami.Theme.textColor
        elide: Text.ElideRight
        visible: controlRoot.text
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
    }

    indicator: CheckIndicator {
        x: controlRoot.mirrored ? controlRoot.width - width - controlRoot.rightPadding : controlRoot.leftPadding
        y: controlRoot.topPadding + (controlRoot.availableHeight - height) / 2

        control: controlRoot
    }

    background: DefaultListItemBackground {
        control: controlRoot
    }
}
