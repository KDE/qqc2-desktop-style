// SPDX-FileCopyrightText: 2021 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick 2.12
import QtQuick.Templates 2.15 as T
import QtQuick.Controls 2.12
import org.kde.kirigami 2.15 as Kirigami

T.Pane {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)

    padding: Kirigami.Units.largeSpacing

    background: Rectangle {
        color: Kirigami.Theme.backgroundColor
    }
}

