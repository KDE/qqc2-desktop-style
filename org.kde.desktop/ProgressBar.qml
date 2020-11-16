/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQuick 2.6
import org.kde.qqc2desktopstyle.private 1.0 as StylePrivate
import QtQuick.Templates @QQC2_VERSION@ as T
import org.kde.kirigami 2.4 as Kirigami

T.ProgressBar {
    id: controlRoot

    @DISABLE_UNDER_QQC2_2_4@ palette: Kirigami.Theme.palette
    implicitWidth: 250
    implicitHeight: 22

    hoverEnabled: true

    contentItem: Item {}

    background: StylePrivate.StyleItem {
        elementType: "progressbar"
        control: controlRoot
        maximum: indeterminate ? 0 : controlRoot.to*100
        minimum: indeterminate ? 0 : controlRoot.from*100
        value: indeterminate ? 0 : ((Qt.application.layoutDirection === Qt.LeftToRight ? controlRoot.visualPosition : 1 - controlRoot.visualPosition)*controlRoot.to*100)
        horizontal: true
        enabled: controlRoot.enabled
        Timer {
            interval: 50
            running: controlRoot.indeterminate
            repeat: true
            onTriggered: parent.updateItem();
        }
    }
}
