/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQuick 2.6
import QtQuick.Window 2.1
import QtQuick.Templates @QQC2_VERSION@ as T
import org.kde.kirigami 2.4 as Kirigami
import org.kde.qqc2desktopstyle.private 1.0 as StylePrivate

T.SpinBox {
    id: controlRoot
    Kirigami.Theme.colorSet: Kirigami.Theme.View
    Kirigami.Theme.inherit: false

    implicitWidth: Math.max(styleitem.fullRect.width, 48, contentItem.implicitWidth + 2 * padding + up.indicator.implicitWidth + down.indicator.implicitWidth)
    implicitHeight: Math.max(background.implicitHeight, contentItem.implicitHeight + topPadding + bottomPadding)

    padding: 6
    leftPadding: controlRoot.mirrored ? ___rPadding : ___lPadding
    rightPadding: controlRoot.mirrored ? ___lPadding : ___rPadding

    readonly property int ___lPadding: styleitem.upRect.x === styleitem.downRect.x ? horizontalPadding : styleitem.upRect.width
    readonly property int ___rPadding: styleitem.upRect.x === styleitem.downRect.x ? styleitem.upRect.width : styleitem.downRect.width


    hoverEnabled: true
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

        MouseArea {
            anchors.fill: parent
            onPressed: mouse.accepted = false;

            property int wheelDelta: 0

            onExited: wheelDelta = 0
            onWheel: {
                wheelDelta += wheel.angleDelta.y;
                // magic number 120 for common "one click"
                // See: http://qt-project.org/doc/qt-5/qml-qtquick-wheelevent.html#angleDelta-prop
                while (wheelDelta >= 120) {
                    wheelDelta -= 120;
                    controlRoot.increase();
                    controlRoot.valueModified();
                }
                while (wheelDelta <= -120) {
                    wheelDelta += 120;
                    controlRoot.decrease();
                    controlRoot.valueModified();
                }
            }

            // Normally the TextInput does this automatically, but the MouseArea on
            // top of it blocks that behavior, so we need to explicitly do it here
            cursorShape: Qt.IBeamCursor
        }
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

        property rect upRect: styleitem.subControlRect("up")
        property rect downRect: styleitem.subControlRect("down")
        property rect editRect: styleitem.subControlRect("edit")
        property rect fullRect: styleitem.computeBoundingRect([upRect, downRect, editRect])
        property size theSize: styleitem.sizeFromContents(editRect.width, editRect.height)

        function recompute() {
            upRect = styleitem.subControlRect("up")
            downRect = styleitem.subControlRect("down")
            editRect = styleitem.subControlRect("edit")
            fullRect = styleitem.computeBoundingRect([upRect, downRect, editRect])
            theSize = styleitem.sizeFromContents(editRect.width, editRect.height)
        }

        onWidthChanged: recompute()
        onHeightChanged: recompute()

        value: (controlRoot.up.pressed ? 1 : 0) |
                   (controlRoot.down.pressed ? 1<<1 : 0) |
                   ( controlRoot.value != controlRoot.to ? (1<<2) : 0) |
                   (controlRoot.value != controlRoot.from ? (1<<3) : 0) |
                   (controlRoot.up.hovered ? 0x1 : 0) |
                   (controlRoot.down.hovered ? (1<<1) : 0)
    }
}
