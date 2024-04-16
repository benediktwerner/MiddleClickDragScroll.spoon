#!/bin/sh

mkdir -p MiddleClickDragScroll.spoon release
cp init.lua README.md MiddleClickDragScroll.spoon/
zip -r release/MiddleClickDragScroll.zip MiddleClickDragScroll.spoon
rm -r MiddleClickDragScroll.spoon
