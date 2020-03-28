/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQuick 2.6
import QtQuick.Templates @QQC2_VERSION@ as T
import org.kde.qqc2desktopstyle.private 1.0 as StylePrivate
import org.kde.kirigami 2.4 as Kirigami

T.Control {
    id: control

    @DISABLE_UNDER_QQC2_2_4@ palette: Kirigami.Theme.palette
    implicitWidth: Math.max(background ? background.implicitWidth : 0,
                            (contentItem ? contentItem.implicitWidth : 0) + leftPadding + rightPadding)
    implicitHeight: Math.max(background ? background.implicitHeight : 0,
                             (contentItem ? contentItem.implicitHeight : 0) + topPadding + bottomPadding)

    leftPadding: styleItem.pixelMetric("layoutleftmargin")
    topPadding: styleItem.pixelMetric("layouttopmargin")
    rightPadding: styleItem.pixelMetric("layoutrightmargin")
    bottomPadding: styleItem.pixelMetric("layoutbottommargin")

    property Item __style: StylePrivate.StyleItem {
        id: styleItem
    }
}
