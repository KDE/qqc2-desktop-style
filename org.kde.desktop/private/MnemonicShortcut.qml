/*
    SPDX-FileCopyrightText: 2023 ivan tkachenko <me@ratijas.tk>

    SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQuick 2.15
import QtQuick.Templates 2.15 as T
import org.kde.kirigami 2.20 as Kirigami

Shortcut {
    /**
     * The control which this shortcut triggers, and to which Kirigami.MnemonicData is attached.
     */
    // KF6: Mark this as required. See QTBUG-103479
    property T.AbstractButton control

    // If button text contains unescaped magic "&" character, then its
    // mnemonic shortcut is provided by QtQuick.Templates implementation.
    // We only care about controls with implicit accelerators managed by Kirigami.
    //
    // Note: This regexp checks whether the text contains accelerators in it.
    // Double ampersand is an escaped character, and can't be considered as
    // accelerator. There could be a sequence of double-ampersands, but we
    // have to use negative lookahead to ensure it is not preceded by another
    // one, and there's an even amount of them total; so that one more
    // ampersand after those which is also followed by a non-ampersand means
    // that we found an actual accelerator. Also, accelerator can't be at the
    // end of the string; it doesn't make any sense.
    enabled: !/(?<!&)(?:&&)*&[^&]/.test(control.text)

    sequence: control.Kirigami.MnemonicData.sequence

    // Emulate behavior of shortcut-activated QQC2.Action
    onActivated: {
        // Hopefully this works as a guard that caches value of control.
        const c = control;

        if (c.action) {
            // This will emit Action::triggered, which in turn emits Control::clicked.
            // Internally, QQuickAction checks for effective enabled state of the control,
            // so we don't have to worry about it here.
            c.action.trigger();
        } else {
            // Emulate QQuickActionPrivate::trigger. We don't have direct
            // access to its API, especially not when action is null.

            if (c.checkable && (!c.checked || !c.T.ButtonGroup.group || !c.T.ButtonGroup.group.exclusive || c.T.ButtonGroup.group.checkedButton != c)) {
                // Emulate QQuickAction::toggle in the absense of QQuickAction
                if (!c.enabled) {
                    return;
                }

                if (c.checkable) {
                    // This method only calls setChecked() without breaking any possible bindings.
                    c.toggle();
                }

                // We don't emit anything like QQuickAction::toggled(source), because
                // there is no action, and that signal isn't magically
                // connected to anything on the Button's side.
            }

            if (c) {
                // Emulate QQuickAbstractButtonPrivate::click which QQuickAction::triggered is connected to.
                if (c.enabled) {
                    c.clicked();
                }
            }
        }
    }
}
