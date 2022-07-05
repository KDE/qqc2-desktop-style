/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQuick 2.6
import QtQuick.Templates 2.15 as T
import org.kde.kirigami 2.4 as Kirigami

T.Container {
    id: control

    implicitWidth: Math.max(background ? background.implicitWidth : 0,
                            (contentItem ? contentItem.implicitWidth : 0) + leftPadding + rightPadding)
    implicitHeight: Math.max(background ? background.implicitHeight : 0,
                             (contentItem ? contentItem.implicitHeight : 0) + topPadding + bottomPadding)
}
