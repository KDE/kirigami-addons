#! /bin/sh
#SPDX-FileCopyrightText: 2021 Carl Schwan <carl@carlschwan.eu>
#SPDX-License-Identifier: LGPL-2.0-or-later
$XGETTEXT `find . -name \*.cpp -o -name \*.h -o -name \*.qml` -o $podir/kirigami-addons6.pot
