/*
    SPDX-FileCopyrightText: 2018 Marco Martin <mart@kde.org>

    SPDX-License-Identifier: LGPL-2.0-or-later
*/

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

QQC2.Popup {
    id: root

    Kirigami.OverlayZStacking.layer: Kirigami.OverlayZStacking.Menu
    z: Kirigami.OverlayZStacking.z

    parent: controlRoot.Window.window.contentItem
    modal: false
    focus: false
    closePolicy: QQC2.Popup.NoAutoClose

    x: !parent ? 0 : Math.min(Math.max(0, controlRoot.mapToItem(root.parent, controlRoot.positionToRectangle(controlRoot.selectionStart).x, 0).x - root.width / 2), root.parent.width - root.width)

    y: {
        if (!parent) {
            return 0;
        }
        var desiredY = controlRoot.mapToItem(root.parent, 0, controlRoot.positionToRectangle(controlRoot.selectionStart).y).y  - root.height;

        if (desiredY >= 0) {
            return Math.min(desiredY, root.parent.height - root.height);
        } else {
            return Math.min(Math.max(0, controlRoot.mapToItem(root.parent, 0, controlRoot.positionToRectangle(controlRoot.selectionEnd).y + Math.round(Kirigami.Units.gridUnit*1.5)).y), root.parent.height - root.height);
        }
    }

    width: contentItem.implicitWidth + leftPadding + rightPadding
    visible: true

    contentItem: RowLayout {
        QQC2.ToolButton {
            focusPolicy: Qt.NoFocus
            text: qsTr("Cut")
            display: T.AbstractButton.IconOnly
            icon.name: "edit-cut-symbolic"
            visible: controlRoot.selectedText.length > 0 && (!controlRoot.hasOwnProperty("echoMode") || controlRoot.echoMode === TextInput.Normal)
            onClicked: {
                controlRoot.cut();
            }
        }
        QQC2.ToolButton {
            focusPolicy: Qt.NoFocus
            text: qsTr("Copy")
            display: T.AbstractButton.IconOnly
            icon.name: "edit-copy-symbolic"
            visible: controlRoot.selectedText.length > 0 && (!controlRoot.hasOwnProperty("echoMode") || controlRoot.echoMode === TextInput.Normal)
            onClicked: {
                controlRoot.copy();
            }
        }
        QQC2.ToolButton {
            focusPolicy: Qt.NoFocus
            text: qsTr("Paste")
            display: T.AbstractButton.IconOnly
            icon.name: "edit-paste-symbolic"
            visible: controlRoot.canPaste
            onClicked: {
                controlRoot.paste();
            }
        }
    }
}
