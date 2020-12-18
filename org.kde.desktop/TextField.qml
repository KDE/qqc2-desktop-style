/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQuick 2.12
import QtQuick.Window 2.1
import QtQuick.Controls @QQC2_VERSION@ as Controls
import QtQuick.Templates @QQC2_VERSION@ as T
import org.kde.kirigami 2.4 as Kirigami
import org.kde.qqc2desktopstyle.private 1.0 as StylePrivate
import "private" as Private

T.TextField {
    id: controlRoot
    @DISABLE_UNDER_QQC2_2_4@ palette: Kirigami.Theme.palette
    Kirigami.Theme.colorSet: Kirigami.Theme.View
    Kirigami.Theme.inherit: false

    implicitWidth: Math.max(200,
                            placeholderText ? placeholder.implicitWidth + leftPadding + rightPadding : 0)
                            || contentWidth + leftPadding + rightPadding
    implicitHeight: Math.max(contentHeight + topPadding + bottomPadding,
                             background ? background.implicitHeight : 0,
                             placeholder.implicitHeight + topPadding + bottomPadding)

    padding: 6

    color: controlRoot.enabled ? Kirigami.Theme.textColor : Kirigami.Theme.disabledTextColor
    selectionColor: Kirigami.Theme.highlightColor
    selectedTextColor: Kirigami.Theme.highlightedTextColor
    verticalAlignment: TextInput.AlignVCenter
    hoverEnabled: !Kirigami.Settings.tabletMode

    // Work around Qt bug where NativeRendering breaks for non-integer scale factors
    // https://bugreports.qt.io/browse/QTBUG-67007
    renderType: Screen.devicePixelRatio % 1 !== 0 ? Text.QtRendering : Text.NativeRendering
    selectByMouse: !Kirigami.Settings.tabletMode

    cursorDelegate: Kirigami.Settings.tabletMode ? mobileCursor : null
    Component {
        id: mobileCursor
        Private.MobileCursor {
            target: controlRoot
        }
    }
    onFocusChanged: {
        if (focus) {
            Private.MobileTextActionsToolBar.controlRoot = controlRoot;
        }
    }

    onTextChanged: Private.MobileTextActionsToolBar.shouldBeVisible = false;

    Keys.onPressed: {
        // trigger if context menu button is pressed
        Private.TextFieldContextMenu.targetKeyPressed(event, controlRoot)
    }

    onPressed: {
        if (event.buttons & Qt.RightButton) {
            Private.TextFieldContextMenu.targetClick(event, controlRoot);
        }
    }

    onPressAndHold: {
        if (Kirigami.Settings.tabletMode) {
            forceActiveFocus();
            cursorPosition = positionAt(event.x, event.y);
            selectWord();
            Private.MobileTextActionsToolBar.shouldBeVisible = true;
        } else {
            Private.TextFieldContextMenu.targetClick(event, controlRoot);
        }
    }

    Private.MobileCursor {
        target: controlRoot
        selectionStartHandle: true
        property var rect: controlRoot.positionToRectangle(controlRoot.selectionStart+1)
        x: rect.x
        y: rect.y + target.topPadding
    }

    Text {
        id: placeholder
        x: controlRoot.leftPadding
        y: controlRoot.topPadding
        width: controlRoot.width - (controlRoot.leftPadding + controlRoot.rightPadding)
        height: controlRoot.height - (controlRoot.topPadding + controlRoot.bottomPadding)

        // Work around Qt bug where NativeRendering breaks for non-integer scale factors
        // https://bugreports.qt.io/browse/QTBUG-67007
        renderType: Screen.devicePixelRatio % 1 !== 0 ? Text.QtRendering : Text.NativeRendering

        text: controlRoot.placeholderText
        font: controlRoot.font
        color: Kirigami.Theme.disabledTextColor
        horizontalAlignment: controlRoot.horizontalAlignment
        verticalAlignment: controlRoot.verticalAlignment
        visible: !controlRoot.length && !controlRoot.preeditText && (!controlRoot.activeFocus || controlRoot.horizontalAlignment !== Qt.AlignHCenter)
        elide: Text.ElideRight
    }

    background: StylePrivate.StyleItem {
        id: style

        control: controlRoot
        elementType: "edit"

        sunken: true
        hasFocus: controlRoot.activeFocus
        hover: controlRoot.hovered
    }
}
