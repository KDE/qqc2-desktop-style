/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.
    SPDX-FileCopyrightText: 2023 ivan tkachenko <me@ratijas.tk>

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQuick
import QtQuick.Templates as T
import org.kde.kirigami as Kirigami
import org.kde.qqc2desktopstyle.private as StylePrivate

Item {
    id: background

    property T.ItemDelegate control

    readonly property bool highlight: control.highlighted || control.down
    readonly property bool useAlternatingColors: {
        if (control.TableView.view?.alternatingRows && row % 2) {
            return true
        } else if (control.Kirigami.StyleHints.useAlternateBackgroundColor && index % 2) {
            return true
        }
        return false
    }

    // Workaround for QTBUG-113304
    readonly property bool reallyFocus: control.visualFocus || (control.activeFocus && control.focusReason === Qt.OtherFocusReason)

    StylePrivate.StyleItem {
        anchors {
            fill: parent
            leftMargin: Math.min(0, -background.control.leftInset)
            rightMargin: -background.control.rightInset
        }
        visible: background.control.enabled
        control: background.control
        elementType: "itemrow"
        activeControl: background.useAlternatingColors ? "alternate" : ""
    }

    StylePrivate.StyleItem {
        anchors {
            fill: parent
            leftMargin: Math.min(0, -(background.control.leftPadding - background.control.leftInset))
            rightMargin: -(background.control.rightPadding - background.control.rightInset)
        }
        visible: background.control.enabled
        control: background.control
        elementType: "item"
        hover: background.control.hovered || background.reallyFocus
        selected: background.highlight
        properties: {
            "istable": background.control.TableView.view !== null
        }
    }
}
