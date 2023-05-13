/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.
    SPDX-FileCopyrightText: 2023 ivan tkachenko <me@ratijas.tk>

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Templates as T
import org.kde.qqc2desktopstyle.private as StylePrivate
import org.kde.kirigami 2.12 as Kirigami

T.Menu {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)

    margins: 0
    horizontalPadding: style.pixelMetric("menuhmargin")
    verticalPadding: style.pixelMetric("menuvmargin")
    StylePrivate.StyleItem {
        id: style
        visible: false
    }

    delegate: MenuItem { onImplicitWidthChanged: control.contentItem.contentItem.childrenChanged() }

    contentItem: ListView {
        implicitHeight: contentHeight
        property bool hasCheckables: false
        property bool hasIcons: false
        model: control.contentModel

        implicitWidth: {
            let maxWidth = 0;
            for (let i = 0; i < contentItem.children.length; ++i) {
                maxWidth = Math.max(maxWidth, contentItem.children[i].implicitWidth);
            }
            return maxWidth;
        }

        spacing: 0 // Hardcoded to the Breeze theme value

        interactive: ApplicationWindow.window ? contentHeight > ApplicationWindow.window.height : false
        clip: true
        currentIndex: control.currentIndex || 0
        keyNavigationEnabled: true
        keyNavigationWraps: true

        ScrollBar.vertical: ScrollBar {}

        // mimic qtwidgets behaviour in regards to menu highlighting
        Connections {
            target: control.contentItem.currentItem

            function onHoveredChanged() {
                const item = control.contentItem.currentItem;
                if (item instanceof T.MenuItem && item.highlighted
                        && !item.subMenu && !item.hovered) {
                    control.currentIndex = -1
                }
            }
        }
    }

    Connections {
        target: control.contentItem.contentItem

        function onVisibleChildrenChanged() {
            const children = control.contentItem.contentItem.visibleChildren;
            let hasCheckables = control.contentItem.hasCheckables;
            let hasIcons = control.contentItem.hasIcons;
            for (let i in children) {
                const child = children[i];
                if (child.checkable) {
                    hasCheckables = true;
                }
                if (child.icon && child.icon.hasOwnProperty("name")
                        && (child.icon.name !== "" || child.icon.source.toString() !== "")) {
                    hasIcons = true;
                }
            }
            control.contentItem.hasCheckables = hasCheckables;
            control.contentItem.hasIcons = hasIcons;
        }
    }

    enter: Transition {
        NumberAnimation {
            property: "opacity"
            from: 0
            to: 1
            easing.type: Easing.InOutQuad
            duration: Kirigami.Units.shortDuration
        }
    }

    exit: Transition {
        NumberAnimation {
            property: "opacity"
            from: 1
            to: 0
            easing.type: Easing.InOutQuad
            duration: Kirigami.Units.shortDuration
        }
    }

    background: Kirigami.ShadowedRectangle {
        radius: 3
        implicitWidth: Kirigami.Units.gridUnit * 8
        color: Kirigami.Theme.backgroundColor

        property color borderColor: Kirigami.Theme.textColor
        border.color: Qt.rgba(borderColor.r, borderColor.g, borderColor.b, 0.3)
        border.width: 1

        shadow.xOffset: 0
        shadow.yOffset: 2
        shadow.color: Qt.rgba(0, 0, 0, 0.3)
        shadow.size: 8
    }
}
