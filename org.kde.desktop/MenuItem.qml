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
import QtQuick.Layouts 1.2
import QtQuick.Templates @QQC2_VERSION@ as T
import org.kde.kirigami 2.2 as Kirigami

T.MenuItem {
    id: controlRoot

    implicitWidth: Math.max(background ? background.implicitWidth : 0,
                            contentItem.implicitWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(background ? background.implicitHeight : 0,
                             Math.max(contentItem.implicitHeight,
                                      indicator ? indicator.implicitHeight : 0) + topPadding + bottomPadding)
    baselineOffset: contentItem.y + contentItem.baselineOffset

    Layout.fillWidth: true
    padding: 1
    hoverEnabled: true

    contentItem: RowLayout {
        Item {
           Layout.preferredWidth: controlRoot.ListView.view.hasCheckables || controlRoot.checkable ? controlRoot.indicator.width : 0
        }
        Kirigami.Icon {
            Layout.alignment: Qt.AlignVCenter
            visible: controlRoot.ListView.view.hasIcons || (controlRoot.icon && (controlRoot.icon.name.length > 0 || controlRoot.icon.source.length > 0))
            source: controlRoot.icon ? (controlRoot.icon.name || controlRoot.icon.source) : ""
            color: controlRoot.icon ? controlRoot.icon.color : "transparent"
            selected: controlRoot.highlighted
            Layout.preferredHeight: Math.max(label.height, Kirigami.Units.iconSizes.small)
            Layout.preferredWidth: Layout.preferredHeight
        }
        Label {
            id: label
            Layout.alignment: Qt.AlignVCenter
            Layout.fillWidth: true

            text: controlRoot.text
            font: controlRoot.font
            color: controlRoot.highlighted ? Kirigami.Theme.highlightedTextColor : Kirigami.Theme.textColor
            elide: Text.ElideRight
            visible: controlRoot.text
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
        }
    }

//we can't use arrow: on old qqc2 releases
@DISABLE_UNDER_QQC2_2_3@    arrow: Kirigami.Icon {
@DISABLE_UNDER_QQC2_2_3@        x: controlRoot.mirrored ? controlRoot.padding : controlRoot.width - width - controlRoot.padding
@DISABLE_UNDER_QQC2_2_3@        y: controlRoot.topPadding + (controlRoot.availableHeight - height) / 2
@DISABLE_UNDER_QQC2_2_3@        source: controlRoot.mirrored ? "go-next-symbolic-rtl" : "go-next-symbolic"
@DISABLE_UNDER_QQC2_2_3@        selected: controlRoot.highlighted
@DISABLE_UNDER_QQC2_2_3@        width: Math.max(label.height, Kirigami.Units.iconSizes.small)
@DISABLE_UNDER_QQC2_2_3@        height: width
@DISABLE_UNDER_QQC2_2_3@        visible: controlRoot.subMenu
@DISABLE_UNDER_QQC2_2_3@    }

    indicator: CheckIndicator {
        x: controlRoot.mirrored ? controlRoot.width - width - controlRoot.rightPadding : controlRoot.leftPadding
        y: controlRoot.topPadding + (controlRoot.availableHeight - height) / 2

        visible: controlRoot.checkable
        on: controlRoot.checked
        control: controlRoot
    }

    background: Item {
        anchors.fill: parent
        implicitWidth: Kirigami.Units.gridUnit * 8

        Rectangle {
            anchors.fill: parent
            color: Kirigami.Theme.highlightColor
            opacity: controlRoot.highlighted ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: 150 } }
        }
    }
}
