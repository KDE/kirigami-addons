// SPDX-FileCopyrightText: 2026 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-or-later

#include "actionmenu.h"
#include "abstractkirigamiapplication.h"
#include "kirigamiactioncollection.h"

#include <algorithm>
#include <QDebug>
#include <functional>
#include <utility>

using namespace Qt::StringLiterals;

class ActionMenu::Private
{
public:
    QString name;
    QString text;
    QString iconName;
    bool menuBarVisible = true;
    QStringList actions;
    QList<QObject *> items;
    QList<ActionMenu *> menus;
    ActionMenu *parentMenu = nullptr;
    KirigamiActionCollection *collection = nullptr;
};

ActionMenu::ActionMenu(QObject *parent)
    : QObject(parent)
    , d(std::make_unique<Private>())
{
}

ActionMenu::~ActionMenu()
{
}

QString ActionMenu::name() const
{
    return d->name;
}

void ActionMenu::setName(const QString &name)
{
    if (d->name == name) {
        return;
    }
    d->name = name;
    Q_EMIT nameChanged();
    notifyMergedChanges();
}

QString ActionMenu::text() const
{
    return d->text;
}

void ActionMenu::setText(const QString &text)
{
    if (d->text == text) {
        return;
    }
    d->text = text;
    Q_EMIT textChanged();
    notifyMergedChanges();
}

QString ActionMenu::iconName() const
{
    return d->iconName;
}

void ActionMenu::setIconName(const QString &iconName)
{
    if (d->iconName == iconName) {
        return;
    }
    d->iconName = iconName;
    Q_EMIT iconNameChanged();
    notifyMergedChanges();
}

bool ActionMenu::menuBarVisible() const
{
    return d->menuBarVisible;
}

void ActionMenu::setMenuBarVisible(bool visible)
{
    if (d->menuBarVisible == visible) {
        return;
    }
    d->menuBarVisible = visible;
    Q_EMIT menuBarVisibleChanged();
}

QStringList ActionMenu::actions() const
{
    return d->actions;
}

QQmlListProperty<QObject> ActionMenu::items()
{
    return {this, nullptr, &ActionMenu::appendItem, &ActionMenu::itemCount, &ActionMenu::itemAt, &ActionMenu::clearItems};
}

void ActionMenu::setActions(const QStringList &actions)
{
    if (d->actions == actions) {
        return;
    }
    d->actions = actions;
    Q_EMIT actionsChanged();
    notifyMergedChanges();
}

KirigamiActionCollection *ActionMenu::collection() const
{
    return d->collection;
}

QObject *ActionMenu::resolveAction(const QString &name) const
{
    if (d->collection) {
        return d->collection->action(name);
    }
    return nullptr;
}

QQmlListProperty<ActionMenu> ActionMenu::menus()
{
    return {this, nullptr, &ActionMenu::appendMenu, &ActionMenu::menuCount, &ActionMenu::menuAt, &ActionMenu::clearMenus};
}

QStringList ActionMenu::mergedActions() const
{
    QStringList result;
    for (const auto &item : mergedItems()) {
        const auto itemMap = item.toMap();
        if (itemMap.value(u"type"_s).toString() == u"action"_s) {
            result.append(itemMap.value(u"name"_s).toString());
        }
    }
    return result;
}

QVariantList ActionMenu::mergedMenus() const
{
    QVariantList result;
    QStringList menuNames;
    for (const auto menu : contributingMenus()) {
        if (!menu || !menu->d->parentMenu || menu->d->parentMenu->menuPath() != menuPath() || !collection() || !menu->collection()
            || (collection()->application() != menu->collection()->application()
                || (!collection()->application() && collection() != menu->collection()))
            || menuNames.contains(menu->name())) {
            continue;
        }
        result.append(QVariant::fromValue(menu));
        menuNames.append(menu->name());
    }
    return result;
}

