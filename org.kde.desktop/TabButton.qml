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
import QtQml.Models 2.1
//for TabBar.*
import QtQuick.Controls @QQC2_VERSION@
import org.kde.qqc2desktopstyle.private 1.0 as StylePrivate
import QtQuick.Templates @QQC2_VERSION@ as T
import org.kde.kirigami 2.2 as Kirigami

T.TabButton {
    id: controlRoot

    //Some qstyles like fusion don't have correct pixel metrics here and just return 0
    implicitWidth: styleitem.implicitWidth || Kirigami.Units.gridUnit * 6
    implicitHeight: styleitem.implicitHeight || Kirigami.Units.gridUnit * 2
    baselineOffset: contentItem.y + contentItem.baselineOffset

    padding: 0

    hoverEnabled: true

    contentItem: Item {}

    background: StylePrivate.StyleItem {
        id: styleitem

        control: controlRoot
        anchors.fill: parent
        elementType: "tab"
        paintMargins: 0
        property Item tabBar: controlRoot.parent.parent.parent

        property string orientation: tabBar.position == TabBar.Header ? "Top" : "Bottom"
        property string selectedpos: tabBar.currentIndex == controlRoot.ObjectModel.index + 1 ? "next" :
                                    tabBar.currentIndex == controlRoot.ObjectModel.index - 1 ? "previous" : ""
        property string tabpos: tabBar.count === 1 ? "only" : controlRoot.ObjectModel.index === 0 ? "beginning" : controlRoot.ObjectModel.index === tabBar.count - 1 ? "end" : "middle"

        properties: {
            "hasFrame" : true,
            "orientation": orientation,
            "tabpos": tabpos,
            "selectedpos": selectedpos
        }

        enabled: controlRoot.enabled
        selected: controlRoot.checked
        text: controlRoot.text
        hover: controlRoot.hovered
        hasFocus: controlRoot.activeFocus
    }
}
