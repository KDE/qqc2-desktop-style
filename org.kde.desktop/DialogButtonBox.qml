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

    @DISABLE_UNDER_QQC2_2_4@ palette: Kirigami.Theme.palette
    implicitWidth: contentItem.implicitWidth + leftPadding + rightPadding
    implicitHeight: contentItem.implicitHeight + topPadding + bottomPadding

    spacing: Kirigami.Units.smallSpacing
    padding: Kirigami.Units.smallSpacing
    alignment: Qt.AlignRight

    delegate: Button {
        width: Math.min(implicitWidth, control.width / control.count - control.padding - control.spacing * control.count)
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
