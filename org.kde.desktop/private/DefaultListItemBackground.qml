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

    enum Styling {
        Default,
        Table,
        List
    }

    property int styling: DefaultListItemBackground.Styling.Default

    property real horizontalPadding: _private.addPadding() ? Kirigami.Units.smallSpacing : 0
    property real verticalPadding: _private.addPadding() ? Kirigami.Units.smallSpacing : 0
    property real cornerRadius: _private.addPadding() ? Kirigami.Units.cornerRadius : 0

    color: normalColor

    Rectangle {
        anchors {
            fill: parent
            leftMargin: background.horizontalPadding
            rightMargin: background.horizontalPadding
            // We want total spacing between consecutive list items to be
            // verticalPadding. So use half that as top/bottom margin, separately
            // ceiling/flooring them so that the total spacing is preserved.
            topMargin: Math.ceil(background.verticalPadding / 2)
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

        border.width: 1
        border.color: {
            if (background.highlight) {
                return background.highlightColor
            } else {
                return (background.control.hovered || background.reallyFocus) ? Kirigami.Theme.hoverColor : "transparent"
            }
        }
    }

    QtObject {
        id: _private
        function addPadding() {
            switch (background.styling) {
                case DefaultListItemBackground.Styling.Default:
                    return control.TableView.view ? false : true;
                case DefaultListItemBackground.Styling.Table:
                    return false;
                case DefaultListItemBackground.Styling.List:
                    return true;
            }
        }
    }
}
