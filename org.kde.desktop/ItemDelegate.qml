/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQuick 2.5
import QtQuick.Templates @QQC2_VERSION@ as T
import org.kde.kirigami 2.4 as Kirigami
import "private"

T.ItemDelegate {
    id: controlRoot

    implicitWidth: contentItem.implicitWidth + leftPadding + rightPadding
    implicitHeight: Math.max(contentItem.implicitHeight,
                                      indicator ? indicator.implicitHeight : 0) + topPadding + bottomPadding
    hoverEnabled: true

    padding: Kirigami.Settings.tabletMode ? Kirigami.Units.largeSpacing : Kirigami.Units.smallSpacing

    leftPadding: padding*2
    topPadding: padding

    rightPadding: padding*2
    bottomPadding: padding

    contentItem: Label {
        leftPadding: controlRoot.mirrored ? (controlRoot.indicator ? controlRoot.indicator.width : 0) + controlRoot.spacing : 0
        rightPadding: !controlRoot.mirrored ? (controlRoot.indicator ? controlRoot.indicator.width : 0) + controlRoot.spacing : 0

        text: controlRoot.text
        font: controlRoot.font
        color: controlRoot.highlighted || controlRoot.checked || (controlRoot.pressed && !controlRoot.checked && !controlRoot.sectionDelegate) ? Kirigami.Theme.highlightedTextColor : (controlRoot.enabled ? Kirigami.Theme.textColor : Kirigami.Theme.disabledTextColor)
        elide: Text.ElideRight
        visible: controlRoot.text
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
    }

    background: DefaultListItemBackground {}
}
