#!/bin/bash

export ARCH=arm64
export CROSS_COMPILE=/home/android/aarch64-linux-android-4.9/bin/aarch64-linux-android-
export ANDROID_MAJOR_VERSION=q

make exynos7570-j4lte_defconfig
make -j64
