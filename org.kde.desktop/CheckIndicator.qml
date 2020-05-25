/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQuick 2.6
import org.kde.qqc2desktopstyle.private 1.0 as StylePrivate

StylePrivate.StyleItem {
    id: styleitem
    elementType: control.autoExclusive ? "radiobutton" : "checkbox"
    sunken: control.pressed
    on: control.checked
    hover: control.hovered
    enabled: control.enabled
    properties: {"partiallyChecked": (control.checkState === Qt.PartiallyChecked) }
}
