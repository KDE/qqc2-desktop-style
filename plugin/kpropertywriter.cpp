/*
    SPDX-FileCopyrightText: 2019 Cyril Rossi <cyril.rossi@enioka.com>

    SPDX-License-Identifier: LGPL-2.0-or-later
*/

#include "kpropertywriter_p.h"

QObject *KPropertyWriter::target() const
{
    return m_target;
}

QString KPropertyWriter::propertyName() const
{
    return m_propertyName;
}

bool KPropertyWriter::writeProperty(const QVariant &value)
{
    if (!m_target) {
        return false;
    }

    return m_target->setProperty(qUtf8Printable(m_propertyName), value);
}

void KPropertyWriter::setTarget(QObject *target)
{
    if (m_target == target) {
        return;
    }

    m_target = target;
    Q_EMIT targetChanged(m_target);
}

void KPropertyWriter::setPropertyName(const QString &propertyName)
{
    if (m_propertyName == propertyName) {
        return;
    }

    m_propertyName = propertyName;
    Q_EMIT propertyNameChanged(m_propertyName);
}

#include "moc_kpropertywriter_p.cpp"
