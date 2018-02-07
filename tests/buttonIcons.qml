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

Controls.ApplicationWindow {
    width: 600
    height: 600
    header: Controls.MenuBar {
        Controls.Menu {
            id: menu
            y: parent.height
            title: "&File"

            Controls.MenuItem {
                checkable: true
                text: "Item1"
                icon.name: "go-next"
                icon.color: "red"
            }
            Controls.MenuItem {
                text: "Item2"
                icon.name: "folder-video"
            }
            Controls.MenuSeparator {
            }
            Controls.MenuItem {
                checkable: true
                text: "Item3"
            }
            Controls.Menu {
                title: "Submenu"
                Controls.MenuItem {
                    checkable: true
                    text: "Item1"
                    icon.name: "go-next"
                    icon.color: "red"
                }
                Controls.MenuItem {
                    text: "Item2"
                    icon.name: "folder-video"
                }
                Controls.MenuItem {
                    text: "Item3"
                }
            }
        }
    }
    ColumnLayout {
        anchors.centerIn: parent
        Controls.Button {
            text: "Menu"
            icon.name: "go-previous"
            onClicked: menu.open();
            
        }
        Controls.ToolButton {
            text: "text"
            icon.name: "go-previous"
        }
    }
}
