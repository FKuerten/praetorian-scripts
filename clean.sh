#!/usr/bin/env bash
makeppclean
rm -rf target
for MODULE in $(ls modules) ; do
    rm -rf modules/${MODULE}/target
done
