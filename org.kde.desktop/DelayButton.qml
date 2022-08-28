/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/

import QtQuick 2.6
import QtQuick.Templates 2.15 as T
import org.kde.qqc2desktopstyle.private 1.0 as StylePrivate
import org.kde.kirigami 2.4 as Kirigami

T.DelayButton {
    id: controlRoot

    implicitWidth: Math.max((text && display !== T.AbstractButton.IconOnly ?
        implicitBackgroundWidth : implicitHeight) + leftInset + rightInset,
        implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    hoverEnabled: Qt.styleHints.useHoverEffects

    Kirigami.MnemonicData.enabled: controlRoot.enabled && controlRoot.visible
    Kirigami.MnemonicData.controlType: Kirigami.MnemonicData.ActionElement
    Kirigami.MnemonicData.label: controlRoot.display !== T.AbstractButton.IconOnly ? controlRoot.text : ""
    Shortcut {
        //in case of explicit & the button manages it by itself
        enabled: !(RegExp(/\&[^\&]/).test(controlRoot.text))
        sequence: controlRoot.Kirigami.MnemonicData.sequence
        onActivated: controlRoot.clicked()
    }

    Kirigami.Theme.colorSet: Kirigami.Theme.Button
    Kirigami.Theme.inherit: false

    transition: Transition {
        NumberAnimation {
            duration: controlRoot.delay * (controlRoot.pressed ? 1.0 - controlRoot.progress : 0.3 * controlRoot.progress)
        }
    }

    background: StylePrivate.StyleItem {
        control: controlRoot
        elementType: "delaybutton"
        sunken: controlRoot.down
        on: controlRoot.checkable && controlRoot.checked
        hover: controlRoot.hovered
        text: controlRoot.Kirigami.MnemonicData.mnemonicLabel
        hasFocus: controlRoot.visualFocus || (!controlRoot.flat && controlRoot.pressed)
        flat: false
        minimum: 0
        maximum: 1000
        value: controlRoot.progress * maximum

        readonly property int toolButtonStyle: {
            switch (controlRoot.display) {
            case T.ToolButton.IconOnly: return Qt.ToolButtonIconOnly;
            case T.ToolButton.TextOnly: return Qt.ToolButtonTextOnly;
            case T.ToolButton.TextBesideIcon: return Qt.ToolButtonTextBesideIcon;
            case T.ToolButton.TextUnderIcon: return Qt.ToolButtonTextUnderIcon;
            default: return Qt.ToolButtonFollowStyle;
            }
        }

        properties: {
            "icon": controlRoot.icon.name || controlRoot.icon.source,
            "iconColor": controlRoot.icon.color,
            "iconWidth": controlRoot.icon.width,
            "iconHeight": controlRoot.icon.height,
            "toolButtonStyle": toolButtonStyle,
        }
    }
}
