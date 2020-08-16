/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQuick 2.6
import QtQuick.Window 2.2
import QtQuick.Templates @QQC2_VERSION@ as T
import QtQuick.Controls @QQC2_VERSION@ as Controls
import org.kde.qqc2desktopstyle.private 1.0 as StylePrivate
import org.kde.kirigami 2.12 as Kirigami

import "private" as Private

T.ComboBox {
    id: controlRoot
    @DISABLE_UNDER_QQC2_2_4@ palette: Kirigami.Theme.palette
    //NOTE: typeof necessary to not have warnings on Qt 5.7
    Kirigami.Theme.colorSet: typeof(editable) != "undefined" && editable ? Kirigami.Theme.View : Kirigami.Theme.Button
    Kirigami.Theme.inherit: false

    implicitWidth: Math.max(200, background.implicitWidth + leftPadding + rightPadding)
    implicitHeight: background.implicitHeight
    baselineOffset: contentItem.y + contentItem.baselineOffset

    hoverEnabled: true
    padding: 5
    leftPadding: controlRoot.editable && controlRoot.mirrored ? 24 : padding
    rightPadding: controlRoot.editable && !controlRoot.mirrored ? 24 : padding

    delegate: ItemDelegate {
        width: listView.width
        text: controlRoot.textRole ? (Array.isArray(controlRoot.model) ? modelData[controlRoot.textRole] : model[controlRoot.textRole]) : modelData
        highlighted: controlRoot.highlightedIndex == index
        property bool separatorVisible: false
        Kirigami.Theme.colorSet: controlRoot.Kirigami.Theme.inherit ? controlRoot.Kirigami.Theme.colorSet : Kirigami.Theme.View
        Kirigami.Theme.inherit: controlRoot.Kirigami.Theme.inherit
    }

    indicator: Item {}

    contentItem: T.TextField {
        id: textField
        padding: 0
        text: controlRoot.editable ? controlRoot.editText : controlRoot.displayText

        enabled: controlRoot.editable
        autoScroll: controlRoot.editable
        readOnly: controlRoot.down

        visible: typeof(controlRoot.editable) != "undefined" && controlRoot.editable
        inputMethodHints: controlRoot.inputMethodHints
        validator: controlRoot.validator

        // Work around Qt bug where NativeRendering breaks for non-integer scale factors
        // https://bugreports.qt.io/browse/QTBUG-67007
        renderType: Screen.devicePixelRatio % 1 !== 0 ? Text.QtRendering : Text.NativeRendering
        color: controlRoot.enabled ? Kirigami.Theme.textColor : Kirigami.Theme.disabledTextColor
        selectionColor: Kirigami.Theme.highlightColor
        selectedTextColor: Kirigami.Theme.highlightedTextColor

        selectByMouse: !Kirigami.Settings.tabletMode
        cursorDelegate: Kirigami.Settings.tabletMode ? mobileCursor : null

        font: controlRoot.font
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        opacity: controlRoot.enabled ? 1 : 0.3

        onFocusChanged: {
            if (focus) {
                Private.MobileTextActionsToolBar.controlRoot = textField;
            }
        }

        onTextChanged: Private.MobileTextActionsToolBar.shouldBeVisible = false;
        onPressed: Private.MobileTextActionsToolBar.shouldBeVisible = true;

        onPressAndHold: {
            if (!Kirigami.Settings.tabletMode) {
                return;
            }
            forceActiveFocus();
            cursorPosition = positionAt(event.x, event.y);
            selectWord();
        }
    }

    Component {
        id: mobileCursor
        Private.MobileCursor {
            target: textField
        }
    }

    Private.MobileCursor {
        target: textField
        selectionStartHandle: true
        property var rect: target.positionToRectangle(target.selectionStart)
        x: rect.x + 5
        y: rect.y + 6
    }

    background: StylePrivate.StyleItem {
        id: styleitem
        control: controlRoot
        elementType: "combobox"
        anchors.fill: parent
        hover: controlRoot.hovered || controlRoot.pressed
        on: controlRoot.pressed
        hasFocus: controlRoot.activeFocus && !controlRoot.popup.visible
        enabled: controlRoot.enabled
        // contentHeight as in QComboBox magic numbers taken from QQC1 style
        contentHeight: Math.max(Math.ceil(textHeight("")), 14) + 2
        text: controlRoot.displayText
        properties: {
            "editable" : control.editable
        }

        MouseArea {
            anchors {
                fill: parent
                leftMargin: controlRoot.leftPadding
                rightMargin: controlRoot.rightPadding
            }
            acceptedButtons: Qt.NoButton
            onWheel: {
                if (wheel.pixelDelta.y < 0 || wheel.angleDelta.y < 0) {
                    controlRoot.incrementCurrentIndex();
                } else {
                    controlRoot.decrementCurrentIndex();
                }
            }
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
        modal: true
        dim: true
        closePolicy: Controls.Popup.CloseOnEscape | Controls.Popup.CloseOnPressOutside

        // Forces it to have a transparent dimmer.
        // A dimmer is needed for "click outside" to work reliably in some views
        // but default dimmer would, well, dim the contents in pure QtQuick windows,
        // like ApplicationWindow, which we don't want.
        Controls.Overlay.modal: Item { }

        contentItem: ScrollView {
            background: Rectangle {
                color: Kirigami.Theme.backgroundColor
            }
            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
            ListView {
                id: listView

                // this causes us to load at least one delegate
                // this is essential in guessing the contentHeight
                // which is needed to initially resize the popup
                cacheBuffer: 1

                implicitHeight: contentHeight
                model: controlRoot.delegateModel
                delegate: controlRoot.delegate
                currentIndex: controlRoot.highlightedIndex
                highlightRangeMode: ListView.ApplyRange
                highlightMoveDuration: 0
                boundsBehavior: Flickable.StopAtBounds
            }
        }
        background: Kirigami.ShadowedRectangle {
            anchors {
                fill: parent
                margins: -1
            }
            radius: 2
            color: Kirigami.Theme.backgroundColor

            property color borderColor: Kirigami.Theme.textColor
            border.color: Qt.rgba(borderColor.r, borderColor.g, borderColor.b, 0.3)
            border.width: 1

            shadow.xOffset: 0
            shadow.yOffset: 2
            shadow.color: Qt.rgba(0, 0, 0, 0.3)
            shadow.size: 8
        }
    }
}
