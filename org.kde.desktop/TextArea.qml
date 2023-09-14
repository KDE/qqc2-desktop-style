/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.
    SPDX-FileCopyrightText: 2021 Carl Schwan <carlschwan@kde.org>
    SPDX-FileCopyrightText: 2023 ivan tkachenko <me@ratijas.tk>

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQml.Models
import QtQuick
import QtQuick.Window
import QtQuick.Templates as T
import org.kde.kirigami as Kirigami
import org.kde.sonnet as Sonnet
import org.kde.desktop.private as Private
import org.kde.qqc2desktopstyle.private as StylePrivate

T.TextArea {
    id: controlRoot
    Kirigami.Theme.colorSet: Kirigami.Theme.View
    Kirigami.Theme.inherit: false

    implicitWidth: Math.max(contentWidth + leftPadding + rightPadding,
                            implicitBackgroundWidth + leftInset + rightInset,
                            placeholder.implicitWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(contentHeight + topPadding + bottomPadding,
                             implicitBackgroundHeight + topInset + bottomInset,
                             placeholder.implicitHeight + topPadding + bottomPadding)

    padding: 6

    color: Kirigami.Theme.textColor
    selectionColor: Kirigami.Theme.highlightColor
    selectedTextColor: Kirigami.Theme.highlightedTextColor
    wrapMode: Text.WordWrap
    hoverEnabled: !Kirigami.Settings.tabletMode || !Kirigami.Settings.hasTransientTouchInput
    verticalAlignment: TextEdit.AlignTop

    // Work around Qt bug where NativeRendering breaks for non-integer scale factors
    // https://bugreports.qt.io/browse/QTBUG-67007
    renderType: Screen.devicePixelRatio % 1 !== 0 ? Text.QtRendering : Text.NativeRendering

    selectByMouse: hoverEnabled

    cursorDelegate: !hoverEnabled ? mobileCursor : null
    Component {
        id: mobileCursor
        Private.MobileCursor {
            target: controlRoot
        }
    }

    onTextChanged: Private.MobileTextActionsToolBar.shouldBeVisible = false;
    onPressed: event => {
        Private.MobileTextActionsToolBar.shouldBeVisible = true;
    }

    TapHandler {
        enabled: controlRoot.selectByMouse

        acceptedDevices: PointerDevice.Mouse | PointerDevice.Stylus
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        // unfortunately, taphandler's pressed event only triggers when the press is lifted
        // we need to use the longpress signal since it triggers when the button is first pressed
        longPressThreshold: 0

        onLongPressed: {
            Private.TextFieldContextMenu.targetClick(
                point,
                controlRoot,
                spellcheckHighlighterInstantiator,
                controlRoot.positionAt(point.position.x, point.position.y),
            );
        }
    }

    Kirigami.SpellChecking.enabled: !controlRoot.readOnly
        && Private.GlobalSonnetSettings.checkerEnabledByDefault

    Instantiator {
        id: spellcheckHighlighterInstantiator

        active: controlRoot.Kirigami.SpellChecking.enabled
        asynchronous: true

        Sonnet.SpellcheckHighlighter {
            active: true
            document: controlRoot.textDocument
            cursorPosition: controlRoot.cursorPosition
            selectionStart: controlRoot.selectionStart
            selectionEnd: controlRoot.selectionEnd
            misspelledColor: Kirigami.Theme.negativeTextColor

            onChangeCursorPosition: (start, end) => {
                controlRoot.cursorPosition = start;
                controlRoot.moveCursorSelection(end, TextEdit.SelectCharacters);
            }
        }
    }

    Keys.onPressed: event => {
        // trigger if context menu button is pressed
        if (controlRoot.selectByMouse) {
            Private.TextFieldContextMenu.targetKeyPressed(event, controlRoot)
        }
    }

    onPressAndHold: event => {
        if (hoverEnabled) {
            return;
        }
        forceActiveFocus();
        cursorPosition = positionAt(event.x, event.y);
        selectWord();
    }

    Private.MobileCursor {
        target: controlRoot
        selectionStartHandle: true
        readonly property rect rect: target.positionToRectangle(target.selectionStart)
        x: rect.x
        y: rect.y
    }

    onFocusChanged: {
        if (focus) {
            Private.MobileTextActionsToolBar.controlRoot = controlRoot;
        }
    }

    Label {
        id: placeholder
        x: controlRoot.leftPadding
        y: controlRoot.topPadding
        width: controlRoot.width - (controlRoot.leftPadding + controlRoot.rightPadding)
        height: controlRoot.height - (controlRoot.topPadding + controlRoot.bottomPadding)

        text: controlRoot.placeholderText
        font: controlRoot.font
        color: Kirigami.Theme.disabledTextColor
        horizontalAlignment: controlRoot.horizontalAlignment
        verticalAlignment: controlRoot.verticalAlignment
        visible: !controlRoot.length && !controlRoot.preeditText && (!controlRoot.activeFocus || controlRoot.horizontalAlignment !== Qt.AlignHCenter)
        elide: Text.ElideRight
    }

    background: StylePrivate.StyleItem {
        control: controlRoot
        elementType: "edit"
        implicitWidth: 200
        implicitHeight: 22

        sunken: true
        hasFocus: controlRoot.activeFocus
        hover: controlRoot.hovered
    }
}
