/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQuick
import QtQuick.Window
import QtQuick.Templates as T
import org.kde.kirigami as Kirigami
import org.kde.desktop.private as Private
import org.kde.qqc2desktopstyle.private as StylePrivate

T.ComboBox {
    id: controlRoot

    Kirigami.Theme.colorSet: editable ? Kirigami.Theme.View : Kirigami.Theme.Button
    Kirigami.Theme.inherit: false

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding,
                             implicitIndicatorHeight + topPadding + bottomPadding)

    baselineOffset: contentItem.y + contentItem.baselineOffset

    hoverEnabled: true
    wheelEnabled: true

    padding: 5
    leftPadding: editable && mirrored ? 24 : padding
    rightPadding: editable && !mirrored ? 24 : padding

    delegate: MenuItem {
        required property var model
        required property int index
        text: model[controlRoot.textRole]
        highlighted: controlRoot.highlightedIndex === index
    }

    indicator: Item {}

    // Ensure that the combobox and its popup have enough width for all of its items
    onCountChanged: {
        let maxWidth = 75
        for (let i = 0; i < count; ++i) {
            maxWidth = Math.max(maxWidth, fontMetrics.boundingRect(controlRoot.textAt(i)).width)
        }
        styleitem.contentWidth = maxWidth
    }

    FontMetrics {
        id: fontMetrics
    }

    contentItem: T.TextField {
        padding: 0
        text: controlRoot.editable ? controlRoot.editText : controlRoot.displayText

        enabled: controlRoot.editable
        autoScroll: controlRoot.editable
        readOnly: controlRoot.down
        focus: true

        visible: controlRoot.editable
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
                Private.MobileTextActionsToolBar.controlRoot = this;
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
            target: controlRoot.contentItem
        }
    }

    Private.MobileCursor {
        target: controlRoot.contentItem
        selectionStartHandle: true
        readonly property rect rect: target.positionToRectangle(target.selectionStart)
        x: rect.x + 5
        y: rect.y + 6
    }

    background: StylePrivate.StyleItem {
        id: styleitem
        control: controlRoot
        elementType: "combobox"
        flat: controlRoot.flat
        anchors.fill: parent
        hover: controlRoot.hovered
        on: controlRoot.down && !controlRoot.popup.exit.running
        hasFocus: controlRoot.activeFocus
        enabled: controlRoot.enabled
        // contentHeight as in QComboBox magic numbers taken from QQC1 style
        contentHeight: Math.max(Math.ceil(textHeight("")), 14) + 2
        text: controlRoot.displayText
        properties: {
            "editable": control.editable
        }
    }

    popup: Menu {
        y: controlRoot.height
        width: controlRoot.width

        Repeater {
            model: controlRoot.delegateModel
        }
    }
}
