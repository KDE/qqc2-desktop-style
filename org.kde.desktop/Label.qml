/*
 * Copyright 2017 Marco Martin <mart@kde.org>
 * Copyright 2017 The Qt Company Ltd.
 *
 * GNU Lesser General Public License Usage
 * Alternatively, this file may be used under the terms of the GNU Lesser
 * General Public License version 3 as published by the Free Software
 * Foundation and appearing in the file LICENSE.LGPLv3 included in the
 * packaging of this file. Please review the following information to
 * ensure the GNU Lesser General Public License version 3 requirements
 * will be met: https://www.gnu.org/licenses/lgpl.html.
 *
 * GNU General Public License Usage
 * Alternatively, this file may be used under the terms of the GNU
 * General Public License version 2.0 or later as published by the Free
 * Software Foundation and appearing in the file LICENSE.GPL included in
 * the packaging of this file. Please review the following information to
 * ensure the GNU General Public License version 2.0 requirements will be
 * met: http://www.gnu.org/licenses/gpl-2.0.html.
 */


import QtQuick 2.1
import QtQuick.Window 2.2
import QtQuick.Templates 2.0 as T
import org.kde.qqc2desktopstyle.private 1.0 as StylePrivate
import org.kde.kirigami 2.2 as Kirigami

T.Label {
    id: control

    verticalAlignment: lineCount > 1 ? Text.AlignTop : Text.AlignVCenter

    activeFocusOnTab: false
    //Text.NativeRendering is broken on non integer pixel ratios
    renderType: Window.devicePixelRatio % 1 !== 0 ? Text.QtRendering : Text.NativeRendering
    

    font.capitalization: Kirigami.Theme.defaultFont.capitalization
    font.family: Kirigami.Theme.defaultFont.family
    font.italic: Kirigami.Theme.defaultFont.italic
    font.letterSpacing: Kirigami.Theme.defaultFont.letterSpacing
    font.pointSize: Kirigami.Theme.defaultFont.pointSize
    font.strikeout: Kirigami.Theme.defaultFont.strikeout
    font.underline: Kirigami.Theme.defaultFont.underline
    font.weight: Kirigami.Theme.defaultFont.weight
    font.wordSpacing: Kirigami.Theme.defaultFont.wordSpacing
    color: Kirigami.Theme.textColor
    linkColor: Kirigami.Theme.linkColor

    opacity: enabled? 1 : 0.6

    Accessible.role: Accessible.StaticText
    Accessible.name: text
}
