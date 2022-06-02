/*
    SPDX-FileCopyrightText: 2020 Noah Davis <noahadvs@gmail.com>

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQuick 2.6
import QtQuick.Templates @QQC2_VERSION@ as T
import org.kde.kirigami 2.4 as Kirigami

T.ToolSeparator {
    id: controlRoot

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    contentItem: Kirigami.Separator {
        // implicitHeight is the same as ToolBar implicitHeight minus ToolBar padding if not horizontal
        implicitWidth: !horizontal ? 1 : 40 - (Kirigami.Units.smallSpacing * 2)
        implicitHeight: horizontal ? 1 : 40 - (Kirigami.Units.smallSpacing * 2)
    }
}
