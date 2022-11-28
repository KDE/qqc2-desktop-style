/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.
    SPDX-FileCopyrightText: 2021 Carl Schwan <carlschwan@kde.org>

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQuick 2.12
import QtQuick.Window 2.1
import QtQuick.Templates 2.15 as T
import org.kde.kirigami 2.18 as Kirigami
import org.kde.qqc2desktopstyle.private 1.0 as StylePrivate
import org.kde.sonnet 1.0 as Sonnet
import "private" as Private

T.TextArea {
    id: controlRoot
    Kirigami.Theme.colorSet: Kirigami.Theme.View
    Kirigami.Theme.inherit: false

    implicitWidth: Math.max(contentWidth + leftPadding + rightPadding,
                            background ? background.implicitWidth : 0,
                            placeholder.implicitWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(contentHeight + topPadding + bottomPadding,
                             background ? background.implicitHeight : 0,
                             placeholder.implicitHeight + topPadding + bottomPadding)

    padding: 6

    color: Kirigami.Theme.textColor
    selectionColor: Kirigami.Theme.highlightColor
    selectedTextColor: Kirigami.Theme.highlightedTextColor
    wrapMode: Text.WordWrap
    hoverEnabled: !Kirigami.Settings.tabletMode
    verticalAlignment: TextEdit.AlignTop

    // Work around Qt bug where NativeRendering breaks for non-integer scale factors
    // https://bugreports.qt.io/browse/QTBUG-67007
    renderType: StylePrivate.TextRenderer.renderType

    selectByMouse: !Kirigami.Settings.tabletMode

    cursorDelegate: Kirigami.Settings.tabletMode ? mobileCursor : null
    Component {
        id: mobileCursor
        Private.MobileCursor {
            target: controlRoot
        }
    }

    onTextChanged: Private.MobileTextActionsToolBar.shouldBeVisible = false;
    onPressed: Private.MobileTextActionsToolBar.shouldBeVisible = true;

    TapHandler {
        acceptedDevices: PointerDevice.Mouse | PointerDevice.Stylus
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        // unfortunately, taphandler's pressed event only triggers when the press is lifted
        // we need to use the longpress signal since it triggers when the button is first pressed
        longPressThreshold: 0
        onLongPressed: Private.TextFieldContextMenu.targetClick(point, controlRoot, spellcheckhighlighterLoader, controlRoot.positionAt(point.position.x, point.position.y));
    }

    Loader {
        id: spellcheckhighlighterLoader
        property bool activable: controlRoot.Kirigami.SpellChecking.enabled
        property Sonnet.Settings settings: Sonnet.Settings {}
        active: activable && settings.checkerEnabledByDefault
        onActiveChanged: if (active) {
            item.active = true;
        }
        sourceComponent: Sonnet.SpellcheckHighlighter {
            id: spellcheckhighlighter
            document: controlRoot.textDocument
            cursorPosition: controlRoot.cursorPosition
            selectionStart: controlRoot.selectionStart
            selectionEnd: controlRoot.selectionEnd
            misspelledColor: Kirigami.Theme.negativeTextColor
            active: spellcheckhighlighterLoader.activable && settings.checkerEnabledByDefault

            onChangeCursorPosition: {
                controlRoot.cursorPosition = start;
                controlRoot.moveCursorSelection(end, TextEdit.SelectCharacters);
            }
        }
    }

    Keys.onPressed: {
        // trigger if context menu button is pressed
        Private.TextFieldContextMenu.targetKeyPressed(event, controlRoot)
    }

    onPressAndHold: {
        if (!Kirigami.Settings.tabletMode) {
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
