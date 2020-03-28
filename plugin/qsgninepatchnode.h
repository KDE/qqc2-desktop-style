/*
    SPDX-FileCopyrightText: 2016 The Qt Company Ltd. <https://www.qt.io/licensing/>

    This file is part of the QtQuick module of the Qt Toolkit.

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KFQF-Accepted-GPL OR LicenseRef-Qt-Commercial
*/

#ifndef QSGNINEPATCHNODE_H
#define QSGNINEPATCHNODE_H

#include <QtQuick/qsgnode.h>
#include <QtQuick/qsgtexture.h>

QT_BEGIN_NAMESPACE

class Q_QUICK_EXPORT QSGNinePatchNode : public QSGGeometryNode
{
public:
    virtual ~QSGNinePatchNode() { }

    virtual void setTexture(QSGTexture *texture) = 0;
    virtual void setBounds(const QRectF &bounds) = 0;
    virtual void setDevicePixelRatio(qreal ratio) = 0;
    virtual void setPadding(qreal left, qreal top, qreal right, qreal bottom) = 0;
    virtual void update() = 0;

    static void rebuildGeometry(QSGTexture *texture, QSGGeometry *geometry,
                                const QVector4D &padding,
                                const QRectF &bounds, qreal dpr);
};

QT_END_NAMESPACE

#endif // QSGNINEPATCHNODE_H
