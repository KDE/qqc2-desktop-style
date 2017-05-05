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
//QQC1 is needed for StyleItem to fully work
import QtQuick.Controls 1.0 as QQC1
import QtQuick.Controls.Private 1.0
import QtQuick.Templates 2.0 as T

T.TabBar {
    id: control

    implicitWidth: contentItem.implicitWidth
    implicitHeight: contentItem.implicitHeight

    spacing: 0

    contentItem: ListView {
        implicitWidth: control.contentModel.get(0).implicitWidth * count
        implicitHeight: control.contentModel.get(0).height

        model: control.contentModel
        currentIndex: control.currentIndex

        spacing: -styleItem.pixelMetric("tabOverlap")-1
        orientation: ListView.Horizontal
        boundsBehavior: Flickable.StopAtBounds
        flickableDirection: Flickable.AutoFlickIfNeeded
        snapMode: ListView.SnapToItem

        highlightMoveDuration: 0
        highlightRangeMode: ListView.ApplyRange
        preferredHighlightBegin: 40
        preferredHighlightEnd: width - 40
    }

    StyleItem {
        id: styleItem
        visible: false
        elementType: "tabframe"
        properties: {
            "orientation" : control.position == T.TabBar.Header ? "Top" : "Bottom"
        }
    }

    background: Item {
        Rectangle {
            anchors {
                left: parent.left
                right: parent.right
                bottom : control.position == T.TabBar.Header ? parent.bottom : undefined
                top : control.position == T.TabBar.Header ? undefined : parent.top
            }
            height: 1
            color: SystemPaletteSingleton.text(control.enabled)
            opacity: 0.4
        }
    }
}
