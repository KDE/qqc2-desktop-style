/*
 *   Copyright (C) 2019 Cyril Rossi <cyril.rossi@enioka.com>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU Library General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
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
    emit targetChanged(m_target);
}

void KPropertyWriter::setPropertyName(const QString &propertyName)
{
    if (m_propertyName == propertyName) {
        return;
    }

    m_propertyName = propertyName;
    emit propertyNameChanged(m_propertyName);
}

#include "moc_kpropertywriter_p.cpp"
