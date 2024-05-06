/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQuick
import QtQuick.Templates as T
import org.kde.kirigami as Kirigami
import org.kde.qqc2desktopstyle.private as StylePrivate

T.DialogButtonBox {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    contentWidth: (contentItem as ListView)?.contentWidth ?? 0

    spacing: Kirigami.Units.mediumSpacing
    padding: Kirigami.Units.largeSpacing
    alignment: Qt.AlignRight

    property Item __style: StylePrivate.StyleItem {
        id: styleItem

        function setupKeyboardNavigationButton(): void {
            if (contentItem instanceof ListView) {
                const listView = contentItem as ListView;
                for (let index = 0; index < listView.count; index++) {
                    const button = listView.itemAtIndex(index);

                    button.Keys.onPressed.connect((event) => {
                        if (event.key == Qt.Key_Return || event.key == Qt.Key_Enter) {
                            button.down = true;
                            event.accepted = true;
                        }
                    });

                    button.Keys.onReleased.connect((event) => {
                        if (event.key == Qt.Key_Return || event.key == Qt.Key_Enter) {
                            button.down = undefined;
                            event.accepted = true;
                            button.clicked();
                        }
                    });
                }
            }
        }
    }

    Component.onCompleted: {
        styleItem.setupKeyboardNavigationButton();
    }

    delegate: Button {
        // Round because fractional width values are possible.
        width: Math.floor(Math.min(
            implicitWidth,
            // Divide availableWidth (width - leftPadding - rightPadding) by the number of buttons,
            // then subtract the spacing between each button.
            ((control.availableWidth - (control.spacing * (control.count - 1))) / control.count)
        ))
        Kirigami.MnemonicData.controlType: Kirigami.MnemonicData.DialogButton
    }

    contentItem: ListView {
        implicitWidth: contentWidth
        implicitHeight: 32

        model: control.contentModel
        spacing: control.spacing
        orientation: ListView.Horizontal
        boundsBehavior: Flickable.StopAtBounds
        snapMode: ListView.SnapToItem
    }

    // Standard buttons are destroyed and then recreated every time
    // the `standardButtons` property changes, so it is necessary to
    // run this code every time standardButtonsChanged() is emitted.
    // See QQuickDialogButtonBox::setStandardButtons()
    onStandardButtonsChanged: {
        styleItem.setupKeyboardNavigationButton();

        // standardButton() returns a pointer to an existing standard button.
        // If no such button exists, it returns nullptr.
        // Icon names are copied from KStyle::standardIcon()

        if (!styleItem.styleHint("dialogButtonsHaveIcons")) {
            return;
        }

        function setStandardIcon(buttonType, iconName) {
            const button = standardButton(buttonType)
            if (button && button.icon.name === "" && button.icon.source.toString() === "") {
                button.icon.name = iconName
            }
        }
        setStandardIcon(T.Dialog.Ok, "dialog-ok-symbolic")
        setStandardIcon(T.Dialog.Save, "document-save-symbolic")
        setStandardIcon(T.Dialog.SaveAll, "document-save-all-symbolic")
        setStandardIcon(T.Dialog.Open, "document-open-symbolic")
        setStandardIcon(T.Dialog.Yes, "dialog-ok-apply-symbolic")
        setStandardIcon(T.Dialog.YesToAll, "dialog-ok-symbolic")
        setStandardIcon(T.Dialog.No, "dialog-cancel-symbolic")
        setStandardIcon(T.Dialog.NoToAll, "dialog-cancel-symbolic")
        setStandardIcon(T.Dialog.Abort, "dialog-cancel-symbolic")
        setStandardIcon(T.Dialog.Retry, "view-refresh-symbolic")
        setStandardIcon(T.Dialog.Ignore, "dialog-cancel-symbolic")
        setStandardIcon(T.Dialog.Close, "dialog-close-symbolic")
        setStandardIcon(T.Dialog.Cancel, "dialog-cancel-symbolic")
        setStandardIcon(T.Dialog.Discard, "edit-delete-symbolic")
        setStandardIcon(T.Dialog.Help, "help-contents-symbolic")
        setStandardIcon(T.Dialog.Apply, "dialog-ok-apply-symbolic")
        setStandardIcon(T.Dialog.Reset, "edit-undo-symbolic")
        setStandardIcon(T.Dialog.RestoreDefaults, "document-revert-symbolic")
    }
}
