/*
    SPDX-FileCopyrightText: 2016 The Qt Company Ltd. <https://www.qt.io/licensing/>

    This file is part of the QtQuick module of the Qt Toolkit.

    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KFQF-Accepted-GPL OR LicenseRef-Qt-Commercial
*/

#ifndef QSGDEFAULTNINEPATCHNODE_P_H
#define QSGDEFAULTNINEPATCHNODE_P_H

//
//  W A R N I N G
//  -------------
//
// This file is not part of the Qt API.  It exists purely as an
// implementation detail.  This header file may change from version to
// version without notice, or even be removed.
//
// We mean it.
//

//#include <private/qtquickglobal_p.h>
#include <QSGNinePatchNode>
#include <QtQuick/qsggeometry.h>
#include <QtQuick/qsgtexturematerial.h>

QT_BEGIN_NAMESPACE

class QSGDefaultNinePatchNode : public QSGNinePatchNode
{
public:
    QSGDefaultNinePatchNode();
    ~QSGDefaultNinePatchNode() override;

    void setTexture(QSGTexture *texture) override;
    void setBounds(const QRectF &bounds) override;
    void setDevicePixelRatio(qreal ratio) override;
    void setPadding(qreal left, qreal top, qreal right, qreal bottom) override;
    void update() override;

private:
    QRectF m_bounds;
    qreal m_devicePixelRatio;
    QVector4D m_padding;
    QSGGeometry m_geometry;
    QSGTextureMaterial m_material;
};

QT_END_NAMESPACE

#endif // QSGDEFAULTNINEPATCHNODE_P_H
