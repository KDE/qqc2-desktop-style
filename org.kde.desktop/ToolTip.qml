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
import QtGraphicalEffects 1.0
import QtQuick.Controls @QQC2_VERSION@ as Controls
import QtQuick.Templates @QQC2_VERSION@ as T
import org.kde.kirigami 2.4 as Kirigami

T.ToolTip {
    id: controlRoot

    @DISABLE_UNDER_QQC2_2_4@ palette: Kirigami.Theme.palette
    Kirigami.Theme.colorSet: Kirigami.Theme.Tooltip
    Kirigami.Theme.inherit: false

    x: parent ? (parent.width - implicitWidth) / 2 : 0
    y: -implicitHeight - 3

    implicitWidth: contentItem.implicitWidth + leftPadding + rightPadding
    implicitHeight: contentItem.implicitHeight + topPadding + bottomPadding

    margins: 6
    padding: 6

    visible: Kirigami.Settings.tabletMode ? parent.pressed : parent.hovered
    delay: Kirigami.Settings.tabletMode ? Qt.styleHints.mousePressAndHoldInterval : 1000
    timeout: 5000

    closePolicy: T.Popup.CloseOnEscape | T.Popup.CloseOnPressOutsideParent | T.Popup.CloseOnReleaseOutsideParent

    contentItem: Controls.Label {
        text: controlRoot.text
        font: controlRoot.font
        Kirigami.Theme.colorSet: Kirigami.Theme.Tooltip
        color: Kirigami.Theme.textColor
    }


    background: Rectangle {
        radius: 3
        opacity: 0.95
        color: Kirigami.Theme.backgroundColor
        Kirigami.Theme.colorSet: Kirigami.Theme.Tooltip
        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            radius: 4
            samples: 8
            horizontalOffset: 0
            verticalOffset: 2
            color: Qt.rgba(0, 0, 0, 0.3)
        }
    }

}
