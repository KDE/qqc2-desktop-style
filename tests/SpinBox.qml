/*
   SPDX-FileCopyrightText: 2021 Méven Car <meven.car@enioka.com>

   SPDX-License-Identifier: LGPL-2.0-or-later
*/

import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

ApplicationWindow {
    visible: true
    width: 800
    height: 600

    GridLayout {
        anchors.fill: parent
        anchors.margins: 10
        flow: GridLayout.TopToBottom

        SpinBox {
            id: spinbox

            width: 100
            from: 1
            to: 100
            value: 50
            onValueModified: {
                console.log(value)
            }
        }
    }
}
