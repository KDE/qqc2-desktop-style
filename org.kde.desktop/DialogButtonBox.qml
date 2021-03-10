/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQuick 2.6
import QtQuick.Templates @QQC2_VERSION@ as T
import org.kde.kirigami 2.4 as Kirigami

T.DialogButtonBox {
    id: control

    palette: Kirigami.Theme.palette

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)

    spacing: Kirigami.Units.smallSpacing
    padding: Kirigami.Units.smallSpacing
    alignment: Qt.AlignRight

    delegate: Button {
        // Round because fractional width values are possible.
        width: Math.round(Math.min(
            implicitWidth,
            // Divide availableWidth (width - leftPadding - rightPadding) by the number of buttons,
            // then subtract the spacing between each button.
            (control.availableWidth / control.count) - (control.spacing * (control.count-1))
        ))
        Kirigami.MnemonicData.controlType: Kirigami.MnemonicData.DialogButton
    }

    contentItem: ListView {
        implicitWidth: contentWidth
        implicitHeight: 32

        model: control.contentModel
        spacing: control.spacing
        orientation: ListView.Horizontal
        boundsBehavior: Flickable.StopAtBounds
        snapMode: ListView.SnapToItem
    }

    background: Item {}
}
