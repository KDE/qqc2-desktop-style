/*
    SPDX-FileCopyrightText: 2016 The Qt Company Ltd. <https://www.qt.io/licensing/>

    This file is part of the QtQuick module of the Qt Toolkit.

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KFQF-Accepted-GPL OR LicenseRef-Qt-Commercial
*/

#include "qsgdefaultninepatchnode_p.h"

QT_BEGIN_NAMESPACE

QSGDefaultNinePatchNode::QSGDefaultNinePatchNode()
    : m_geometry(QSGGeometry::defaultAttributes_TexturedPoint2D(), 4)
{
    setGeometry(&m_geometry);
    setMaterial(&m_material);
}

QSGDefaultNinePatchNode::~QSGDefaultNinePatchNode()
{
    delete m_material.texture();
}

void QSGDefaultNinePatchNode::setTexture(QSGTexture *texture)
{
    delete m_material.texture();
    m_material.setTexture(texture);
}

void QSGDefaultNinePatchNode::setBounds(const QRectF &bounds)
{
    m_bounds = bounds;
}

void QSGDefaultNinePatchNode::setDevicePixelRatio(qreal ratio)
{
    m_devicePixelRatio = ratio;
}

void QSGDefaultNinePatchNode::setPadding(qreal left, qreal top, qreal right, qreal bottom)
{
    m_padding = QVector4D(left, top, right, bottom);
}

void QSGDefaultNinePatchNode::update()
{
    rebuildGeometry(m_material.texture(), &m_geometry, m_padding, m_bounds, m_devicePixelRatio);
    markDirty(QSGNode::DirtyGeometry | QSGNode::DirtyMaterial);
}

QT_END_NAMESPACE
