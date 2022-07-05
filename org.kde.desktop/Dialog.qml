/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQuick 2.6
import QtQuick.Templates 2.15 as T
import org.kde.kirigami 2.12 as Kirigami

T.Dialog {
    id: control

    implicitWidth: Math.max(background ? background.implicitWidth : 0,
                            contentWidth > 0 ? contentWidth + leftPadding + rightPadding : 0)
    implicitHeight: Math.max(background ? background.implicitHeight : 0,
                             contentWidth > 0 ? contentHeight + topPadding + bottomPadding : 0)

    contentWidth: contentItem.implicitWidth || (contentChildren.length === 1 ? contentChildren[0].implicitWidth : 0)
    contentHeight: (contentItem.implicitHeight || (contentChildren.length === 1 ? contentChildren[0].implicitHeight : 0)) + header.implicitHeight + footer.implicitHeight

    padding: Kirigami.Units.gridUnit

    enter: Transition {
        NumberAnimation {
            property: "opacity"
            from: 0
            to: 1
            easing.type: Easing.InOutQuad
            duration: Kirigami.Units.longDuration
        }
    }

    exit: Transition {
        NumberAnimation {
            property: "opacity"
            from: 1
            to: 0
            easing.type: Easing.InOutQuad
            duration: Kirigami.Units.longDuration
        }
    }

    contentItem: Item {}

    background: Kirigami.ShadowedRectangle {
        radius: 2
        color: Kirigami.Theme.backgroundColor
        property color borderColor: Kirigami.Theme.textColor
        border.color: Qt.rgba(borderColor.r, borderColor.g, borderColor.b, 0.3)
        border.width: 1

        shadow.xOffset: 0
        shadow.yOffset: 4
        shadow.color: Qt.rgba(0, 0, 0, 0.3)
        shadow.size: 16
    }

    header: Kirigami.Heading {
        text: control.title
        level: 2
        visible: control.title
        elide: Label.ElideRight
        padding: Kirigami.Units.gridUnit
        bottomPadding: 0
    }

    footer: DialogButtonBox {
        visible: count > 0
    }
}
