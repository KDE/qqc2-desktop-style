/*
 * Copyright 2018 Marco Martin <mart@kde.org>
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
import QtQuick.Controls @QQC2_VERSION@ as Controls
import org.kde.qqc2desktopstyle.private 1.0 as StylePrivate
import org.kde.kirigami 2.4 as Kirigami

T.RoundButton {
    id: controlRoot
    @DISABLE_UNDER_QQC2_2_4@ palette: Kirigami.Theme.palette
    Kirigami.Theme.colorSet: !flat && controlRoot.activeFocus ? Kirigami.Theme.Selection : Kirigami.Theme.Button
    Kirigami.Theme.inherit: false

    implicitWidth: Math.max(background ? background.implicitWidth : 0,
                            contentItem.implicitWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(background ? background.implicitHeight : 0,
                             contentItem.implicitHeight + topPadding + bottomPadding)
    baselineOffset: contentItem.y + contentItem.baselineOffset

    hoverEnabled: !Kirigami.Settings.isMobile

    transform: Translate {
        x: controlRoot.down || controlRoot.checked ? 1 : 0
        y: controlRoot.down || controlRoot.checked ? 1 : 0
    }
    contentItem: Item {
        implicitWidth: mainLayout.implicitWidth
        implicitHeight: mainLayout.implicitHeight
        RowLayout {
            id: mainLayout
            anchors.centerIn: parent
            Kirigami.Icon {
                Layout.preferredWidth: Kirigami.Units.iconSizes.smallMedium
                Layout.preferredHeight: Kirigami.Units.iconSizes.smallMedium
                Layout.fillWidth: true
                Layout.fillHeight: true
                visible: source.length > 0
                source: controlRoot.icon ? (controlRoot.icon.name || controlRoot.icon.source) : ""
            }
            Controls.Label {
                text: controlRoot.text
                visible: text.length > 0
            }
        }
    }
    background: Rectangle {
        property color borderColor: Qt.tint(Kirigami.Theme.textColor, Qt.rgba(Kirigami.Theme.backgroundColor.r, Kirigami.Theme.backgroundColor.g, Kirigami.Theme.backgroundColor.b, 0.7))

        implicitWidth: Kirigami.Units.iconSizes.large
        implicitHeight: Kirigami.Units.iconSizes.large
        radius: controlRoot.radius
        color: (controlRoot.activeFocus && (controlRoot.hovered || controlRoot.highlighted)) || controlRoot.down || controlRoot.checked ? Qt.lighter(borderColor, 1.1) : Kirigami.Theme.backgroundColor

        border.color: (controlRoot.hovered || controlRoot.highlighted) ? Qt.lighter(Kirigami.Theme.highlightColor, 1.2) : borderColor
        border.width: 1

        Rectangle {
            radius: controlRoot.radius
            anchors.fill: parent
            visible: !controlRoot.flat
            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0.13) }
                GradientStop { position: 1.0; color: Qt.rgba(0, 0, 0, 0.03) }
            }
        }
        Rectangle {
            z: -1
            radius: controlRoot.radius
            visible: !controlRoot.down && !controlRoot.checked && !controlRoot.flat
            anchors {
                topMargin: 1
                bottomMargin: -1
                fill: parent
            }
            color: Qt.rgba(0, 0, 0, 0.15)
        }
    }
}
