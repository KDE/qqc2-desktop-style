/*
 *   Copyright 2016 Marco Martin <mart@kde.org>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU Library General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

import QtQuick 2.6
import QtQuick.Controls 2.1
import QtQml.Models 2.1
//QQC1 is needed for StyleItem to fully work
import QtQuick.Controls 1.0 as QQC1
import QtQuick.Controls.Private 1.0
import QtQuick.Templates 2.0 as T

T.TabButton {
    id: control

    implicitWidth: styleitem.implicitWidth
    implicitHeight: styleitem.implicitHeight
    baselineOffset: contentItem.y + contentItem.baselineOffset

    padding: 0

    hoverEnabled: true

    contentItem: Item {}

    background: StyleItem {
        id: styleitem

        anchors.fill: parent
        elementType: "tab"
        paintMargins: 0
        property Item tabBar: control.parent.parent.parent

        property string orientation: tabBar.position == TabBar.Header ? "Top" : "Bottom"
        property string selectedpos: tabBar.currentIndex == control.ObjectModel.index + 1 ? "next" :
                                    tabBar.currentIndex == control.ObjectModel.index - 1 ? "previous" : ""
        property string tabpos: tabBar.count === 1 ? "only" : control.ObjectModel.index === 0 ? "beginning" : control.ObjectModel.index === tabBar.count - 1 ? "end" : "middle"

        properties: {
            "hasFrame" : true,
            "orientation": orientation,
            "tabpos": tabpos,
            "selectedpos": selectedpos
        }

        enabled: control.enabled
        selected: control.checked
        text: control.text
        hover: control.hovered
        hasFocus: control.activeFocus
    }
}
