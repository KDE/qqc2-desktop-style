/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.
    SPDX-FileCopyrightText: 2023 ivan tkachenko <me@ratijas.tk>

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQuick 2.15
import QtQuick.Templates 2.15 as T
import org.kde.kirigami 2.20 as Kirigami

Rectangle {
    id: background

    property T.ItemDelegate control

    color: control.highlighted || (control.pressed && !control.checked && !control.sectionDelegate)
        ? Kirigami.Theme.highlightColor : Kirigami.Theme.backgroundColor

    visible: control.ListView.view ? control.ListView.view.highlight === null : true

    Rectangle {
        anchors.fill: parent
        color: Kirigami.Theme.highlightColor
        opacity: control.hovered && !control.pressed ? 0.2 : 0
    }
}
