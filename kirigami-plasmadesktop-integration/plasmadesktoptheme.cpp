/*
*   Copyright (C) 2017 by Marco Martin <mart@kde.org>
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

#include "plasmadesktoptheme.h"
#include <QQmlEngine>
#include <QQmlContext>
#include <QGuiApplication>
#include <QPalette>
#include <QDebug>
#include <QQuickWindow>
#include <QTimer>
#include <KIconLoader>

#include <KColorScheme>

class IconLoaderSingleton
{
public:
    IconLoaderSingleton()
    {}

    KIconLoader self;
};

Q_GLOBAL_STATIC(IconLoaderSingleton, privateIconLoaderSelf)

PlasmaDesktopTheme::PlasmaDesktopTheme(QObject *parent)
    : PlatformTheme(parent)
{
    m_parentItem = qobject_cast<QQuickItem *>(parent);

    //null in case parent is a normal QObject
    if (m_parentItem) {
        connect(m_parentItem.data(), &QQuickItem::enabledChanged,
                this, &PlasmaDesktopTheme::syncColors);
        if (m_parentItem && m_parentItem->window()) {
            connect(m_parentItem->window(), &QWindow::activeChanged,
                    this, &PlasmaDesktopTheme::syncColors);
            m_window = m_parentItem->window();
        }
        connect(m_parentItem.data(), &QQuickItem::windowChanged,
                this, [this]() {
                    if (m_window) {
                        disconnect(m_window.data(), &QWindow::activeChanged,
                                this, &PlasmaDesktopTheme::syncColors);
                    }
                    if (m_parentItem && m_parentItem->window()) {
                        connect(m_parentItem->window(), &QWindow::activeChanged,
                                this, &PlasmaDesktopTheme::syncColors);
                    }
                    syncColors();
                });
    }

    //TODO: correct? depends from https://codereview.qt-project.org/206889
    connect(qApp, &QGuiApplication::fontDatabaseChanged, this, [this]() {setDefaultFont(qApp->font());});

    connect(this, &PlasmaDesktopTheme::colorSetChanged,
            this, &PlasmaDesktopTheme::syncColors);
    connect(qApp, &QGuiApplication::paletteChanged,
            this, &PlasmaDesktopTheme::syncColors);

    syncColors();
}

PlasmaDesktopTheme::~PlasmaDesktopTheme()
{
}

QIcon PlasmaDesktopTheme::iconFromTheme(const QString &name, const QColor &customColor)
{
    QPalette pal = palette();
    if (customColor != Qt::transparent) {
        static const QPalette::ColorGroup states[3] = { QPalette::Active, QPalette::Inactive, QPalette::Disabled };
        for (int i = 0; i < 3; i++) {
            QPalette::ColorGroup state = states[i];
            pal.setBrush(state, QPalette::WindowText, customColor);
        }
    }

    privateIconLoaderSelf->self.setCustomPalette(pal);

    return KDE::icon(name, &privateIconLoaderSelf->self);
}

QStringList PlasmaDesktopTheme::keys() const
{
    QStringList props;
    for (int i = PlatformTheme::metaObject()->propertyOffset(); i < metaObject()->propertyCount(); ++i) {
        const QString prop = QString::fromUtf8(metaObject()->property(i).name());
        if (prop != QStringLiteral("keys")) {
            props << prop;
        }
    }
    return props;
}

void PlasmaDesktopTheme::syncColors()
{
    KColorScheme::ColorSet set;

    switch (colorSet()) {
    case PlatformTheme::Button:
        set = KColorScheme::ColorSet::Button;
        break;
    case PlatformTheme::Selection:
        set = KColorScheme::ColorSet::Selection;
        break;
    case PlatformTheme::Tooltip:
        set = KColorScheme::ColorSet::Tooltip;
        break;
    case PlatformTheme::View:
        set = KColorScheme::ColorSet::View;
        break;
    case PlatformTheme::Complementary:
        set = KColorScheme::ColorSet::Complementary;
        break;
    case PlatformTheme::Window:
    default:
        set = KColorScheme::ColorSet::Window;
    }

    QPalette::ColorGroup group = QPalette::Active;
    if (m_parentItem) {
        if (!m_parentItem->isEnabled()) {
            group = QPalette::Disabled;
        } else if (m_parentItem->window() && !m_parentItem->window()->isActive()) {
            group = QPalette::Inactive;
        }
    }

    const KColorScheme selectionScheme(group, KColorScheme::ColorSet::Selection);
    const KColorScheme scheme(group, set);

    //foreground
    setTextColor(scheme.foreground(KColorScheme::NormalText).color());
    setDisabledTextColor(scheme.foreground(KColorScheme::InactiveText).color());
    setHighlightedTextColor(selectionScheme.foreground(KColorScheme::NormalText).color());
    setActiveTextColor(scheme.foreground(KColorScheme::ActiveText).color());
    setLinkColor(scheme.foreground(KColorScheme::LinkText).color());
    setVisitedLinkColor(scheme.foreground(KColorScheme::VisitedText).color());
    setNegativeTextColor(scheme.foreground(KColorScheme::NegativeText).color());
    setNeutralTextColor(scheme.foreground(KColorScheme::NeutralText).color());
    setPositiveTextColor(scheme.foreground(KColorScheme::PositiveText).color());
    

    //background
    setBackgroundColor(scheme.background(KColorScheme::NormalBackground).color());
    setHighlightColor(selectionScheme.background(KColorScheme::NormalBackground).color());

    //decoration
    setHoverColor(scheme.decoration(KColorScheme::HoverColor).color());
    setFocusColor(scheme.decoration(KColorScheme::FocusColor).color());

    QPalette pal = palette();
    static const QPalette::ColorGroup states[3] = { QPalette::Active, QPalette::Inactive, QPalette::Disabled };
    for (int i = 0; i < 3; i++) {
        QPalette::ColorGroup state = states[i];
        pal.setBrush(state, QPalette::WindowText, scheme.foreground());
        pal.setBrush(state, QPalette::Window, scheme.background());
        pal.setBrush(state, QPalette::Base, scheme.background());
        pal.setBrush(state, QPalette::Text, scheme.foreground());
        pal.setBrush(state, QPalette::Button, scheme.background());
        pal.setBrush(state, QPalette::ButtonText, scheme.foreground());
        pal.setBrush(state, QPalette::Highlight, selectionScheme.background());
        pal.setBrush(state, QPalette::HighlightedText, selectionScheme.foreground());
        pal.setBrush(state, QPalette::ToolTipBase, scheme.background());
        pal.setBrush(state, QPalette::ToolTipText, scheme.foreground());

        pal.setColor(state, QPalette::Light, scheme.shade(KColorScheme::LightShade));
        pal.setColor(state, QPalette::Midlight, scheme.shade(KColorScheme::MidlightShade));
        pal.setColor(state, QPalette::Mid, scheme.shade(KColorScheme::MidShade));
        pal.setColor(state, QPalette::Dark, scheme.shade(KColorScheme::DarkShade));
        pal.setColor(state, QPalette::Shadow, scheme.shade(KColorScheme::ShadowShade));

        pal.setBrush(state, QPalette::AlternateBase, scheme.background(KColorScheme::AlternateBackground));
        pal.setBrush(state, QPalette::Link, scheme.foreground(KColorScheme::LinkText));
        pal.setBrush(state, QPalette::LinkVisited, scheme.foreground(KColorScheme::VisitedText));
    }
    setPalette(pal);
            

    //legacy stuff
    const KColorScheme buttonScheme(QPalette::Active, KColorScheme::ColorSet::Button);
    m_buttonTextColor = buttonScheme.foreground(KColorScheme::NormalText).color();
    m_buttonBackgroundColor = buttonScheme.background(KColorScheme::NormalBackground).color();
    m_buttonHoverColor = buttonScheme.decoration(KColorScheme::HoverColor).color();
    m_buttonFocusColor = buttonScheme.decoration(KColorScheme::FocusColor).color();

    const KColorScheme viewScheme(QPalette::Active, KColorScheme::ColorSet::View);
    m_viewTextColor = viewScheme.foreground(KColorScheme::NormalText).color();
    m_viewBackgroundColor = viewScheme.background(KColorScheme::NormalBackground).color();
    m_viewHoverColor = viewScheme.decoration(KColorScheme::HoverColor).color();
    m_viewFocusColor = viewScheme.decoration(KColorScheme::FocusColor).color();

    emit colorsChanged();
}

QColor PlasmaDesktopTheme::buttonTextColor() const
{
    qWarning()<<"WARNING: buttonTextColor is deprecated, use textColor with colorSet: Theme.Button instead";
    return m_buttonTextColor;
}

QColor PlasmaDesktopTheme::buttonBackgroundColor() const
{
    qWarning()<<"WARNING: buttonBackgroundColor is deprecated, use backgroundColor with colorSet: Theme.Button instead";
    return m_buttonBackgroundColor;
}

QColor PlasmaDesktopTheme::buttonHoverColor() const
{
    qWarning()<<"WARNING: buttonHoverColor is deprecated, use backgroundColor with colorSet: Theme.Button instead";
    return m_buttonHoverColor;
}

QColor PlasmaDesktopTheme::buttonFocusColor() const
{
    qWarning()<<"WARNING: buttonFocusColor is deprecated, use backgroundColor with colorSet: Theme.Button instead";
    return m_buttonFocusColor;
}


QColor PlasmaDesktopTheme::viewTextColor() const
{
    qWarning()<<"WARNING: viewTextColor is deprecated, use backgroundColor with colorSet: Theme.View instead";
    return m_viewTextColor;
}

QColor PlasmaDesktopTheme::viewBackgroundColor() const
{
    qWarning()<<"WARNING: viewBackgroundColor is deprecated, use backgroundColor with colorSet: Theme.View instead";
    return m_viewBackgroundColor;
}

QColor PlasmaDesktopTheme::viewHoverColor() const
{
    qWarning()<<"WARNING: viewHoverColor is deprecated, use backgroundColor with colorSet: Theme.View instead";
    return m_viewHoverColor;
}

QColor PlasmaDesktopTheme::viewFocusColor() const
{
    qWarning()<<"WARNING: viewFocusColor is deprecated, use backgroundColor with colorSet: Theme.View instead";
    return m_viewFocusColor;
}

#include "moc_plasmadesktoptheme.cpp"
