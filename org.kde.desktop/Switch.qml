/*
    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/


import QtQuick 2.6
import QtQuick.Templates 2.15 as T
import org.kde.kirigami 2.4 as Kirigami

T.Switch {
    id: control

    implicitWidth: contentItem.implicitWidth + leftPadding + rightPadding
    implicitHeight: Math.max(contentItem.implicitHeight,
                                      indicator ? indicator.implicitHeight : 0) + topPadding + bottomPadding
    baselineOffset: contentItem.y + contentItem.baselineOffset

    padding: 1
    spacing: Kirigami.Units.smallSpacing

    hoverEnabled: true

    indicator: SwitchIndicator {
        x: if (control.contentItem !== null && control.contentItem.width > 0) {
            return control.mirrored ?
                control.width - width - control.rightPadding : control.leftPadding
        } else {
            return control.leftPadding + (control.availableWidth - width) / 2
        }
        y: if (control.contentItem !== null
            && (control.contentItem instanceof Text || control.contentItem instanceof TextEdit)
            && control.contentItem.lineCount > 1) {
            return control.topPadding
        } else {
            return control.topPadding + Math.round((control.availableHeight - height) / 2)
        }
        control: control
    }

    Kirigami.MnemonicData.enabled: control.enabled && control.visible
    Kirigami.MnemonicData.controlType: Kirigami.MnemonicData.ActionElement
    Kirigami.MnemonicData.label: control.text
    Shortcut {
        //in case of explicit & the button manages it by itself
        enabled: !(RegExp(/\&[^\&]/).test(control.text))
        sequence: control.Kirigami.MnemonicData.sequence
        onActivated: control.toggle();
    }

    contentItem: Label {
        property FontMetrics fontMetrics: FontMetrics {}
        // Ensure consistent vertical position relative to indicator with multiple lines.
        // No need to round because .5 from the top will add with .5 from the bottom becoming 1.
        topPadding: Math.max(0, (controlRoot.implicitIndicatorHeight - fontMetrics.height) / 2)
        bottomPadding: topPadding
        leftPadding: control.indicator && !control.mirrored ? control.indicator.width + control.spacing : 0
        rightPadding: control.indicator && control.mirrored ? control.indicator.width + control.spacing : 0
        opacity: control.enabled ? 1 : 0.6
        text: control.Kirigami.MnemonicData.richTextLabel
        font: control.font
        color: Kirigami.Theme.textColor
        elide: Text.ElideRight
        visible: control.text
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
    }
}
