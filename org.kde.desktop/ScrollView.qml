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


import QtQuick 2.9
import QtQuick.Controls @QQC2_VERSION@
import QtQuick.Templates @QQC2_VERSION@ as T
import org.kde.kirigami 2.4 as Kirigami
import org.kde.qqc2desktopstyle.private 1.0 as StylePrivate

T.ScrollView {
    id: controlRoot

    clip: true

    @DISABLE_UNDER_QQC2_2_4@ palette: Kirigami.Theme.palette
    implicitWidth: Math.max(background ? background.implicitWidth : 0, contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(background ? background.implicitHeight : 0, contentHeight + topPadding + bottomPadding)

    contentWidth: scrollHelper.flickableItem ? scrollHelper.flickableItem.contentWidth : 0
    contentHeight: scrollHelper.flickableItem ? scrollHelper.flickableItem.contentHeight : 0

    Kirigami.Theme.colorSet: Kirigami.Theme.View
    Kirigami.Theme.inherit: !background || !background.visible

    //create a background only after Component.onCompleted, see on the component creation below for explanation
    Component.onCompleted: {
        if (!controlRoot.background) {
            controlRoot.background = backgroundComponent.createObject(controlRoot);
        }
    }

    children: [
        MouseArea {
            id: scrollHelper
            anchors.fill: parent
            drag.filterChildren: !Kirigami.Settings.isMobile
            property bool isMobile: !verticalScrollBar.interactive
            onIsMobileChanged: {
                flickableItem.boundsBehavior = scrollHelper.isMobile ? Flickable.DragAndOvershootBounds : Flickable.StopAtBounds;
            }
            readonly property Flickable flickableItem: controlRoot.contentItem

            onFlickableItemChanged: {

                flickableItem.boundsBehavior = scrollHelper.isMobile ? Flickable.DragAndOvershootBounds : Flickable.StopAtBounds;
                
                //don't make the scrolling items overlap the background borders.
                flickableItem.anchors.margins = Qt.binding(function() { return controlRoot.background && controlRoot.background.visible ? 2 : 0; });
                flickableItem.clip = true;
                flickableItem.interactive = Kirigami.Settings.isMobile
            }
            onPressed: {
                mouse.accepted = false;
                flickableItem.interactive = true;
            }
            onPositionChanged: {
                mouse.accepted = false;
            }
            onReleased:  {
                mouse.accepted = false;
                flickableItem.interactive = false;
            }
            onWheel: {
                if (isMobile || flickableItem.contentHeight < flickableItem.height) {
                    return;
                }

                flickableItem.interactive = false;
                var y = wheel.pixelDelta.y != 0 ? wheel.pixelDelta.y : wheel.angleDelta.y / 8

                //if we don't have a pixeldelta, apply the configured mouse wheel lines
                if (!wheel.pixelDelta.y) {
                    y *= Kirigami.Settings.mouseWheelScrollLines;
                }

                var minYExtent = flickableItem.topMargin - flickableItem.originY;
                var maxYExtent = flickableItem.height - (flickableItem.contentHeight + flickableItem.bottomMargin + flickableItem.originY);

                flickableItem.contentY = Math.min(-maxYExtent, Math.max(-minYExtent, flickableItem.contentY - y));

                //this is just for making the scrollbar appear
                flickableItem.flick(0, 0);
                flickableItem.cancelFlick();
            }

            Connections {
                target: scrollHelper.flickableItem
                onFlickEnded: scrollHelper.flickableItem.interactive = false;
                onMovementEnded: scrollHelper.flickableItem.interactive = false;
            }

             /*create a background only after Component.onCompleted because:
              * implementations can set their own background in a declarative way
              * ScrollView {background.visible: true} must *not* work, becasue all  upstream styles don't have a background so applications using this would break with other styles
              * This is child of scrollHelper as it would break native scrollview finding of the flickable if it was a direct child
              */
            Component {
                id: backgroundComponent
                StylePrivate.StyleItem {
                    control: controlRoot
                    elementType: "edit"
                    visible: false
                    sunken: true
                    hasFocus: controlRoot.activeFocus || scrollHelper.flickableItem.activeFocus
                    hover: controlRoot.hovered
                }
            }
        }
    ]
    ScrollBar.vertical: ScrollBar {
        id: verticalScrollBar
        parent: controlRoot
        x: controlRoot.mirrored ? 0 : controlRoot.width - width
        y: controlRoot.topPadding
        height: controlRoot.availableHeight
        active: controlRoot.ScrollBar.horizontal || controlRoot.ScrollBar.horizontal.active
    }

    ScrollBar.horizontal: ScrollBar {
        parent: controlRoot
        x: controlRoot.leftPadding
        y: controlRoot.height - height
        width: controlRoot.availableWidth
        active: controlRoot.ScrollBar.vertical || controlRoot.ScrollBar.vertical.active
    }
}
