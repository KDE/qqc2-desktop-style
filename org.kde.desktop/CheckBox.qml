/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQuick 2.6
import QtQuick.Templates @QQC2_VERSION@ as T
import QtQuick.Controls @QQC2_VERSION@
import org.kde.qqc2desktopstyle.private 1.0 as StylePrivate
import org.kde.kirigami 2.4 as Kirigami

T.CheckBox {
    id: controlRoot

    palette: Kirigami.Theme.palette
    implicitWidth: background.implicitWidth
    implicitHeight: background.implicitHeight

    hoverEnabled: true

    contentItem: Item {}
    indicator: Item {}

    Kirigami.MnemonicData.enabled: controlRoot.enabled && controlRoot.visible
    Kirigami.MnemonicData.controlType: Kirigami.MnemonicData.ActionElement
    Kirigami.MnemonicData.label: controlRoot.text
    Shortcut {
        //in case of explicit & the button manages it by itself
        enabled: !(RegExp(/\&[^\&]/).test(controlRoot.text))
        sequence: controlRoot.Kirigami.MnemonicData.sequence
        onActivated: controlRoot.toggle();
    }

    background: StylePrivate.StyleItem {
        id: styleItem
        anchors.fill: parent
        control: controlRoot
        elementType: "checkbox"
        sunken: control.pressed
        on: control.checked
        hover: control.hovered
        enabled: control.enabled
        text: controlRoot.Kirigami.MnemonicData.mnemonicLabel
        hasFocus: controlRoot.activeFocus
        properties: {
            "icon": controlRoot.icon && controlRoot.display !== T.AbstractButton.TextOnly ? (controlRoot.icon.name || controlRoot.icon.source) : "",
            "iconColor": controlRoot.icon && controlRoot.icon.color.a > 0 ? controlRoot.icon.color : Kirigami.Theme.textColor,
            "iconWidth": controlRoot.icon && controlRoot.icon.width ? controlRoot.icon.width : 0,
            "iconHeight": controlRoot.icon && controlRoot.icon.height ? controlRoot.icon.height : 0,
            "partiallyChecked": control.checkState === Qt.PartiallyChecked
        }
    }
}
