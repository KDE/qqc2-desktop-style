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

pragma Singleton
import QtQuick 2.2

QtObject {
    property SystemPalette active: SystemPalette { colorGroup: SystemPalette.Active }
    property SystemPalette disabled: SystemPalette { colorGroup: SystemPalette.Disabled }

    function alternateBase(enabled) { return enabled ? active.alternateBase : disabled.alternateBase }
    function base(enabled) { return enabled ? active.base : disabled.base }
    function button(enabled) { return enabled ? active.button : disabled.button }
    function buttonText(enabled) { return enabled ? active.buttonText : disabled.buttonText }
    function dark(enabled) { return enabled ? active.dark : disabled.dark }
    function highlight(enabled) { return enabled ? active.highlight : disabled.highlight }
    function highlightedText(enabled) { return enabled ? active.highlightedText : disabled.highlightedText }
    function light(enabled) { return enabled ? active.light : disabled.light }
    function mid(enabled) { return enabled ? active.mid : disabled.mid }
    function midlight(enabled) { return enabled ? active.midlight : disabled.midlight }
    function shadow(enabled) { return enabled ? active.shadow : disabled.shadow }
    function text(enabled) { return enabled ? active.text : disabled.text }
    function window(enabled) { return enabled ? active.window : disabled.window }
    function windowText(enabled) { return enabled ? active.windowText : disabled.windowText }
}
