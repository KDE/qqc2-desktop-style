/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.
    SPDX-FileCopyrightText: 2023 ivan tkachenko <me@ratijas.tk>

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQuick
import QtQuick.Templates as T
import org.kde.kirigami as Kirigami

Rectangle {
    id: background

    property T.ItemDelegate control

    color: control.highlighted || (control.down && !control.checked && !control.sectionDelegate)
        ? Kirigami.Theme.highlightColor
        : ((control.TableView.view && control.TableView.view.alternatingRows && row % 2
            || control.Kirigami.Theme.useAlternateBackgroundColor && index % 2)
            ? Kirigami.Theme.alternateBackgroundColor
            : Kirigami.Theme.backgroundColor)

    visible: control.ListView.view ? control.ListView.view.highlight === null : true

    Rectangle {
        anchors.fill: parent
        color: Kirigami.Theme.highlightColor
        opacity: control.hovered && !control.down ? 0.2 : 0
    }
}
