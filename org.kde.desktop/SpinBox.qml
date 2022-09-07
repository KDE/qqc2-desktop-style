/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Templates 2.15 as T
import org.kde.kirigami 2.20 as Kirigami
import org.kde.qqc2desktopstyle.private 1.0 as StylePrivate

T.SpinBox {
    id: controlRoot
    Kirigami.Theme.colorSet: Kirigami.Theme.View
    Kirigami.Theme.inherit: false

    implicitWidth: Math.max(styleitem.fullRectSizeHint.width, 48, contentItem.implicitWidth + 2 * padding + up.indicator.implicitWidth + down.indicator.implicitWidth)
    implicitHeight: Math.max(styleitem.fullRectSizeHint.height, background.implicitHeight, contentItem.implicitHeight + topPadding + bottomPadding)

    padding: 6
    leftPadding: controlRoot.mirrored ? ___rPadding : ___lPadding
    rightPadding: controlRoot.mirrored ? ___lPadding : ___rPadding

    readonly property int ___lPadding: styleitem.upRectSizeHint.x === styleitem.downRectSizeHint.x ? horizontalPadding : styleitem.upRectSizeHint.width
    readonly property int ___rPadding: styleitem.upRectSizeHint.x === styleitem.downRectSizeHint.x ? styleitem.upRectSizeHint.width : styleitem.downRectSizeHint.width

    hoverEnabled: true
    wheelEnabled: true
    editable: true

    validator: IntValidator {
        locale: controlRoot.locale.name
        bottom: Math.min(controlRoot.from, controlRoot.to)
        top: Math.max(controlRoot.from, controlRoot.to)
    }

    // SpinBox does not update its value during editing, see QTBUG-91281
    Connections {
        target: controlRoot.contentItem
        function onTextEdited() {
            if (controlRoot.contentItem.text) {
                controlRoot.value = controlRoot.valueFromText(controlRoot.contentItem.text, controlRoot.locale)
                controlRoot.valueModified()
            }
        }
    }

    contentItem: TextInput {
        z: 2
        text: controlRoot.textFromValue(controlRoot.value, controlRoot.locale)
        opacity: controlRoot.enabled ? 1 : 0.3

        font: controlRoot.font
        color: Kirigami.Theme.textColor
        selectionColor: Kirigami.Theme.highlightColor
        selectedTextColor: Kirigami.Theme.highlightedTextColor
        selectByMouse: true
        horizontalAlignment: Qt.AlignHCenter
        verticalAlignment: Qt.AlignVCenter

        readOnly: !controlRoot.editable
        validator: controlRoot.validator
        inputMethodHints: Qt.ImhFormattedNumbersOnly

        // Work around Qt bug where NativeRendering breaks for non-integer scale factors
        // https://bugreports.qt.io/browse/QTBUG-67007
        renderType: Screen.devicePixelRatio % 1 !== 0 ? Text.QtRendering : Text.NativeRendering
    }

    up.indicator: Item {
        implicitWidth: styleitem.upRect.width
        implicitHeight: styleitem.upRect.height

        x: styleitem.upRect.x
        y: styleitem.upRect.y
    }
    down.indicator: Item {
        implicitWidth: styleitem.downRect.width
        implicitHeight: styleitem.downRect.height

        x: styleitem.downRect.x
        y: styleitem.downRect.y
    }

    background: StylePrivate.StyleItem {
        id: styleitem
        control: controlRoot
        elementType: "spinbox"
        anchors.fill: parent
        hover: controlRoot.hovered
        hasFocus: controlRoot.activeFocus
        enabled: controlRoot.enabled

        // static hints calculated once for minimum sizes
        property rect upRectSizeHint: styleitem.subControlRect("up")
        property rect downRectSizeHint: styleitem.subControlRect("down")
        property rect editRectSizeHint: styleitem.subControlRect("edit")
        property rect fullRectSizeHint: styleitem.computeBoundingRect([upRectSizeHint, downRectSizeHint, editRectSizeHint])

        // dynamic hints calculated every resize to keep the buttons in place
        property rect upRect: upRectSizeHint
        property rect downRect: downRectSizeHint

        function recompute() {
            upRect = styleitem.subControlRect("up")
            downRect = styleitem.subControlRect("down")
        }

        onWidthChanged: recompute()
        onHeightChanged: recompute()

        value: (controlRoot.up.pressed ? 1 : 0) |
                   (controlRoot.down.pressed ? 1 << 1 : 0) |
                   (controlRoot.value !== controlRoot.to ? (1 << 2) : 0) |
                   (controlRoot.value !== controlRoot.from ? (1 << 3) : 0) |
                   (controlRoot.up.hovered ? 1 : 0) |
                   (controlRoot.down.hovered ? (1 << 1) : 0)
    }
}
