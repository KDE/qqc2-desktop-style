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
    IconLoaderSingleton() = default;

    KIconLoader self;
};

Q_GLOBAL_STATIC(IconLoaderSingleton, privateIconLoaderSelf)

class StyleSingleton : public QObject
{
    Q_OBJECT

public:
    struct Colors {
        QPalette palette;
        KColorScheme selectionScheme;
        KColorScheme scheme;
    };

    explicit StyleSingleton()
        : QObject()
        , buttonScheme(QPalette::Active, KColorScheme::ColorSet::Button)
        , viewScheme(QPalette::Active, KColorScheme::ColorSet::View)
    {
        connect(qGuiApp, &QGuiApplication::paletteChanged,
                this, &StyleSingleton::refresh);
    }

    void refresh()
    {
        m_cache.clear();
        buttonScheme = KColorScheme(QPalette::Active, KColorScheme::ColorSet::Button);
        viewScheme = KColorScheme(QPalette::Active, KColorScheme::ColorSet::View);

        Q_EMIT paletteChanged();
    }

    Colors loadColors(Kirigami::PlatformTheme::ColorSet cs, QPalette::ColorGroup group)
    {
        const auto key = qMakePair(cs, group);
        auto it = m_cache.constFind(key);
        if (it != m_cache.constEnd())
            return *it;

        using Kirigami::PlatformTheme;

        KColorScheme::ColorSet set;

        switch (cs) {
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

        Colors ret = {{}, KColorScheme(group, KColorScheme::ColorSet::Selection), KColorScheme(group, set)};

        QPalette pal;
        for (auto state : { QPalette::Active, QPalette::Inactive, QPalette::Disabled }) {
            pal.setBrush(state, QPalette::WindowText, ret.scheme.foreground());
            pal.setBrush(state, QPalette::Window, ret.scheme.background());
            pal.setBrush(state, QPalette::Base, ret.scheme.background());
            pal.setBrush(state, QPalette::Text, ret.scheme.foreground());
            pal.setBrush(state, QPalette::Button, ret.scheme.background());
            pal.setBrush(state, QPalette::ButtonText, ret.scheme.foreground());
            pal.setBrush(state, QPalette::Highlight, ret.selectionScheme.background());
            pal.setBrush(state, QPalette::HighlightedText, ret.selectionScheme.foreground());
            pal.setBrush(state, QPalette::ToolTipBase, ret.scheme.background());
            pal.setBrush(state, QPalette::ToolTipText, ret.scheme.foreground());

            pal.setColor(state, QPalette::Light, ret.scheme.shade(KColorScheme::LightShade));
            pal.setColor(state, QPalette::Midlight, ret.scheme.shade(KColorScheme::MidlightShade));
            pal.setColor(state, QPalette::Mid, ret.scheme.shade(KColorScheme::MidShade));
            pal.setColor(state, QPalette::Dark, ret.scheme.shade(KColorScheme::DarkShade));
            pal.setColor(state, QPalette::Shadow, ret.scheme.shade(KColorScheme::ShadowShade));

            pal.setBrush(state, QPalette::AlternateBase, ret.scheme.background(KColorScheme::AlternateBackground));
            pal.setBrush(state, QPalette::Link, ret.scheme.foreground(KColorScheme::LinkText));
            pal.setBrush(state, QPalette::LinkVisited, ret.scheme.foreground(KColorScheme::VisitedText));
        }
        ret.palette = pal;
        m_cache.insert(key, ret);
        return ret;
    }

    KColorScheme buttonScheme;
    KColorScheme viewScheme;

Q_SIGNALS:
    void paletteChanged();

private:
    QHash<QPair<Kirigami::PlatformTheme::ColorSet, QPalette::ColorGroup>, Colors> m_cache;
};
Q_GLOBAL_STATIC_WITH_ARGS(QScopedPointer<StyleSingleton>, s_style, (new StyleSingleton))

PlasmaDesktopTheme::PlasmaDesktopTheme(QObject *parent)
    : PlatformTheme(parent)
{
    setSupportsIconColoring(true);
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
    connect(qGuiApp, &QGuiApplication::fontDatabaseChanged, this, [this]() {setDefaultFont(qApp->font());});

    connect(this, &PlasmaDesktopTheme::colorSetChanged,
            this, &PlasmaDesktopTheme::syncColors);
    connect(this, &PlasmaDesktopTheme::colorGroupChanged,
            this, &PlasmaDesktopTheme::syncColors);

    connect(s_style->data(), &StyleSingleton::paletteChanged,
            this, &PlasmaDesktopTheme::syncColors);

    syncColors();
}

PlasmaDesktopTheme::~PlasmaDesktopTheme() = default;

QIcon PlasmaDesktopTheme::iconFromTheme(const QString &name, const QColor &customColor)
{
    QPalette pal = palette();
    if (customColor != Qt::transparent) {
        for (auto state : { QPalette::Active, QPalette::Inactive, QPalette::Disabled }) {
            pal.setBrush(state, QPalette::WindowText, customColor);
        }
    }

    privateIconLoaderSelf->self.setCustomPalette(pal);

    return KDE::icon(name, &privateIconLoaderSelf->self);
}

void PlasmaDesktopTheme::syncColors()
{
    QPalette::ColorGroup group = (QPalette::ColorGroup)colorGroup();
    if (m_parentItem) {
        if (!m_parentItem->isEnabled()) {
            group = QPalette::Disabled;
        //Why also checking the window is exposed?
        //in the case of QQuickWidget the window() will never be active
        //and the widgets will always have the inactive palette.
        // better to always show it active than always show it inactive
        } else if (m_parentItem->window() && !m_parentItem->window()->isActive() && m_parentItem->window()->isExposed()) {
            group = QPalette::Inactive;
        }
    }

    const auto colors = (*s_style)->loadColors(colorSet(), group);
    setPalette(colors.palette);

    //foreground
    setTextColor(colors.scheme.foreground(KColorScheme::NormalText).color());
    setDisabledTextColor(colors.scheme.foreground(KColorScheme::InactiveText).color());
    setHighlightedTextColor(colors.selectionScheme.foreground(KColorScheme::NormalText).color());
    setActiveTextColor(colors.scheme.foreground(KColorScheme::ActiveText).color());
    setLinkColor(colors.scheme.foreground(KColorScheme::LinkText).color());
    setVisitedLinkColor(colors.scheme.foreground(KColorScheme::VisitedText).color());
    setNegativeTextColor(colors.scheme.foreground(KColorScheme::NegativeText).color());
    setNeutralTextColor(colors.scheme.foreground(KColorScheme::NeutralText).color());
    setPositiveTextColor(colors.scheme.foreground(KColorScheme::PositiveText).color());


    //background
    setBackgroundColor(colors.scheme.background(KColorScheme::NormalBackground).color());
    setAlternateBackgroundColor(colors.scheme.background(KColorScheme::AlternateBackground).color());
    setHighlightColor(colors.selectionScheme.background(KColorScheme::NormalBackground).color());

    //decoration
    setHoverColor(colors.scheme.decoration(KColorScheme::HoverColor).color());
    setFocusColor(colors.scheme.decoration(KColorScheme::FocusColor).color());

    //legacy stuff
    m_buttonTextColor = (*s_style)->buttonScheme.foreground(KColorScheme::NormalText).color();
    m_buttonBackgroundColor = (*s_style)->buttonScheme.background(KColorScheme::NormalBackground).color();
    m_buttonHoverColor = (*s_style)->buttonScheme.decoration(KColorScheme::HoverColor).color();
    m_buttonFocusColor = (*s_style)->buttonScheme.decoration(KColorScheme::FocusColor).color();

    m_viewTextColor = (*s_style)->viewScheme.foreground(KColorScheme::NormalText).color();
    m_viewBackgroundColor = (*s_style)->viewScheme.background(KColorScheme::NormalBackground).color();
    m_viewHoverColor = (*s_style)->viewScheme.decoration(KColorScheme::HoverColor).color();
    m_viewFocusColor = (*s_style)->viewScheme.decoration(KColorScheme::FocusColor).color();

    emit colorsChanged();
}

QColor PlasmaDesktopTheme::buttonTextColor() const
{
    qWarning() << "WARNING: buttonTextColor is deprecated, use textColor with colorSet: Theme.Button instead";
    return m_buttonTextColor;
}

QColor PlasmaDesktopTheme::buttonBackgroundColor() const
{
    qWarning() << "WARNING: buttonBackgroundColor is deprecated, use backgroundColor with colorSet: Theme.Button instead";
    return m_buttonBackgroundColor;
}

QColor PlasmaDesktopTheme::buttonHoverColor() const
{
    qWarning() << "WARNING: buttonHoverColor is deprecated, use backgroundColor with colorSet: Theme.Button instead";
    return m_buttonHoverColor;
}

QColor PlasmaDesktopTheme::buttonFocusColor() const
{
    qWarning() << "WARNING: buttonFocusColor is deprecated, use backgroundColor with colorSet: Theme.Button instead";
    return m_buttonFocusColor;
}


QColor PlasmaDesktopTheme::viewTextColor() const
{
    qWarning()<<"WARNING: viewTextColor is deprecated, use backgroundColor with colorSet: Theme.View instead";
    return m_viewTextColor;
}

QColor PlasmaDesktopTheme::viewBackgroundColor() const
{
    qWarning() << "WARNING: viewBackgroundColor is deprecated, use backgroundColor with colorSet: Theme.View instead";
    return m_viewBackgroundColor;
}

QColor PlasmaDesktopTheme::viewHoverColor() const
{
    qWarning() << "WARNING: viewHoverColor is deprecated, use backgroundColor with colorSet: Theme.View instead";
    return m_viewHoverColor;
}

QColor PlasmaDesktopTheme::viewFocusColor() const
{
    qWarning() << "WARNING: viewFocusColor is deprecated, use backgroundColor with colorSet: Theme.View instead";
    return m_viewFocusColor;
}

#include "plasmadesktoptheme.moc"
