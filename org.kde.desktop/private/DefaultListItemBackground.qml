/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.
    SPDX-FileCopyrightText: 2023 ivan tkachenko <me@ratijas.tk>

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQuick
import QtQuick.Templates as T
import org.kde.kirigami as Kirigami

Item {
    id: background

    property T.ItemDelegate control

    readonly property bool highlight: control.highlighted || control.down
    readonly property bool useAlternatingColors: {
        if (control.TableView.view?.alternatingRows && row % 2) {
            return true
        } else if (control.Kirigami.Theme.useAlternateBackgroundColor && index % 2) {
            return true
        }
        return false
    }

    readonly property color hoverColor: Qt.alpha(Kirigami.Theme.hoverColor, 0.3)
    readonly property color highlightColor: Kirigami.Theme.highlightColor
    readonly property color normalColor: useAlternatingColors ? Kirigami.Theme.alternateBackgroundColor : "transparent"
    // Workaround for QTBUG-113304
    readonly property bool reallyFocus: control.visualFocus || (control.activeFocus && control.focusReason === Qt.OtherFocusReason)

    readonly property bool hasInset: control.leftInset > 0 || control.rightInset > 0 || control.topInset > 0 || control.bottomInset > 0

    property alias color: alternatingBackgroundRect.color
    property alias radius: alternatingBackgroundRect.radius

    Rectangle {
        id: alternatingBackgroundRect
        anchors {
            fill: parent
            leftMargin: Math.min(0, -background.control.leftInset)
            // Omit topMargin, due to the extra top padding we always need in delegates
            rightMargin: -background.control.rightInset
            bottomMargin: -background.control.bottomInset
        }
        color: background.normalColor
    }
    Rectangle {
        anchors.fill: parent

        visible: background.control.enabled

        radius: background.hasInset ? Kirigami.Units.cornerRadius : 0

        color: {
            if (background.highlight) {
                return background.highlightColor
            } else {
                return (background.control.hovered || background.reallyFocus) ? background.hoverColor : background.normalColor
            }
        }

        border.width: background.hasInset ? 1 : 0
        border.color: {
            if (background.highlight) {
                return background.highlightColor
            } else {
                return (background.control.hovered || background.reallyFocus) ? Kirigami.Theme.hoverColor : "transparent"
            }
        }
    }
}
