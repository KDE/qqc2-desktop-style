/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQuick 2.6
import QtQuick.Templates @QQC2_VERSION@ as T
import org.kde.kirigami 2.4 as Kirigami
import org.kde.qqc2desktopstyle.private 1.0 as StylePrivate

T.ToolButton {
    id: controlRoot

    palette: Kirigami.Theme.palette
    Kirigami.Theme.colorSet: flat ? Kirigami.Theme.Window : Kirigami.Theme.Button
    Kirigami.Theme.inherit: flat

    implicitWidth: Math.max((text && display !== T.AbstractButton.IconOnly ?
        implicitBackgroundWidth : implicitHeight) + leftInset + rightInset,
        implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    hoverEnabled: Qt.styleHints.useHoverEffects

    flat: true
    Kirigami.MnemonicData.enabled: controlRoot.enabled && controlRoot.visible
    Kirigami.MnemonicData.controlType: Kirigami.MnemonicData.SecondaryControl
    Kirigami.MnemonicData.label: controlRoot.text

    // KF6 TODO: investigate setting this by default
    // focusPolicy: Qt.TabFocus

    Shortcut {
        //in case of explicit & the button manages it by itself
        enabled: !(RegExp(/\&[^\&]/).test(controlRoot.text))
        sequence: controlRoot.Kirigami.MnemonicData.sequence
        onActivated: controlRoot.clicked()
    }
    background: StylePrivate.StyleItem {
        id: styleitem
        control: controlRoot
        elementType: "toolbutton"
        sunken: controlRoot.down
        on: controlRoot.checkable && controlRoot.checked
        hover: controlRoot.hovered
        text: controlRoot.Kirigami.MnemonicData.mnemonicLabel
        hasFocus: controlRoot.visualFocus || (!controlRoot.flat && controlRoot.pressed) || controlRoot.highlighted
        activeControl: controlRoot.isDefault ? "default" : "f"
        flat: controlRoot.flat

        // Set this to true to have the style render a menu arrow for the
        // ToolButton.
        // Note: If you use this, ensure you check whether your background item
        // has this property at all, otherwise things will break with different
        // QtQuick styles!
        property bool showMenuArrow: false

        properties: {
            "icon": controlRoot.icon ? (controlRoot.icon.name || controlRoot.icon.source) : "",
            "iconColor": controlRoot.icon && controlRoot.icon.color.a > 0? controlRoot.icon.color : Kirigami.Theme.textColor,
            "iconWidth": controlRoot.icon ? controlRoot.icon.width : 0,
            "iconHeight": controlRoot.icon ? controlRoot.icon.height : 0,
            "menu": showMenuArrow,
            "toolButtonStyle": controlRoot.display == T.ToolButton.IconOnly
                                ? Qt.ToolButtonIconOnly :
                               controlRoot.display == T.ToolButton.TextOnly
                                ? Qt.ToolButtonTextOnly :
                               controlRoot.display == T.ToolButton.TextBesideIcon
                                ? Qt.ToolButtonTextBesideIcon :
                               controlRoot.display == T.ToolButton.TextUnderIcon
                                ? Qt.ToolButtonTextUnderIcon : Qt.ToolButtonFollowStyle
        }
    }
}
