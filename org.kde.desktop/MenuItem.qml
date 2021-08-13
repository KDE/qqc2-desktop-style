/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQuick 2.6
import QtQuick.Layouts 1.2
import QtQuick.Templates @QQC2_VERSION@ as T
import org.kde.kirigami 2.4 as Kirigami

T.MenuItem {
    id: controlRoot

    palette: Kirigami.Theme.palette
    implicitWidth: Math.max(background ? background.implicitWidth : 0,
                            contentItem.implicitWidth + leftPadding + rightPadding + (arrow ? arrow.implicitWidth : 0))
    implicitHeight: visible ? Math.max(background ? background.implicitHeight : 0,
                             Math.max(contentItem.implicitHeight,
                                      indicator ? indicator.implicitHeight : 0) + topPadding + bottomPadding) : 0
    baselineOffset: contentItem.y + contentItem.baselineOffset

    width: parent ? parent.width : implicitWidth

    Layout.fillWidth: true
    padding: Kirigami.Units.smallSpacing
    verticalPadding: Math.floor(Kirigami.Units.smallSpacing * 1.5)
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

    contentItem: RowLayout {
        Item {
           Layout.preferredWidth: (controlRoot.ListView.view && controlRoot.ListView.view.hasCheckables) || controlRoot.checkable ? controlRoot.indicator.width : Kirigami.Units.smallSpacing
        }
        Kirigami.Icon {
            Layout.alignment: Qt.AlignVCenter
            visible: (controlRoot.ListView.view && controlRoot.ListView.view.hasIcons) || (controlRoot.icon != undefined && (controlRoot.icon.name.length > 0 || controlRoot.icon.source.length > 0))
            source: controlRoot.icon ? (controlRoot.icon.name || controlRoot.icon.source) : ""
            color: controlRoot.icon ? controlRoot.icon.color : "transparent"
            Layout.preferredHeight: Math.max(Kirigami.Units.iconSizes.roundedIconSize(label.height), Kirigami.Units.iconSizes.small)
            Layout.preferredWidth: Layout.preferredHeight
        }
        Label {
            id: label
            Layout.alignment: Qt.AlignVCenter
            Layout.fillWidth: true

            text: controlRoot.Kirigami.MnemonicData.richTextLabel
            font: controlRoot.font
            color: Kirigami.Theme.textColor
            elide: Text.ElideRight
            visible: controlRoot.text
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
        }
        Label {
            id: shortcut
            Layout.alignment: Qt.AlignVCenter
            visible: controlRoot.action && controlRoot.action.hasOwnProperty("shortcut") && controlRoot.action.shortcut !== undefined
            
            Shortcut {
                id: itemShortcut
                sequence: (shortcut.visible && controlRoot.action !== null) ? controlRoot.action.shortcut : ""
            }
            
            text: visible ? itemShortcut.nativeText : ""
            font: controlRoot.font
            color: label.color
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
        }
        Item {
           Layout.preferredWidth: Kirigami.Units.smallSpacing
        }
    }

    arrow: Kirigami.Icon {
        x: controlRoot.mirrored ? controlRoot.padding : controlRoot.width - width - controlRoot.padding
        y: controlRoot.topPadding + (controlRoot.availableHeight - height) / 2
        source: controlRoot.mirrored ? "go-next-symbolic-rtl" : "go-next-symbolic"
        selected: controlRoot.highlighted
        width: Math.max(Kirigami.Units.iconSizes.roundedIconSize(label.height), Kirigami.Units.iconSizes.small)
        height: width
        visible: controlRoot.subMenu
    }

    indicator: CheckIndicator {
        x: controlRoot.mirrored ? controlRoot.width - width - controlRoot.rightPadding : controlRoot.leftPadding
        y: controlRoot.topPadding + (controlRoot.availableHeight - height) / 2

        drawIcon: false // We're drawing it ourselves in this control

        visible: controlRoot.checkable
        on: controlRoot.checked
        control: controlRoot
    }

    background: Item {
        anchors.fill: parent
        implicitWidth: Kirigami.Units.gridUnit * 8

        Rectangle {
            anchors.fill: parent
            anchors.margins: 2
            opacity: (controlRoot.highlighted || controlRoot.hovered) ? 1 : 0
            color: Qt.rgba(Kirigami.Theme.focusColor.r, Kirigami.Theme.focusColor.g, Kirigami.Theme.focusColor.b, 0.3)
            border.color: Kirigami.Theme.focusColor
            border.width: 1
            radius: 3
        }
    }
}
