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


import QtQuick 2.1
import QtQuick.Controls 1.0 as Controls
import QtQuick.Controls.Private 1.0

Rectangle {
    id: background
    color: highlighted || (control.pressed && !control.checked && !control.sectionDelegate) ? SystemPaletteSingleton.highlight(control.enabled) : SystemPaletteSingleton.base(control.enabled)

    visible: control.ListView.view ? control.ListView.view.highlight === null : true
    Rectangle {
        anchors.fill: parent
        visible: !Settings.isMobile
        color: SystemPaletteSingleton.highlight(control.enabled)
        opacity: control.hovered && !control.pressed ? 0.2 : 0
        Behavior on opacity { NumberAnimation { duration: 150 } }
    }
    Behavior on color {
        ColorAnimation { duration: 150 }
    }
}

