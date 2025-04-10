/*
    SPDX-FileCopyrightText: 2025 Nate Graham <nate@kde.org>

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/

import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QtQuick.Controls as QQC

QQC.ApplicationWindow {
    id: root

    readonly property int spacing: 18

    visible: true

    width: 800
    height: 600

    // List delegates
    GridLayout {
        anchors.fill: parent
        anchors.margins: root.spacing

        columns: 4
        rowSpacing: root.spacing
        columnSpacing: root.spacing


        // ItemDelegates
        Repeater {
            model: [
                T.AbstractButton.TextBesideIcon,
                T.AbstractButton.TextUnderIcon,
                T.AbstractButton.TextOnly,
                T.AbstractButton.IconOnly
            ]
            delegate: QQC.ScrollView {
                id: itemDelegateScrollview
                property int display: modelData

                Layout.fillWidth: true
                Layout.fillHeight: true
                contentItem: ListView {
                    clip: true
                    model: 4
                    delegate: QQC.ItemDelegate {
                        display: itemDelegateScrollview.display
                        width: ListView.view.width
                        icon.name: "edit-bomb"
                        text: "Text label"
                    }
                }
                Component.onCompleted: {
                    background.visible = true
                }
            }
        }


        // CheckDelegates
        Repeater {
            model: [
                T.AbstractButton.TextBesideIcon,
                T.AbstractButton.TextUnderIcon,
                T.AbstractButton.TextOnly,
                T.AbstractButton.IconOnly
            ]
            delegate: QQC.ScrollView {
                id: checkDelegateScrollview
                property int display: modelData

                Layout.fillWidth: true
                Layout.fillHeight: true
                contentItem: ListView {
                    clip: true
                    model: 4
                    delegate: QQC.CheckDelegate {
                        display: checkDelegateScrollview.display
                        width: ListView.view.width
                        icon.name: "edit-bomb"
                        text: "Text label"
                    }
                }
                Component.onCompleted: {
                    background.visible = true
                }
            }
        }


        // RadioDelegates
        Repeater {
            model: [
                T.AbstractButton.TextBesideIcon,
                T.AbstractButton.TextUnderIcon,
                T.AbstractButton.TextOnly,
                T.AbstractButton.IconOnly
            ]
            delegate: QQC.ScrollView {
                id: radioDelegateScrollview
                property int display: modelData

                Layout.fillWidth: true
                Layout.fillHeight: true
                contentItem: ListView {
                    clip: true
                    model: 4
                    delegate: QQC.RadioDelegate {
                        display: radioDelegateScrollview.display
                        width: ListView.view.width
                        icon.name: "edit-bomb"
                        text: "Text label"
                    }
                }
                Component.onCompleted: {
                    background.visible = true
                }
            }
        }


        // SwitchDelegates
        Repeater {
            model: [
                T.AbstractButton.TextBesideIcon,
                T.AbstractButton.TextUnderIcon,
                T.AbstractButton.TextOnly,
                T.AbstractButton.IconOnly
            ]
            delegate: QQC.ScrollView {
                id: switchDelegateScrollview
                property int display: modelData

                Layout.fillWidth: true
                Layout.fillHeight: true
                contentItem: ListView {
                    clip: true
                    model: 4
                    delegate: QQC.SwitchDelegate {
                        display: switchDelegateScrollview.display
                        width: ListView.view.width
                        icon.name: "edit-bomb"
                        text: "Text label"
                    }
                }
                Component.onCompleted: {
                    background.visible = true
                }
            }
        }
    }
}

