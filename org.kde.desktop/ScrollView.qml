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
import QtQuick.Controls 2.2
//import QtQuick.Controls.impl 2.2
import QtQuick.Templates 2.2 as T

T.ScrollView {
    id: control

    clip: true

    implicitWidth: Math.max(background ? background.implicitWidth : 0, contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(background ? background.implicitHeight : 0, contentHeight + topPadding + bottomPadding)

    contentWidth: contentItem.implicitWidth || (contentChildren.length === 1 ? contentChildren[0].implicitWidth : -1)
    contentHeight: contentItem.implicitHeight || (contentChildren.length === 1 ? contentChildren[0].implicitHeight : -1)

    property Flickable flickableItem: children.length > 1 ? children[1] : null
    onFlickableItemChanged: {
        flickableItem.parent = scrollHelper;
        flickableItem.boundsBehavior = Flickable.StopAtBounds;
        flickableItem.interactive = scrollHelper.isMobile;
    }

    children: [
        MouseArea {
            id: scrollHelper
            anchors.fill: parent
            drag.filterChildren: !isMobile
            property bool isMobile: !verticalScrollBar.interactive
            onIsMobileChanged: {
                flickableItem.interactive = scrollHelper.isMobile;
            }
            onWheel: {
                if (isMobile || flickableItem.contentHeight < flickableItem.height) {
                    return;
                }
                //TODO: use kirigami for this more granular control
              /*  var sampleItem = flickableItem.itemAt ? flickableItem.itemAt(0,flickableItem.contentY) : null;
                var step = Math.min((sampleItem ? sampleItem.height : (Units.gridUnit + Units.smallSpacing * 2)) * Units.wheelScrollLines, Units.gridUnit * 8);
                //TODO: config of how many lines the wheel scrolls
                var y = wheel.pixelDelta.y != 0 ? wheel.pixelDelta.y : (wheel.angleDelta.y > 0 ? step : -step)*/
                var y = wheel.pixelDelta.y != 0 ? wheel.pixelDelta.y : wheel.angleDelta.y / 8

                var minYExtent = flickableItem.topMargin - flickableItem.originY;
                var maxYExtent = flickableItem.height - (flickableItem.contentHeight + flickableItem.bottomMargin + flickableItem.originY);

                flickableItem.contentY = Math.min(-maxYExtent, Math.max(-minYExtent, flickableItem.contentY - y));

                //this is just for making the scrollbar appear
                flickableItem.flick(0, 0);
                cancelFlickStateTimer.restart();
            }
            Timer {
                id: cancelFlickStateTimer
                interval: 150
                onTriggered: flickableItem.cancelFlick()
            }
        }
    ]
    ScrollBar.vertical: ScrollBar {
        id: verticalScrollBar
        parent: control
        x: control.mirrored ? 0 : control.width - width
        y: control.topPadding
        height: control.availableHeight
        active: control.ScrollBar.horizontal.active
    }

    ScrollBar.horizontal: ScrollBar {
        parent: control
        x: control.leftPadding
        y: control.height - height
        width: control.availableWidth
        active: control.ScrollBar.vertical.active
    }
}
