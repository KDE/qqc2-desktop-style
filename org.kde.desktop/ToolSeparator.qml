/*
    SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQuick 2.6
import QtQuick.Templates @QQC2_VERSION@ as T
import org.kde.kirigami 2.4 as Kirigami

T.ToolSeparator {
    id: controlRoot

    topPadding: 0
    bottomPadding: 0
    leftPadding: Kirigami.Units.smallSpacing
    rightPadding: Kirigami.Units.smallSpacing

    implicitWidth: separator.width + controlRoot.leftPadding + controlRoot.rightPadding
    implicitHeight: parent.height

    background: Kirigami.Separator {
        id: separator
        anchors {
            top: controlRoot.top
            bottom: controlRoot.bottom
            horizontalCenter: controlRoot.horizontalCenter
        }
    }
}
