/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQuick 2.6
import org.kde.qqc2desktopstyle.private 1.0 as StylePrivate
import QtQuick.Templates 2.15 as T
import org.kde.kirigami 2.4 as Kirigami

T.ProgressBar {
    id: controlRoot

    implicitWidth: 250
    implicitHeight: 22

    hoverEnabled: true

    contentItem: Item {}

    background: StylePrivate.StyleItem {
        elementType: "progressbar"
        control: controlRoot
        maximum: indeterminate ? 0 : 10000 * controlRoot.to
        minimum: indeterminate ? 0 : 10000 * controlRoot.from
        value: indeterminate ? 0 : 10000 * controlRoot.value
        horizontal: true
        enabled: controlRoot.enabled

        // ScriptAction refuses to run on its own. So we add a NumberAnimation
        // with non-zero duration to make it tied to a monitor refresh rate.
        // See git history for more (e.g. why not PauseAnimation)
        SequentialAnimation {
            running: controlRoot.indeterminate
            loops: Animation.Infinite

            NumberAnimation { duration: 1 }
            ScriptAction { script: controlRoot.background.updateItem() }
        }
    }
}
