/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the Qt Quick Controls 2 module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL3$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see http://www.qt.io/terms-conditions. For further
** information use the contact form at http://www.qt.io/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 3 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPLv3 included in the
** packaging of this file. Please review the following information to
** ensure the GNU Lesser General Public License version 3 requirements
** will be met: https://www.gnu.org/licenses/lgpl.html.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 2.0 or later as published by the Free
** Software Foundation and appearing in the file LICENSE.GPL included in
** the packaging of this file. Please review the following information to
** ensure the GNU General Public License version 2.0 requirements will be
** met: http://www.gnu.org/licenses/gpl-2.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.6
import QtQuick.Controls.Private 1.0
import QtQuick.Templates 2.1 as T
import QtQuick.Controls.Universal 2.1

T.ScrollBar {
    id: control

    implicitWidth: Math.max(background ? background.implicitWidth : 0,
                            contentItem.implicitWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(background ? background.implicitHeight : 0,
                             contentItem.implicitHeight + topPadding + bottomPadding)

    hoverEnabled: Qt.styleHints.useHoverEffects

    background: StyleItem {
        anchors.fill: parent
        elementType: "scrollbar"
        hover: activeControl != "none"
        activeControl: "none"
        sunken: control.pressed
        minimum: 0
        maximum: (control.height/control.size - control.height)
        value: control.position * (control.height/control.size)
        horizontal: control.orientation == Qt.Horizontal
        enabled: control.enabled

        implicitWidth: horizontal ? 200 : pixelMetric("scrollbarExtent")
        implicitHeight: horizontal ? pixelMetric("scrollbarExtent") : 200

        visible: control.size < 1.0
        Text {
            x: -1000
            text: (control.height/control.size - control.height)
        }
        Timer {
            id: buttonTimer
            property real increment
            repeat: true
            interval: 150
            onTriggered: {
                control.position += increment;
            }
        }
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onPositionChanged: parent.activeControl = parent.hitTest(mouse.x, mouse.y)
            onExited: parent.activeControl = "none";
            onPressed: {
                if (parent.activeControl == "down") {
                    buttonTimer.increment = 0.02;
                    buttonTimer.running = true;
                    mouse.accepted = true
                } else if (parent.activeControl == "up") {
                    buttonTimer.increment = -0.02;
                    buttonTimer.running = true;
                    mouse.accepted = true
                } else {
                    mouse.accepted = false
                }
            }
            onReleased: {
                buttonTimer.running = false;
                mouse.accepted = false
            }
            onCanceled: buttonTimer.running = false;
        }
    }

    contentItem: Item {
        implicitWidth: 12
        implicitHeight: 12
        visible: control.size < 1.0
    }

}
