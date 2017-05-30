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
import QtQuick.Templates 2.0 as T
import org.kde.qqc2desktopstyle.private 1.0 as StylePrivate

T.SpinBox {
    id: control

    implicitWidth: Math.max(48, contentItem.implicitWidth + 2 * padding +  up.indicator.implicitWidth)
    implicitHeight: contentItem.implicitHeight + topPadding + bottomPadding

    padding: 6
    leftPadding: padding + (control.mirrored ? (up.indicator ? up.indicator.width : 0) : 0)
    rightPadding: padding + (control.mirrored ? 0 : (up.indicator ? up.indicator.width : 0))


    validator: IntValidator {
        locale: control.locale.name
        bottom: Math.min(control.from, control.to)
        top: Math.max(control.from, control.to)
    }

    contentItem: TextInput {
        z: 2
        text: control.textFromValue(control.value, control.locale)
        opacity: control.enabled ? 1 : 0.3

        font: control.font
        color: StylePrivate.SystemPaletteSingleton.text(control.enabled)
        selectionColor: StylePrivate.SystemPaletteSingleton.highlight(control.enabled)
        selectedTextColor: StylePrivate.SystemPaletteSingleton.highlightedText(control.enabled)
        horizontalAlignment: Qt.AlignHCenter
        verticalAlignment: Qt.AlignVCenter

        readOnly: !control.editable
        validator: control.validator
        inputMethodHints: Qt.ImhFormattedNumbersOnly
    }

    up.indicator: Item {
        implicitWidth: parent.height/2
        implicitHeight: implicitWidth
        x: control.mirrored ? 0 : parent.width - width
    }
    down.indicator: Item {
        implicitWidth: parent.height/2
        implicitHeight: implicitWidth
 
        x: control.mirrored ? 0 : parent.width - width
        y: parent.height - height
    }


    background: StylePrivate.StyleItem {
        id: styleitem
        elementType: "spinbox"
        anchors.fill: parent
        hover: control.hovered
        hasFocus: control.activeFocus
        enabled: control.enabled
        value: control.textFromValue(control.value, control.locale)
        border {
            top: 6
            bottom: 6
        }
    }
}
