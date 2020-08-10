/*
    SPDX-FileCopyrightText: 2019 Alexander Stippich <a.stippich@gmx.net>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQuick 2.6
import QtQuick.Templates @QQC2_VERSION@ as T
import org.kde.qqc2desktopstyle.private 1.0 as StylePrivate

T.MenuSeparator {
    id: controlRoot

    @DISABLE_UNDER_QQC2_2_4@ palette: Kirigami.Theme.palette
    implicitWidth: background.implicitWidth
    implicitHeight: background.implicitHeight

    background: StylePrivate.StyleItem {
        elementType: "menuitem"
        control: controlRoot
        enabled: control.enabled
        properties: {
            "type": 0,
            "menuHasCheckables": controlRoot.ListView.view && controlRoot.ListView.view.hasCheckables
        }
    }
}
