/*
 * Copyright 2017 Marco Martin <mart@kde.org>
 * Copyright 2017 The Qt Company Ltd.
 *
 * GNU Lesser General Public License Usage
 * Alternatively, this file may be used under the terms of the GNU Lesser
 * General Public License version 3 as published by the Free Software
 * Foundation and appearing in the file LICENSE.LGPLv3 included in the
 * packaging of this file. Please review the following information to
 * ensure the GNU Lesser General Public License version 3 requirements
 * will be met: https://www.gnu.org/licenses/lgpl.html.
 *
 * GNU General Public License Usage
 * Alternatively, this file may be used under the terms of the GNU
 * General Public License version 2.0 or later as published by the Free
 * Software Foundation and appearing in the file LICENSE.GPL included in
 * the packaging of this file. Please review the following information to
 * ensure the GNU General Public License version 2.0 requirements will be
 * met: http://www.gnu.org/licenses/gpl-2.0.html.
 */


import QtQuick 2.6
import QtQuick.Templates @QQC2_VERSION@ as T
import org.kde.kirigami 2.4 as Kirigami
import org.kde.qqc2desktopstyle.private 1.0 as StylePrivate

T.SpinBox {
    id: controlRoot
    @DISABLE_UNDER_QQC2_2_4@ palette: Kirigami.Theme.palette
    Kirigami.Theme.colorSet: Kirigami.Theme.View
    Kirigami.Theme.inherit: false

    implicitWidth: Math.max(48, contentItem.implicitWidth + 2 * padding +  up.indicator.implicitWidth)
    implicitHeight: Math.max(background.implicitHeight, contentItem.implicitHeight + topPadding + bottomPadding)

    padding: 6
    leftPadding: padding + (controlRoot.mirrored ? (up.indicator ? up.indicator.width : 0) : 0)
    rightPadding: padding + (controlRoot.mirrored ? 0 : (up.indicator ? up.indicator.width : 0))


    hoverEnabled: true

    validator: IntValidator {
        locale: controlRoot.locale.name
        bottom: Math.min(controlRoot.from, controlRoot.to)
        top: Math.max(controlRoot.from, controlRoot.to)
    }

    contentItem: TextInput {
        z: 2
        text: controlRoot.textFromValue(controlRoot.value, controlRoot.locale)
        opacity: controlRoot.enabled ? 1 : 0.3

        font: controlRoot.font
        color: Kirigami.Theme.textColor
        selectionColor: Kirigami.Theme.highlightColor
        selectedTextColor: Kirigami.Theme.highlightedTextColor
        horizontalAlignment: Qt.AlignHCenter
        verticalAlignment: Qt.AlignVCenter

        readOnly: !controlRoot.editable
        validator: controlRoot.validator
        inputMethodHints: Qt.ImhFormattedNumbersOnly

        MouseArea {
            anchors.fill: parent
            onPressed: mouse.accepted = false;
            onWheel: {
                if (wheel.pixelDelta.y < 0 || wheel.angleDelta.y < 0) {
                    controlRoot.decrease();
                } else {
                    controlRoot.increase();
                }
            }
            // Normally the TextInput does this automatically, but the MouseArea on
            // top of it blocks that behavior, so we need to explicitly do it here
            cursorShape: Qt.IBeamCursor
        }
    }

    up.indicator: Item {
        implicitWidth: parent.height/2
        implicitHeight: implicitWidth
        x: controlRoot.mirrored ? 0 : parent.width - width
    }
    down.indicator: Item {
        implicitWidth: parent.height/2
        implicitHeight: implicitWidth
 
        x: controlRoot.mirrored ? 0 : parent.width - width
        y: parent.height - height
    }


    background: StylePrivate.StyleItem {
        id: styleitem
        control: controlRoot
        elementType: "spinbox"
        anchors.fill: parent
        hover: controlRoot.hovered
        hasFocus: controlRoot.activeFocus
        enabled: controlRoot.enabled

        value: (controlRoot.up.pressed ? 1 : 0) |
                   (controlRoot.down.pressed ? 1<<1 : 0) |
                   ( controlRoot.value != controlRoot.to ? (1<<2) : 0) |
                   (controlRoot.value != controlRoot.from ? (1<<3) : 0) |
                   (controlRoot.up.hovered ? 0x1 : 0) |
                   (controlRoot.down.hovered ? (1<<1) : 0)
    }
}
