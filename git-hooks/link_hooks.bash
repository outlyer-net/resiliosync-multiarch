#!/bin/bash

SOURCE="$(realpath $(dirname "$0"))"
HOOKS="pre-commit pre-push"

for HOOK in $HOOKS; do
    ln -sf $SOURCE/$HOOK $SOURCE/../.git/hooks/
done

