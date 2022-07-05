/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.

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
        "icon": styleitem.drawIcon && controlRoot.icon && controlRoot.display !== T.AbstractButton.TextOnly ? (controlRoot.icon.name || controlRoot.icon.source) : "",
        "iconColor": styleitem.drawIcon && controlRoot.icon && controlRoot.icon.color.a > 0 ? controlRoot.icon.color : Kirigami.Theme.textColor,
        "iconWidth": styleitem.drawIcon && controlRoot.icon && controlRoot.icon.width ? controlRoot.icon.width : 0,
        "iconHeight": styleitem.drawIcon && controlRoot.icon && controlRoot.icon.height ? controlRoot.icon.height : 0,
        "partiallyChecked": control.checkState === Qt.PartiallyChecked
    }
}
