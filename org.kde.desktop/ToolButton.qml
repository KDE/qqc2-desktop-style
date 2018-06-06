/*
 * Copyright 2017 Marco Martin <mart@kde.org>
 * Copyright 2017 The Qt Company Ltd.
 *
 * GNU Lesser General Public License Usage
 * Alternatively, this file may be used under the terms of the GNU Lesser
 * General Public License version 3 as published by the Free Software
 * Foundation and appearing in the file LICENSE.LGPLv3 included in the
 * packaging of this file. Please review the following information to
 * ensure the GNU Lesser General Public License version 3 requirements
 * will be met: https://www.gnu.org/licenses/lgpl.html.
 *
 * GNU General Public License Usage
 * Alternatively, this file may be used under the terms of the GNU
 * General Public License version 2.0 or later as published by the Free
 * Software Foundation and appearing in the file LICENSE.GPL included in
 * the packaging of this file. Please review the following information to
 * ensure the GNU General Public License version 2.0 requirements will be
 * met: http://www.gnu.org/licenses/gpl-2.0.html.
 */


import QtQuick 2.6
import QtQuick.Templates @QQC2_VERSION@ as T
import org.kde.kirigami 2.4 as Kirigami
import org.kde.qqc2desktopstyle.private 1.0 as StylePrivate

T.ToolButton {
    id: controlRoot

    @DISABLE_UNDER_QQC2_2_4@ palette: Kirigami.Theme.palette
    Kirigami.Theme.colorSet: flat ? Kirigami.Theme.Window : Kirigami.Theme.Button
    Kirigami.Theme.inherit: flat

    implicitWidth: text.length > 0 ? background.implicitWidth : implicitHeight
    implicitHeight: background.implicitHeight

    hoverEnabled: true //Qt.styleHints.useHoverEffects TODO: how to make this work in 5.7?

    flat: true
    contentItem: Item {}
    Kirigami.MnemonicData.enabled: controlRoot.enabled && controlRoot.visible
    Kirigami.MnemonicData.controlType: Kirigami.MnemonicData.SecondaryControl
    Kirigami.MnemonicData.label: controlRoot.text
    Shortcut {
        //in case of explicit & the button manages it by itself
        enabled: !(RegExp(/\&[^\&]/).test(controlRoot.text))
        sequence: controlRoot.Kirigami.MnemonicData.sequence
        onActivated: controlRoot.clicked()
    }
    background: StylePrivate.StyleItem {
        id: styleitem
        anchors.fill:parent
        control: controlRoot
        elementType: controlRoot.flat ? "toolbutton" : "button"
        sunken: controlRoot.pressed || (controlRoot.checkable && controlRoot.checked)
        raised: !(controlRoot.pressed || (controlRoot.checkable && controlRoot.checked))
        hover: controlRoot.hovered
        text: controlRoot.Kirigami.MnemonicData.mnemonicLabel
        hasFocus: false
        activeControl: controlRoot.isDefault ? "default" : "f"
        properties: {
            "icon": controlRoot.icon ? (controlRoot.icon.name || controlRoot.icon.source) : "",
            "iconColor": controlRoot.icon && controlRoot.icon.color.a > 0? controlRoot.icon.color : Kirigami.Theme.textColor
        }
    }
}
