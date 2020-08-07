/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQuick 2.6
import QtQuick.Layouts 1.2
import QtQuick.Templates @QQC2_VERSION@ as T
import org.kde.kirigami 2.4 as Kirigami
import org.kde.qqc2desktopstyle.private 1.0 as StylePrivate

T.MenuItem {
    id: controlRoot

    @DISABLE_UNDER_QQC2_2_4@ palette: Kirigami.Theme.palette
    implicitWidth: background.implicitWidth
    implicitHeight: background.implicitHeight


    Layout.fillWidth: true
    hoverEnabled: !Kirigami.Settings.isMobile

    Kirigami.MnemonicData.enabled: controlRoot.enabled && controlRoot.visible
    Kirigami.MnemonicData.controlType: Kirigami.MnemonicData.MenuItem
    Kirigami.MnemonicData.label: controlRoot.text
    Shortcut {
        //in case of explicit & the button manages it by itself
        enabled: !(RegExp(/\&[^\&]/).test(controlRoot.text))
        sequence: controlRoot.Kirigami.MnemonicData.sequence
        onActivated: {
            if (controlRoot.checkable) {
                controlRoot.toggle();
            } else {
                controlRoot.clicked();
            }
        }
    }

    background: StylePrivate.StyleItem {
        elementType: "menuitem"
        control: controlRoot
        hover: control.hovered
        on: controlRoot.hovered
        selected: controlRoot.hovered
        enabled: control.enabled
        hasFocus: controlRoot.activeFocus
        text: controlRoot.Kirigami.MnemonicData.mnemonicLabel
        properties: {
            "icon": (controlRoot.ListView.view && controlRoot.ListView.view.hasIcons) || (controlRoot.icon != undefined && (controlRoot.icon.name.length > 0 || controlRoot.icon.source.length > 0)) ? (controlRoot.icon.name || controlRoot.icon.source) : "",
            "iconColor": controlRoot.icon && controlRoot.icon.color.a > 0 ? controlRoot.icon.color : Kirigami.Theme.textColor,
            "iconWidth": controlRoot.icon ?  Math.max(Kirigami.Units.fontMetrics.roundedIconSize(font), Kirigami.Units.iconSizes.small) : 0,
            "iconHeight": controlRoot.icon ?  Math.max(Kirigami.Units.fontMetrics.roundedIconSize(font), Kirigami.Units.iconSizes.small) : 0,
            "shortcut": controlRoot.action && controlRoot.action.hasOwnProperty("shortcut") && controlRoot.action.shortcut !== undefined ? controlRoot.action.shortcut : "",
            "type": controlRoot.subMenu !== null ? 2 : 1,
            "checkable": controlRoot.checkable,
            "menuHasCheckables": controlRoot.ListView.view && controlRoot.ListView.view.hasCheckables
        }
    }
}
