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

    visible: control.ListView.view ? control.ListView.view.highlight === null : true

    readonly property color hoverColor: Kirigami.ColorUtils.linearInterpolation(Kirigami.Theme.highlightColor, normalColor, 0.8)
    readonly property color downColor: Kirigami.Theme.highlightColor
    readonly property color normalColor: {
        if (control.TableView.view?.alternatingRows && row % 2) {
            return Kirigami.Theme.alternateBackgroundColor
        } else if (control.Kirigami.Theme.useAlternateBackgroundColor && index % 2) {
            return Kirigami.Theme.alternateBackgroundColor
        }
        return Kirigami.Theme.backgroundColor
    }

    color: {
        if (control.highlighted || (control.down && !control.checked)) {
            return downColor
        }

        if (control.hovered) {
            return hoverColor
        }

        return normalColor
    }
}