QVariantList ActionMenu::mergedItems() const
{
    QVariantList result;
    QStringList actionNames;
    bool lastWasSeparator = false;

    const auto appendSeparator = [&]() {
        if (!result.isEmpty() && !lastWasSeparator) {
            result.append(QVariantMap{{u"type"_s, u"separator"_s}});
            lastWasSeparator = true;
        }
    };

    for (const auto menu : contributingMenus()) {
        if (!menu || menu->menuPath() != menuPath() || !collection() || !menu->collection()
            || (collection()->application() != menu->collection()->application()
                || (!collection()->application() && collection() != menu->collection()))) {
            continue;
        }

        if (menu->d->items.isEmpty()) {
            for (const auto &action : menu->actions()) {
                if (!actionNames.contains(action)) {
                    const auto resolvedAction = menu->resolveAction(action);
                    if (!resolvedAction) {
                        continue;
                    }
                    result.append(QVariantMap{{u"type"_s, u"action"_s},
                                              {u"name"_s, action},
                                              {u"action"_s, QVariant::fromValue<QObject *>(resolvedAction)}});
                    actionNames.append(action);
                    lastWasSeparator = false;
                }
            }
            continue;
        }

        for (const auto *item : std::as_const(menu->d->items)) {
            if (!item) {
                continue;
            }
            if (item->property("separator").toBool()) {
                appendSeparator();
                continue;
            }

            const auto action = item->property("name").toString();
            if (!action.isEmpty() && !actionNames.contains(action)) {
                const auto resolvedAction = menu->resolveAction(action);
                if (!resolvedAction) {
                    continue;
                }
                result.append(QVariantMap{{u"type"_s, u"action"_s},
                                          {u"name"_s, action},
                                          {u"action"_s, QVariant::fromValue<QObject *>(resolvedAction)}});
                actionNames.append(action);
                lastWasSeparator = false;
            }
        }
    }

    if (lastWasSeparator) {
        result.removeLast();
    }
    return result;
}

void ActionMenu::classBegin()
{
}

void ActionMenu::componentComplete()
{
    for (const auto menu : contributingMenus()) {
        if (menu && menu != this && menu->menuPath() == menuPath()) {
            Q_EMIT menu->mergedActionsChanged();
            Q_EMIT menu->mergedItemsChanged();
            Q_EMIT menu->mergedMenusChanged();
        }
    }
}

void ActionMenu::appendMenu(QQmlListProperty<ActionMenu> *property, ActionMenu *menu)
{
    auto parent = static_cast<ActionMenu *>(property->object);
    if (menu && !parent->d->menus.contains(menu)) {
        parent->d->menus.append(menu);
        menu->d->parentMenu = parent;
        menu->setCollection(parent->d->collection);
        QObject::connect(menu, &ActionMenu::nameChanged, parent, [parent]() {
            Q_EMIT parent->mergedMenusChanged();
        });
        QObject::connect(menu, &ActionMenu::textChanged, parent, [parent]() {
            Q_EMIT parent->mergedMenusChanged();
        });
        QObject::connect(menu, &ActionMenu::iconNameChanged, parent, [parent]() {
            Q_EMIT parent->mergedMenusChanged();
        });
        QObject::connect(menu, &ActionMenu::menusChanged, parent, [parent]() {
            Q_EMIT parent->mergedMenusChanged();
        });
        QObject::connect(menu, &ActionMenu::mergedActionsChanged, parent, [parent]() {
            Q_EMIT parent->mergedMenusChanged();
        });
        QObject::connect(menu, &ActionMenu::mergedItemsChanged, parent, [parent]() {
            Q_EMIT parent->mergedMenusChanged();
        });
        QObject::connect(menu, &ActionMenu::mergedMenusChanged, parent, [parent]() {
            Q_EMIT parent->mergedMenusChanged();
        });
        QObject::connect(menu, &QObject::destroyed, parent, [parent, menu]() {
            parent->d->menus.removeAll(menu);
            Q_EMIT parent->menusChanged();
            Q_EMIT parent->mergedMenusChanged();
        });
        Q_EMIT parent->menusChanged();
        Q_EMIT parent->mergedMenusChanged();
    }
}

