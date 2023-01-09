/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.
    SPDX-FileCopyrightText: 2023 ivan tkachenko <me@ratijas.tk>

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQuick 2.6
import QtQuick.Templates 2.15 as T
import org.kde.qqc2desktopstyle.private 1.0 as StylePrivate
import org.kde.kirigami 2.4 as Kirigami

StylePrivate.StyleItem {
    id: styleitem

    property bool drawIcon: true

    elementType: control.autoExclusive ? "radiobutton" : "checkbox"
    sunken: control.pressed
    on: control.checked
    hover: control.hovered
    enabled: control.enabled
    properties: {
        "icon": styleitem.drawIcon && control.display !== T.AbstractButton.TextOnly
            ? (control.icon.name !== "" ? control.icon.name : control.icon.source) : null,
        "iconColor": Qt.colorEqual(control.icon.color, "transparent") ? Kirigami.Theme.textColor : control.icon.color,
        "iconWidth": control.icon.width,
        "iconHeight": control.icon.height,

        "partiallyChecked": control.checkState === Qt.PartiallyChecked
    }
}
