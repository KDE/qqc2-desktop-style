/*
    SPDX-FileCopyrightText: 2020 Devin Lin <espidev@gmail.com>
    SPDX-FileCopyrightText: 2021 Carl Schwan <carlschwan@kde.org>
    SPDX-FileCopyrightText: 2023 ivan tkachenko <me@ratijas.tk>

    SPDX-License-Identifier: LGPL-2.0-or-later
*/

pragma Singleton

import QtQml.Models
import QtQuick
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami
import org.kde.sonnet as Sonnet

QQC2.Menu {
    id: root

    property Item target
    property bool deselectWhenMenuClosed: true
    property int restoredCursorPosition: 0
    property int restoredSelectionStart
    property int restoredSelectionEnd
    property bool persistentSelectionSetting

    property Sonnet.SpellcheckHighlighter spellcheckhighlighter
    property Loader spellcheckhighlighterLoader
    property /*list<string>*/var suggestions: []

    Component.onCompleted: persistentSelectionSetting = persistentSelectionSetting // break binding

    property var runOnMenuClose: () => {}

    parent: QQC2.Overlay.overlay

    function storeCursorAndSelection() {
        restoredCursorPosition = target.cursorPosition;
        restoredSelectionStart = target.selectionStart;
        restoredSelectionEnd = target.selectionEnd;
    }

    // target is pressed with mouse
    function targetClick(handlerPoint, newTarget, spellcheckhighlighterLoader, mousePosition) {
        if (handlerPoint.pressedButtons === Qt.RightButton) { // only accept just right click
            if (visible) {
                deselectWhenMenuClosed = false; // don't deselect text if menu closed by right click on textfield
                dismiss();
            } else {
                target = newTarget;
                target.persistentSelection = true; // persist selection when menu is opened

                this.spellcheckhighlighterLoader = spellcheckhighlighterLoader;
                spellcheckhighlighter = spellcheckhighlighterLoader?.item ?? null;
                suggestions = (spellcheckhighlighter && mousePosition)
                    ? spellcheckhighlighter.suggestions(mousePosition)
                    : [];

                storeCursorAndSelection();
                popup(target);
                // slightly locate context menu away from mouse so no item is selected when menu is opened
                x += 1
                y += 1
            }
        } else {
            dismiss();
        }
    }

    // context menu keyboard key
    function targetKeyPressed(event, newTarget) {
        if (event.modifiers === Qt.NoModifier && event.key === Qt.Key_Menu) {
            target = newTarget;
            target.persistentSelection = true; // persist selection when menu is opened
            storeCursorAndSelection();
            popup(target);
        }
    }

    function __hasSelectedText(): bool {
        return target !== null
            && target.selectedText !== "";
    }

    function __editable(): bool {
        return target !== null
            && !target.readOnly;
    }

    function __showSpellcheckActions(): bool {
        return __editable()
            && spellcheckhighlighter !== null
            && spellcheckhighlighter.active
            && spellcheckhighlighter.wordIsMisspelled;
    }

    // Show actions which should normally be hidden for password field
    function __showPasswordRestrictedActions(): bool {
        return target !== null
            && target.echoMode !== TextInput.PasswordEchoOnEdit
            && target.echoMode !== TextInput.Password;
    }

    // Show text editing actions which should normally be hidden for password field
    function __showPasswordRestrictedEditingActions(): bool {
        return __showPasswordRestrictedActions() && !target.readOnly;
    }

    onAboutToShow: {
        if (QQC2.Overlay.overlay) {
            let tempZ = 0
            for (let i in QQC2.Overlay.overlay.visibleChildren) {
                tempZ = Math.max(tempZ, QQC2.Overlay.overlay.visibleChildren[i].z)
            }
            z = tempZ + 1
        }
    }
    // deal with whether or not text should be deselected
    onClosed: {
        // restore text field's original persistent selection setting
        target.persistentSelection = persistentSelectionSetting
        // deselect text field text if menu is closed not because of a right click on the text field
        if (deselectWhenMenuClosed) {
            target.deselect();
        }
        deselectWhenMenuClosed = true;

        // restore cursor position
        target.forceActiveFocus();
        target.cursorPosition = restoredCursorPosition;
        target.select(restoredSelectionStart, restoredSelectionEnd);

        // run action, and free memory
        runOnMenuClose();
        runOnMenuClose = () => {};
    }

    onOpened: {
        runOnMenuClose = () => {};
    }

    Instantiator {
        active: root.__showSpellcheckActions()

        model: root.suggestions
        delegate: QQC2.MenuItem {
            required property string modelData

            text: modelData

            onClicked: {
                root.deselectWhenMenuClosed = false;
                root.runOnMenuClose = () => {
                    root.spellcheckhighlighter.replaceWord(modelData);
                };
            }
        }
        onObjectAdded: (index, object) => {
            root.insertItem(0, object);
        }
        onObjectRemoved: (index, object) => {
            root.removeItem(object);
        }
    }

    QQC2.MenuItem {
        visible: root.__showSpellcheckActions() && root.suggestions.length === 0
        action: QQC2.Action {
            text: root.spellcheckhighlighter ? qsTr("No Suggestions for \"%1\"").arg(root.spellcheckhighlighter.wordUnderMouse) : ""
            enabled: false
        }
    }

    QQC2.MenuSeparator {
        visible: root.__showSpellcheckActions()
    }

    QQC2.MenuItem {
        visible: root.__showSpellcheckActions()
        action: QQC2.Action {
            text: root.spellcheckhighlighter ? qsTr("Add \"%1\" to Dictionary").arg(root.spellcheckhighlighter.wordUnderMouse) : ""
            onTriggered: {
                root.deselectWhenMenuClosed = false;
                root.runOnMenuClose = () => {
                    root.spellcheckhighlighter.addWordToDictionary(root.spellcheckhighlighter.wordUnderMouse);
                };
            }
        }
    }

    QQC2.MenuItem {
        visible: root.__showSpellcheckActions()
        action: QQC2.Action {
            text: qsTr("Ignore")
            onTriggered: {
                root.deselectWhenMenuClosed = false;
                root.runOnMenuClose = () => {
                    root.spellcheckhighlighter.ignoreWord(root.spellcheckhighlighter.wordUnderMouse);
                };
            }
        }
    }

    QQC2.MenuItem {
        visible: root.target !== null
            && !root.target.readOnly
            && (root.spellcheckhighlighterLoader?.activable ?? false)

        checkable: true
        checked: root.spellcheckhighlighter?.active ?? false
        text: qsTr("Spell Check")

        onToggled: {
            if (root.spellcheckhighlighterLoader) {
                root.spellcheckhighlighterLoader.active = checked;
                root.spellcheckhighlighter = root.spellcheckhighlighterLoader.item;
            }
        }
    }

    QQC2.MenuSeparator {
        visible: root.__showSpellcheckActions()
            || (root.target !== null
                && !root.target.readOnly
                && (root.spellcheckhighlighterLoader?.activable ?? false))
    }

    QQC2.MenuItem {
        action: QQC2.Action {
            icon.name: "edit-undo-symbolic"
            text: qsTr("Undo")
            shortcut: StandardKey.Undo
        }
        visible: root.__showPasswordRestrictedEditingActions()
        enabled: root.target?.canUndo ?? false
        onTriggered: {
            root.deselectWhenMenuClosed = false;
            root.runOnMenuClose = () => {
                root.target.undo();
            };
        }
    }
    QQC2.MenuItem {
        action: QQC2.Action {
            icon.name: "edit-redo-symbolic"
            text: qsTr("Redo")
            shortcut: StandardKey.Redo
        }
        visible: root.__showPasswordRestrictedEditingActions()
        enabled: root.target?.canRedo ?? false
        onTriggered: {
            root.deselectWhenMenuClosed = false;
            root.runOnMenuClose = () => {
                root.target.redo();
            };
        }
    }
    QQC2.MenuSeparator {
        visible: root.__showPasswordRestrictedEditingActions()
    }
    QQC2.MenuItem {
        action: QQC2.Action {
            icon.name: "edit-cut-symbolic"
            text: qsTr("Cut")
            shortcut: StandardKey.Cut
        }
        visible: root.__showPasswordRestrictedEditingActions()
        enabled: root.__hasSelectedText()
        onTriggered: {
            root.deselectWhenMenuClosed = false;
            root.runOnMenuClose = () => {
                root.target.cut();
            };
        }
    }
    QQC2.MenuItem {
        action: QQC2.Action {
            icon.name: "edit-copy-symbolic"
            text: qsTr("Copy")
            shortcut: StandardKey.Copy
        }
        visible: root.__showPasswordRestrictedActions()
        enabled: root.__hasSelectedText()
        onTriggered: {
            root.deselectWhenMenuClosed = false;
            root.runOnMenuClose = () => {
                root.target.copy();
            };
        }
    }
    QQC2.MenuItem {
        action: QQC2.Action {
            icon.name: "edit-paste-symbolic"
            text: qsTr("Paste")
            shortcut: StandardKey.Paste
        }
        visible: root.__editable()
        enabled: target?.canPaste ?? false
        onTriggered: {
            root.deselectWhenMenuClosed = false;
            root.runOnMenuClose = () => {
                root.target.paste();
            };
        }
    }
    QQC2.MenuItem {
        action: QQC2.Action {
            icon.name: "edit-delete-symbolic"
            text: qsTr("Delete")
            shortcut: StandardKey.Delete
        }
        visible: root.__editable()
        enabled: root.__hasSelectedText()
        onTriggered: {
            root.deselectWhenMenuClosed = false;
            root.runOnMenuClose = () => {
                root.target.remove(root.target.selectionStart, root.target.selectionEnd);
            };
        }
    }
    QQC2.MenuSeparator {
        visible: root.target !== null
            && (root.__editable() || root.__showPasswordRestrictedActions())
    }
    QQC2.MenuItem {
        action: QQC2.Action {
            icon.name: "edit-select-all-symbolic"
            text: qsTr("Select All")
            shortcut: StandardKey.SelectAll
        }
        visible: root.target !== null
        onTriggered: {
            root.deselectWhenMenuClosed = false;
            root.runOnMenuClose = () => {
                root.target.selectAll();
            };
        }
    }
}
