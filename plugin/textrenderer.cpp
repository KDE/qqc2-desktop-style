/*
    SPDX-FileCopyrightText: 2022 by David Edmundson <davidedmundson@kde.org>

    SPDX-License-Identifier: LGPL-2.0-or-later
*/

#include "textrenderer_p.h"
#include <cmath>

TextRenderAttached::TextRenderAttached(QObject *attachee)
{
    QQuickItem *item = qobject_cast<QQuickItem *>(attachee);
    if (!item) {
        return;
    }

    // even though we don't have contents only items with this flag get change notifications
    setFlags(QQuickItem::ItemHasContents);
    setParentItem(item);
}

void TextRenderAttached::itemChange(ItemChange change, const ItemChangeData &value)
{
    if (change == QQuickItem::ItemDevicePixelRatioHasChanged || change == QQuickItem::ItemSceneChange) {
        update();
    }
}

void TextRenderAttached::update()
{
    if (!window()) {
        return;
    }

    QQuickWindow::TextRenderType renderType = QQuickWindow::NativeTextRendering;

    if (!qFuzzyIsNull(fmod(window()->effectiveDevicePixelRatio(), 1.0))) {
        renderType = QQuickWindow::QtTextRendering;
    }
    if (renderType != m_renderType) {
        m_renderType = renderType;
        Q_EMIT renderTypeChanged();
    }
}
