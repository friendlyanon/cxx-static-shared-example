#!/bin/sh -e

strip --remove-section=.comment --remove-section=.note "$@"
