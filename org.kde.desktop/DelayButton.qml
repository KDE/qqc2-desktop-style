/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/

import QtQuick 2.6
import QtQuick.Templates @QQC2_VERSION@ as T
import org.kde.qqc2desktopstyle.private 1.0 as StylePrivate
import org.kde.kirigami 2.4 as Kirigami

T.DelayButton {
    id: controlRoot

    palette: Kirigami.Theme.palette
    Kirigami.Theme.colorSet: Kirigami.Theme.Button
    Kirigami.Theme.inherit: false

    implicitWidth: background.implicitWidth
    implicitHeight: background.implicitHeight

    hoverEnabled: !Kirigami.Settings.isMobile

    transition: Transition {
        NumberAnimation {
            duration: control.delay * (control.pressed ? 1.0 - control.progress : 0.3 * control.progress)
        }
    }

    contentItem: Item {}
    background: StylePrivate.StyleItem {
        id: styleitem
        control: controlRoot
        elementType: "button"
        sunken: controlRoot.down || controlRoot.checked
        raised: !(controlRoot.down || controlRoot.checked)
        hover: controlRoot.hovered
        text: controlRoot.text
        hasFocus: controlRoot.activeFocus
        activeControl: controlRoot.isDefault ? "default" : "f"

        StylePrivate.StyleItem {
            anchors {
                bottom: parent.bottom
                left: parent.left
                right: parent.right
                margins: 3
            }
            elementType: "progressbar"

            control: controlRoot
            maximum: 100
            minimum: 0
            value: controlRoot.progress * 100
            horizontal: true
            enabled: controlRoot.enabled
        }
    }
}
