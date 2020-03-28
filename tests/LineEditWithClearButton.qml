/*
   SPDX-FileCopyrightText: 2019 Montel Laurent <montel@kde.org>

   SPDX-License-Identifier: LGPL-2.0-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
*/

import org.kde.kirigami 2.7 as Kirigami
Kirigami.ActionTextField {
    id: __searchField
    focus: true
    rightActions: [
        Kirigami.Action {
            iconName: "edit-clear"
            visible: __searchField.text !== ""
            onTriggered: {
                __searchField.text = ""
                __searchField.accepted()
            }
        }
    ]
}
