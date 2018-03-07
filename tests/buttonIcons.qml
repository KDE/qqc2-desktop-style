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
import org.kde.kirigami 2.2 as Kirigami

Kirigami.ApplicationWindow {
    id: root
    width: 600
    height: 600
    Kirigami.Theme.inherit: false
    Kirigami.Theme.colorSet: Kirigami.Theme.Complementary
    header: Controls.MenuBar {
        Controls.Menu {
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
        Controls.Menu {
            title: "&Edit"

            Controls.MenuItem {
                text: "Item1"
                icon.name: "go-next"
            }
            Controls.MenuItem {
                text: "Item2"
                icon.name: "go-next"
            }
        }
    }
    Rectangle {
        id: background
        anchors.centerIn: parent
        Kirigami.Theme.inherit: false
        Kirigami.Theme.colorSet: Kirigami.Theme.Complementary

        width: childrenRect.width
        height: childrenRect.height
        color: Kirigami.Theme.backgroundColor

        ColumnLayout {

            Controls.ComboBox {
                Kirigami.Theme.inherit: true
                currentIndex: 1
                model: ["View", "Window", "Button", "Selection", "Tooltip", "Complementary"]
                onCurrentTextChanged: background.Kirigami.Theme.colorSet = currentText
            }
            Controls.Button {
                
                Kirigami.Theme.inherit: true
                text: "text"
                icon.name: "go-previous"
            }
            Controls.Button {
                id: coloredIconButton
                text: "text"
                icon.name: "go-previous"
            }
            RowLayout {
                Controls.Label {
                    text: "RGB color for icon:"
                }
                Controls.SpinBox{
                    id: red
                    editable: true
                    from: 0
                    to: 255
                    onValueModified: {
                        coloredIconButton.icon.color = Qt.rgba(red.value/255, green.value/255, blue.value/255, 1);
                    }
                }
                Controls.SpinBox{
                    id: green
                    Kirigami.Theme.inherit: true
                    editable: true
                    from: 0
                    to: 255
                    onValueModified: {
                        coloredIconButton.icon.color = Qt.rgba(red.value/255, green.value/255, blue.value/255, 1);
                    }
                }
                Controls.SpinBox{
                    id: blue
                    editable: true
                    from: 0
                    to: 255
                    onValueModified: {
                        coloredIconButton.icon.color = Qt.rgba(red.value/255, green.value/255, blue.value/255, 1);
                    }
                }
            }
            Controls.ToolButton {
                text: "text"
                icon.name: "go-previous"
            }
        }
    }
}