void ActionMenu::setCollection(KirigamiActionCollection *collection)
{
    if (d->collection == collection) {
        return;
    }
    d->collection = collection;
    Q_EMIT collectionChanged();
    for (auto *menu : std::as_const(d->menus)) {
        menu->setCollection(collection);
    }
}

void ActionMenu::notifyMergedChanges()
{
    const auto menus = contributingMenus();
    if (menus.isEmpty()) {
        Q_EMIT mergedActionsChanged();
        Q_EMIT mergedItemsChanged();
        Q_EMIT mergedMenusChanged();
        return;
    }
    for (auto *menu : menus) {
        Q_EMIT menu->mergedActionsChanged();
        Q_EMIT menu->mergedItemsChanged();
        Q_EMIT menu->mergedMenusChanged();
    }
}

void ActionMenu::appendItem(QQmlListProperty<QObject> *property, QObject *item)
{
    auto menu = static_cast<ActionMenu *>(property->object);
    if (!item || menu->d->items.contains(item)) {
        return;
    }
    menu->d->items.append(item);
    QObject::connect(item, &QObject::destroyed, menu, [menu, item]() {
        menu->d->items.removeAll(item);
        Q_EMIT menu->mergedItemsChanged();
        Q_EMIT menu->itemsChanged();
    });
    Q_EMIT menu->mergedItemsChanged();
    Q_EMIT menu->itemsChanged();
}

qsizetype ActionMenu::itemCount(QQmlListProperty<QObject> *property)
{
    return static_cast<ActionMenu *>(property->object)->d->items.size();
}

QObject *ActionMenu::itemAt(QQmlListProperty<QObject> *property, qsizetype index)
{
    const auto items = static_cast<ActionMenu *>(property->object)->d->items;
    return index >= 0 && index < items.size() ? items.at(index) : nullptr;
}

void ActionMenu::clearItems(QQmlListProperty<QObject> *property)
{
    auto menu = static_cast<ActionMenu *>(property->object);
    menu->d->items.clear();
    Q_EMIT menu->mergedItemsChanged();
    Q_EMIT menu->itemsChanged();
}

qsizetype ActionMenu::menuCount(QQmlListProperty<ActionMenu> *property)
{
    return static_cast<ActionMenu *>(property->object)->d->menus.size();
}

ActionMenu *ActionMenu::menuAt(QQmlListProperty<ActionMenu> *property, qsizetype index)
{
    const auto menus = static_cast<ActionMenu *>(property->object)->d->menus;
    return index >= 0 && index < menus.size() ? menus.at(index) : nullptr;
}

void ActionMenu::clearMenus(QQmlListProperty<ActionMenu> *property)
{
    auto menu = static_cast<ActionMenu *>(property->object);
    for (auto *child : std::as_const(menu->d->menus)) {
        child->d->parentMenu = nullptr;
    }
    menu->d->menus.clear();
    Q_EMIT menu->menusChanged();
    Q_EMIT menu->mergedMenusChanged();
}

QStringList ActionMenu::menuPath() const
{
    if (!d->parentMenu) {
        return {d->name};
    }

    auto path = d->parentMenu->menuPath();
    path.append(d->name);
    return path;
}

QList<ActionMenu *> ActionMenu::contributingMenus() const
{
    if (!d->collection) {
        return {};
    }

    const auto application = d->collection->application();
    QList<ActionMenu *> topLevelMenus;
    if (!application) {
        topLevelMenus = d->collection->registeredMenus();
    } else {
        for (const auto collection : application->actionCollections()) {
            topLevelMenus.append(collection->registeredMenus());
        }
    }

    QList<ActionMenu *> result;
    std::function<void(ActionMenu *)> appendMenu = [&](ActionMenu *menu) {
        if (!menu) {
            return;
        }
        result.append(menu);
        for (auto *child : std::as_const(menu->d->menus)) {
            appendMenu(child);
        }
    };
    for (auto *menu : std::as_const(topLevelMenus)) {
        appendMenu(menu);
    }
    return result;
}
