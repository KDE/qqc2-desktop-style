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
import org.kde.desktop.private 1.0 as StylePrivate
import org.kde.kirigami 2.2 as Kirigami
import QtQuick.Templates @QQC2_VERSION@ as T

T.TabBar {
    id: controlRoot

    Kirigami.Theme.colorSet: Kirigami.Theme.Button
    Kirigami.Theme.inherit: false

    //Some QStyles seem to not return sensible pixelmetrics here
    implicitWidth: Math.max(Kirigami.Units.gridUnit * 6, contentItem.implicitWidth)
    implicitHeight: Math.max(Kirigami.Units.gridUnit * 2, contentItem.implicitHeight)

    spacing: 0

    contentItem: ListView {
        implicitWidth: controlRoot.contentModel.get(0).implicitWidth * count
        implicitHeight: controlRoot.contentModel.get(0).height

        model: controlRoot.contentModel
        currentIndex: controlRoot.currentIndex

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

    StylePrivate.StyleItem {
        id: styleItem
        control: controlRoot
        visible: false
        elementType: "tabframe"
        properties: {
            "orientation" : controlRoot.position == T.TabBar.Header ? "Top" : "Bottom"
        }
    }

    background: Item {
        Rectangle {
            anchors {
                left: parent.left
                right: parent.right
                bottom : controlRoot.position == T.TabBar.Header ? parent.bottom : undefined
                top : controlRoot.position == T.TabBar.Header ? undefined : parent.top
            }
            height: 1
            color: Kirigami.Theme.textColor
            opacity: 0.4
        }
    }
}
