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
    property bool isFirstItem: false

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
    readonly property color focusColor: Kirigami.Theme.focusColor
    readonly property color normalColor: useAlternatingColors ? Kirigami.Theme.alternateBackgroundColor : "transparent"
    // Workaround for QTBUG-113304
    readonly property bool reallyFocus: control.visualFocus || (control.activeFocus && control.focusReason === Qt.OtherFocusReason)

    property real horizontalPadding: control.TableView.view ? 0 : Kirigami.Units.smallSpacing
    property real verticalPadding: control.TableView.view ? 0 : Kirigami.Units.smallSpacing
    property real cornerRadius: control.TableView.view ? 0 : 3

    color: normalColor

    Rectangle {
        anchors {
            fill: parent
            leftMargin: background.horizontalPadding
            rightMargin: background.horizontalPadding
            // We want total spacing between consecutive list items to be
            // verticalPadding. So use half that as top/bottom margin, separately
            // ceiling/flooring them so that the total spacing is preserved.
            // But we do want the full normal top margin for the first one!
            // That way the side and top margins match.
            topMargin: background.isFirstItem ? background.verticalPadding : Math.ceil(background.verticalPadding / 2)
            bottomMargin: Math.floor(background.verticalPadding / 2)
        }

        radius: background.cornerRadius

        color: {
            if (background.highlight) {
                return background.highlightColor
            } else {
                return (background.control.hovered || background.reallyFocus) ? background.hoverColor : background.normalColor
            }
        }

        border.width: background.reallyFocus ? 2 : 0
        border.color: background.focusColor
    }
}
