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
import QtQuick.Window 2.2
import QtQuick.Templates @QQC2_VERSION@ as T
import QtQuick.Controls @QQC2_VERSION@ as Controls
import org.kde.qqc2desktopstyle.private 1.0 as StylePrivate
import QtGraphicalEffects 1.0
import org.kde.kirigami 2.2 as Kirigami

T.ComboBox {
    id: controlRoot
    //NOTE: typeof necessary to not have warnings on Qt 5.7
    Kirigami.Theme.colorSet: typeof(editable) != "undefined" && editable ? Kirigami.Theme.View : Kirigami.Theme.Button
    Kirigami.Theme.inherit: false

    implicitWidth: background.implicitWidth + leftPadding + rightPadding
    implicitHeight: background.implicitHeight
    baselineOffset: contentItem.y + contentItem.baselineOffset

    hoverEnabled: true
    padding: 5
    leftPadding: padding + 5
    rightPadding: padding + 5

    delegate: ItemDelegate {
        width: controlRoot.popup.width
        text: controlRoot.textRole ? (Array.isArray(controlRoot.model) ? modelData[controlRoot.textRole] : model[controlRoot.textRole]) : modelData
        highlighted: controlRoot.highlightedIndex == index
        property bool separatorVisible: false
        Kirigami.Theme.colorSet: controlRoot.Kirigami.Theme.inherit ? controlRoot.Kirigami.Theme.colorSet : Kirigami.Theme.View
        Kirigami.Theme.inherit: controlRoot.Kirigami.Theme.inherit
    }

    indicator: Item {}

    contentItem: MouseArea {
        onPressed: mouse.accepted = false;
        onWheel: {
            if (wheel.pixelDelta.y < 0 || wheel.angleDelta.y < 0) {
                controlRoot.currentIndex = Math.min(controlRoot.currentIndex + 1, delegateModel.count -1);
            } else {
                controlRoot.currentIndex = Math.max(controlRoot.currentIndex - 1, 0);
            }
        }
        T.TextField {
            anchors {
                fill: parent
                leftMargin: controlRoot.mirrored ? 12 : 1
                rightMargin: !controlRoot.mirrored ? 12 : 1
            }

            text: controlRoot.editText

            visible: typeof(controlRoot.editable) != "undefined" && controlRoot.editable
            readOnly: controlRoot.popup.visible
            inputMethodHints: controlRoot.inputMethodHints
            validator: controlRoot.validator

            // Work around Qt bug where NativeRendering breaks for non-integer scale factors
            // https://bugreports.qt.io/browse/QTBUG-67007
            renderType: Screen.devicePixelRatio % 1 !== 0 ? Text.QtRendering : Text.NativeRendering
            color: controlRoot.enabled ? Kirigami.Theme.textColor : Kirigami.Theme.disabledTextColor
            selectionColor: Kirigami.Theme.highlightColor
            selectedTextColor: Kirigami.Theme.highlightedTextColor
            selectByMouse: true

            font: controlRoot.font
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            opacity: controlRoot.enabled ? 1 : 0.3
        }
    }

    background: StylePrivate.StyleItem {
        id: styleitem
        control: controlRoot
        elementType: "combobox"
        anchors.fill: parent
        hover: controlRoot.hovered
        sunken: controlRoot.pressed
        raised: !sunken
        hasFocus: controlRoot.activeFocus
        enabled: controlRoot.enabled
        // contentHeight as in QComboBox magic numbers taken from QQC1 style
        contentHeight: Math.max(Math.ceil(textHeight("")), 14) + 2
        text: controlRoot.displayText
        properties: {
            "editable" : control.editable
        }
    }

    popup: T.Popup {
        y: controlRoot.height
        width: Math.max(controlRoot.width, 150)
        implicitHeight: contentItem.implicitHeight
        topMargin: 6
        bottomMargin: 6
        Kirigami.Theme.colorSet: Kirigami.Theme.View
        Kirigami.Theme.inherit: controlRoot.Kirigami.Theme.inherit

        contentItem: ListView {
            id: listview
            clip: true
            implicitHeight: contentHeight
            model: controlRoot.popup.visible ? controlRoot.delegateModel : null
            currentIndex: controlRoot.highlightedIndex
            highlightRangeMode: ListView.ApplyRange
            highlightMoveDuration: 0
            T.ScrollBar.vertical: Controls.ScrollBar { }
        }
        background: Rectangle {
            anchors {
                fill: parent
                margins: -1
            }
            radius: 2
            color: Kirigami.Theme.backgroundColor
            property color borderColor: Kirigami.Theme.textColor
            border.color: Qt.rgba(borderColor.r, borderColor.g, borderColor.b, 0.3)
            layer.enabled: true
            
            layer.effect: DropShadow {
                transparentBorder: true
                radius: 8
                samples: 8
                horizontalOffset: 0
                verticalOffset: 2
                color: Qt.rgba(0, 0, 0, 0.3)
            }
        }
    }
}
