/*
    SPDX-FileCopyrightText: 2025 Manuel Alcaraz Zambrano <manuel@alcarazzam.dev>
    SPDX-FileCopyrightText: 2019 Carl-Lucien Schwan <carl@carlschwan.eu>
    SPDX-FileCopyrightText: 2022 Felipe Kinoshita <kinofhek@gmail.com>
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2025 The Qt Company Ltd.

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later

    Based on the code of TextField, ComboBox and Kirigami.SearchField.
*/

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import QtQuick.Templates as T

import org.kde.kirigami as Kirigami
import org.kde.qqc2desktopstyle.private as StylePrivate

T.SearchField {
    id: controlRoot

    Kirigami.Theme.colorSet: Kirigami.Theme.View
    Kirigami.Theme.inherit: false

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding,
                             searchIndicator.implicitIndicatorHeight + topPadding + bottomPadding,
                             clearIndicator.implicitIndicatorHeight + topPadding + bottomPadding)

    leftPadding: (controlRoot.mirrored ?
        (clearIndicator.indicator && clearIndicator.indicator.visible ? clearIndicator.indicator.width + 1 : 0)
        : (searchIndicator.indicator && searchIndicator.indicator.visible ? searchIndicator.indicator.width + Kirigami.Units.smallSpacing * 3 : 0))
    rightPadding: (controlRoot.mirrored ?
        (searchIndicator.indicator && searchIndicator.indicator.visible ? searchIndicator.indicator.width + Kirigami.Units.smallSpacing * 3 : 0)
        : (clearIndicator.indicator && clearIndicator.indicator.visible ? clearIndicator.indicator.width + 1 : 0))

    hoverEnabled: !Kirigami.Settings.tabletMode

    delegate: ItemDelegate {
        required property var model
        required property int index
        property bool separatorVisible: false

        padding: Kirigami.Units.mediumSpacing
        bottomPadding: Kirigami.Units.mediumSpacing
        width: ListView.view.width
        text: model[controlRoot.textRole]
        highlighted: controlRoot.highlightedIndex === index

        Kirigami.Theme.colorSet: controlRoot.Kirigami.Theme.inherit ? controlRoot.Kirigami.Theme.colorSet : Kirigami.Theme.View
        Kirigami.Theme.inherit: controlRoot.Kirigami.Theme.inherit
    }

    searchIndicator.indicator: Kirigami.Icon {
        anchors.left: controlRoot.left
        anchors.leftMargin: Kirigami.Units.smallSpacing * 2
        anchors.verticalCenter: controlRoot.verticalCenter
        anchors.verticalCenterOffset: Math.round((controlRoot.topPadding - controlRoot.bottomPadding) / 2)
        implicitHeight: Kirigami.Units.iconSizes.sizeForLabels
        implicitWidth: Kirigami.Units.iconSizes.sizeForLabels
        color: Kirigami.Theme.disabledTextColor

        source: "search"
    }

    clearIndicator.indicator: QQC2.ToolButton {
        x: controlRoot.mirrored ? 1 : controlRoot.width - width - 1
        anchors.verticalCenter: controlRoot.verticalCenter
        anchors.verticalCenterOffset: Math.round((controlRoot.topPadding - controlRoot.bottomPadding) / 2)

        Layout.fillHeight: true
        Layout.preferredWidth: implicitHeight

        text: qsTr("Clear search")
        display: T.ToolButton.IconOnly
        visible: controlRoot.text.length > 0
        focusPolicy: Qt.TabFocus

        onClicked: controlRoot.text = ""

        icon {
            color: Kirigami.Theme.textColor
            width: Kirigami.Units.iconSizes.sizeForLabels
            height: Kirigami.Units.iconSizes.sizeForLabels
            name: controlRoot.mirrored ? "edit-clear-locationbar-ltr" : "edit-clear-locationbar-rtl"
        }

        QQC2.ToolTip.visible: (hovered || activeFocus) && (text.length > 0)
        QQC2.ToolTip.text: text
    }

    contentItem: T.TextField {
        id: textField
        padding: 0

        text: controlRoot.text

        // Work around Qt bug where NativeRendering breaks for non-integer scale factors
        // https://bugreports.qt.io/browse/QTBUG-67007
        renderType: Screen.devicePixelRatio % 1 !== 0 ? Text.QtRendering : Text.NativeRendering
        color: controlRoot.enabled ? Kirigami.Theme.textColor : Kirigami.Theme.disabledTextColor
        selectionColor: Kirigami.Theme.highlightColor
        selectedTextColor: Kirigami.Theme.highlightedTextColor

        font: controlRoot.font
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        opacity: controlRoot.enabled ? 1 : 0.3
    }

    background: StylePrivate.StyleItem {
        control: controlRoot
        elementType: "edit"

        sunken: true
        hasFocus: controlRoot.activeFocus
        hover: controlRoot.hovered
    }

    popup: T.Popup {
        Kirigami.OverlayZStacking.layer: Kirigami.OverlayZStacking.Menu
        Kirigami.Theme.colorSet: Kirigami.Theme.View
        Kirigami.Theme.inherit: controlRoot.Kirigami.Theme.inherit

        z: Kirigami.OverlayZStacking.z
        y: controlRoot.height + 1
        width: controlRoot.width
        implicitHeight: contentItem.implicitHeight
        topMargin: Kirigami.Units.mediumSpacing
        bottomMargin: Kirigami.Units.mediumSpacing
        modal: true
        dim: true
        closePolicy: T.Popup.CloseOnEscape | T.Popup.CloseOnPressOutside

        // Forces it to have a transparent dimmer.
        // A dimmer is needed for "click outside" to work reliably in some views
        // but default dimmer would, well, dim the contents in pure QtQuick windows,
        // like ApplicationWindow, which we don't want.
        T.Overlay.modal: Item {}

        contentItem: ScrollView {
            LayoutMirroring.enabled: controlRoot.mirrored
            LayoutMirroring.childrenInherit: true

            background: Rectangle {
                color: Kirigami.Theme.backgroundColor
                radius: Kirigami.Units.cornerRadius
            }
            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
            ListView {
                id: listView

                // this causes us to load at least one delegate
                // this is essential in guessing the contentHeight
                // which is needed to initially resize the popup
                cacheBuffer: 1

                clip: height < contentHeight
                implicitHeight: contentHeight
                model: controlRoot.delegateModel
                delegate: controlRoot.delegate
                currentIndex: controlRoot.highlightedIndex
                highlightRangeMode: ListView.ApplyRange
                highlightMoveDuration: 0
                boundsBehavior: Flickable.StopAtBounds
            }
        }

        background: Kirigami.ShadowedRectangle {
            anchors {
                fill: parent
                margins: -1
            }
            radius: Kirigami.Units.cornerRadius
            color: Kirigami.Theme.backgroundColor

            border.color: Kirigami.ColorUtils.linearInterpolation(Kirigami.Theme.backgroundColor, Kirigami.Theme.textColor, Kirigami.Theme.frameContrast)
            border.width: 1

            shadow.xOffset: 0
            shadow.yOffset: 2
            shadow.color: Qt.rgba(0, 0, 0, 0.3)
            shadow.size: 8
        }
    }
}
