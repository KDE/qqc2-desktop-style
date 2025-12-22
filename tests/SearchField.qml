/*
    SPDX-FileCopyrightText: 2025 Manuel Alcaraz Zambrano <manuel@alcarazzam.dev>

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

ApplicationWindow {
    width: 300
    height: 300

    ColumnLayout {
        Layout.fillWidth: true

        ListModel {
            id: model

            ListElement {
                name: "Player 1"
            }
            ListElement {
                name: "Player 2"
            }
            ListElement {
                name: "Player 3"
            }
            ListElement {
                name: "Player 4"
            }
            ListElement {
                name: "Player 5"
            }
            ListElement {
                name: "Player 6"
            }
        }

        SearchField {
            suggestionModel: model
            textRole: "name"

            Layout.preferredWidth: 120
        }
    }
}
