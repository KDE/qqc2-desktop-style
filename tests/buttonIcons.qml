/*
 * Copyright 2017 Marco Martin <mart@kde.org>
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
import QtQuick.Controls 2.3 as Controls

Item {
    width: 600
    height: 600
    ColumnLayout {
        anchors.centerIn: parent
        Controls.Button {
            text: "Menu"
            icon.name: "go-previous"
            onClicked: menu.open();
            Controls.Menu {
                id: menu
                y: parent.height

                Controls.MenuItem {
                    checkable: true
                    text: "Item1"
                    icon.name: "go-next"
                }
                Controls.MenuItem {
                    text: "Item2"
                    icon.name: "folder-video"
                }
            }
        }
        Controls.ToolButton {
            text: "text"
            icon.name: "go-previous"
        }
    }
}
