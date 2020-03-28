/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQuick 2.1
import org.kde.kirigami 2.4 as Kirigami

Rectangle {
    id: background
    color: highlighted || (controlRoot.pressed && !controlRoot.checked && !controlRoot.sectionDelegate) ? Kirigami.Theme.highlightColor : Kirigami.Theme.backgroundColor

    visible: controlRoot.ListView.view ? controlRoot.ListView.view.highlight === null : true
    Rectangle {
        anchors.fill: parent
        color: Kirigami.Theme.highlightColor
        opacity: controlRoot.hovered && !controlRoot.pressed ? 0.2 : 0
    }
}

