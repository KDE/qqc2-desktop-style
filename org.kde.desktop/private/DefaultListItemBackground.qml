/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.
    SPDX-FileCopyrightText: 2023 ivan tkachenko <me@ratijas.tk>
    SPDX-FileCopyrightText: 2024 Carl Schwan <carl@carlschwan.eu>

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQuick
import QtQuick.Templates as T
import org.kde.kirigami as Kirigami

Rectangle {
    id: background

    property T.ItemDelegate control

    readonly property bool highlight: control.highlighted || control.down

    readonly property color highlightColor: Kirigami.ColorUtils.tintWithAlpha(Kirigami.Theme.backgroundColor, Kirigami.Theme.highlightColor, 0.3)
    readonly property color normalColor: control._useAlternatingColors ? Kirigami.Theme.alternateBackgroundColor : "transparent"
    readonly property bool reallyFocus: control.visualFocus || (control.activeFocus && control.focusReason === Qt.OtherFocusReason)

    radius: control.TableView.view || Kirigami.Theme.useAlternateBackgroundColor ? 0 : Kirigami.Units.cornerRadius

    color: if (control.highlighted || control.checked || (control.down && !control.checked) || reallyFocus) {
        if (control.hovered) {
            return Kirigami.ColorUtils.tintWithAlpha(highlightColor, Kirigami.Theme.textColor, 0.10);
        } else {
            return highlightColor;
        }
    } else if (control.hovered) {
        return Kirigami.ColorUtils.tintWithAlpha(Kirigami.Theme.backgroundColor, Kirigami.Theme.textColor, 0.10);
    } else {
        return normalColor;
    }

    border {
        color: Kirigami.Theme.highlightColor
        width: reallyFocus ? 1 : 0
    }
}
