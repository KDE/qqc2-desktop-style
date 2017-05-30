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
import org.kde.qqc2desktopstyle.private 1.0 as StylePrivate
import QtQuick.Templates 2.0 as T

T.ProgressBar {
    id: controlRoot

    implicitWidth: 250
    implicitHeight: 22

    hoverEnabled: true

    contentItem: Item {}
    
    background: StylePrivate.StyleItem {
        elementType: "progressbar"

        control: controlRoot
        maximum: indeterminate ? 0 : controlRoot.to*100
        minimum: indeterminate ? 0 : controlRoot.from*100
        value: indeterminate ? 0 : ((!controlRoot.inverted ? controlRoot.visualPosition : 1 - controlRoot.visualPosition)*controlRoot.to*100)
        horizontal: true
        enabled: controlRoot.enabled
        Timer {
            interval: 50
            running: controlRoot.indeterminate
            repeat: true
            onTriggered: parent.updateItem();
        }
    }
}
