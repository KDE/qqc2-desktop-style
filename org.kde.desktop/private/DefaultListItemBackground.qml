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
import org.kde.qqc2desktopstyle.private 1.0 as StylePrivate

Rectangle {
    id: background
    color: highlighted || (controlRoot.pressed && !controlRoot.checked && !controlRoot.sectionDelegate) ? StylePrivate.SystemPaletteSingleton.highlight(controlRoot.enabled) : StylePrivate.SystemPaletteSingleton.base(controlRoot.enabled)

    visible: controlRoot.ListView.view ? controlRoot.ListView.view.highlight === null : true
    Rectangle {
        anchors.fill: parent
        color: StylePrivate.SystemPaletteSingleton.highlight(controlRoot.enabled)
        opacity: controlRoot.hovered && !controlRoot.pressed ? 0.2 : 0
        Behavior on opacity { NumberAnimation { duration: 150 } }
    }
    Behavior on color {
        ColorAnimation { duration: 150 }
    }
}

