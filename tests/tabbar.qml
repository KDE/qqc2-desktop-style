/*
    SPDX-FileCopyrightText: 2019 David Edmundson <kde@davidedmundson.co.uk>
    SPDX-FileCopyrightText: 2021 Nate Graham <nate@kde.org>

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import org.kde.kirigami as Kirigami

Item {
    width: 400
    height: 300

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20

        spacing: 0

        TabBar {
            id: tabView

            TabButton {
                text: "White"
            }
            TabButton {
                text: "Green"
            }
            TabButton {
                text: "Red"
                enabled: false
            }
            TabButton {
                text: "Blue"
            }
        }

        Frame {
            Layout.fillWidth: true
            Layout.fillHeight: true

            background: Rectangle {
                color: "transparent"
                border.color: Kirigami.ColorUtils.linearInterpolation(Kirigami.Theme.backgroundColor, Kirigami.Theme.textColor, Kirigami.Theme.frameContrast)
                topLeftRadius: 0
                radius: Kirigami.Units.cornerRadius
            }

            StackLayout { //or SwipeView + clip for animated?
                anchors.fill: parent

                currentIndex: tabView.currentIndex

                Rectangle {
                    color: "white"
                }
                Rectangle {
                    color: "Green"
                }
                Rectangle {
                    color: "Red"
                }
                Rectangle {
                    color: "Blue"
                }
            }
        }
    }
}
