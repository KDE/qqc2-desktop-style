/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQuick 2.6
import org.kde.qqc2desktopstyle.private 1.0 as StylePrivate
import org.kde.kirigami 2.4 as Kirigami
import QtQuick.Templates @QQC2_VERSION@ as T

T.TabBar {
    id: controlRoot

    palette: Kirigami.Theme.palette
    Kirigami.Theme.colorSet: Kirigami.Theme.Window
    Kirigami.Theme.inherit: false

    //Some QStyles seem to not return sensible pixelmetrics here
    implicitWidth: Math.max(Kirigami.Units.gridUnit * 6, contentItem.implicitWidth)
    implicitHeight: contentItem.implicitHeight

    spacing: 0

    contentItem: ListView {
        implicitWidth: contentWidth
        // The binding to contentModel.count is so it updates when the TabBar is populated on demand
        implicitHeight: controlRoot.contentModel.get(controlRoot.contentModel.count * 0).height

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

    background: MouseArea {
        acceptedButtons: Qt.NoButton
        onWheel: {
            if (wheel.pixelDelta.y < 0 || wheel.angleDelta.y < 0) {
                controlRoot.currentIndex = Math.min(controlRoot.currentIndex + 1, controlRoot.contentModel.count -1);
            } else {
                controlRoot.currentIndex = Math.max(controlRoot.currentIndex - 1, 0);
            }
        }
    }
}
