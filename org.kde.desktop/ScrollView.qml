/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQuick 2.9
import QtQuick.Controls @QQC2_VERSION@
import QtQuick.Templates @QQC2_VERSION@ as T
import org.kde.kirigami 2.9 as Kirigami
import org.kde.qqc2desktopstyle.private 1.0 as StylePrivate

T.ScrollView {
    id: controlRoot

    clip: true

    palette: Kirigami.Theme.palette
    implicitWidth: Math.max(background ? background.implicitWidth : 0, contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(background ? background.implicitHeight : 0, contentHeight + topPadding + bottomPadding)

    Kirigami.Theme.colorSet: Kirigami.Theme.View
    Kirigami.Theme.inherit: !background || !background.visible

    //size in pixel to accommodate the border drawn by qstyle
    leftPadding: (internal.backgroundVisible && background.hasOwnProperty("leftPadding") ? background.leftPadding : 0)
                    + (LayoutMirroring.enabled ? internal.verticalScrollBarWidth : 0)
    topPadding: internal.backgroundVisible && background.hasOwnProperty("topPadding") ? background.topPadding : 0
    rightPadding: (internal.backgroundVisible && background.hasOwnProperty("rightPadding") ? background.rightPadding : 0)
                    + (!LayoutMirroring.enabled ? internal.verticalScrollBarWidth : 0)
    bottomPadding: (internal.backgroundVisible && background.hasOwnProperty("bottomPadding") ? background.bottomPadding : 0)
                    + internal.horizontalScrollBarHeight

    //create a background only after Component.onCompleted, see on the component creation below for explanation
    Component.onCompleted: {
        if (!controlRoot.background) {
            controlRoot.background = backgroundComponent.createObject(controlRoot);
        }
    }

    data: [
        Kirigami.WheelHandler {
            target: controlRoot.contentItem
        },
        /*create a background only after Component.onCompleted because:
        * implementations can set their own background in a declarative way
        * ScrollView {background.visible: true} must *not* work, because all upstream styles don't have a background so applications using this would break with other styles
        * This is child of scrollHelper as it would break native scrollview finding of the flickable if it was a direct child
        */
        Component {
            id: backgroundComponent
            StylePrivate.StyleItem {
                id: styled
                control: controlRoot.contentItem
                elementType: "frame"
                visible: false
                sunken: true
                raised: false
                enabled: controlRoot.contentItem.enabled
                hasFocus: controlRoot.activeFocus || controlRoot.contentItem.activeFocus
                hover: controlRoot.hovered

                Rectangle {
                    anchors {
                        leftMargin: styled.leftPadding
                        rightMargin: styled.rightPadding
                        bottomMargin: styled.bottomPadding
                        topMargin: styled.topPadding
                    }
                    anchors.fill: parent
                    color: Kirigami.Theme.backgroundColor
                }
            }
        },

        QtObject {
            id: internal

            readonly property bool backgroundVisible: controlRoot.background && controlRoot.background.visible
            readonly property real verticalScrollBarWidth: controlRoot.ScrollBar.vertical.visible && !Kirigami.Settings.tabletMode ? controlRoot.ScrollBar.vertical.width : 0
            readonly property real horizontalScrollBarHeight: controlRoot.ScrollBar.horizontal.visible && !Kirigami.Settings.tabletMode ? controlRoot.ScrollBar.horizontal.height : 0
        }
    ]
    ScrollBar.vertical: ScrollBar {
        id: verticalScrollBar
        parent: controlRoot
        enabled: controlRoot.contentItem.enabled

        x: controlRoot.mirrored
            ? (internal.backgroundVisible && controlRoot.background.hasOwnProperty("leftPadding") ? controlRoot.background.leftPadding : 0)
            : controlRoot.width - width - (internal.backgroundVisible && controlRoot.background.hasOwnProperty("rightPadding") ? controlRoot.background.rightPadding: 0)
        y: controlRoot.topPadding
        height: controlRoot.availableHeight
        active: controlRoot.ScrollBar.horizontal || controlRoot.ScrollBar.horizontal.active
    }

    ScrollBar.horizontal: ScrollBar {
        parent: controlRoot
        enabled: controlRoot.contentItem.enabled
        x: controlRoot.leftPadding
        y: controlRoot.height - height - (internal.backgroundVisible && controlRoot.background.hasOwnProperty("bottomPadding") ? controlRoot.background.bottomPadding : 0)
        width: controlRoot.availableWidth
        active: controlRoot.ScrollBar.vertical || controlRoot.ScrollBar.vertical.active
    }
}
