  #!/bin/bash
#
# PhantomKernel script
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software

# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Main Dir
CR_DIR=$(pwd)
# Define toolchan path
CR_TC=/home/android/too/aarch64-linux-android-4.9-kernel/bin/aarch64-linux-android-
# Define proper arch and dir for dts files
CR_DTS=arch/arm64/boot/dts
# Define boot.img out dir
CR_OUT=$CR_DIR/PHANTOM/Out
CR_PRODUCT=$CR_DIR/PHANTOM/Product
# DTS 
CR_MDTJ5=$CR_DIR/PHANTOM/MakefileJ5
CR_MDTJ4=$CR_DIR/PHANTOM/MakefileJ4
CR_MDTJ3=$CR_DIR/PHANTOM/MakefileJ3
CR_MDTJ2=$CR_DIR/PHANTOM/MakefileJ2
# Presistant A.I.K Location
CR_AIK=$CR_DIR/PHANTOM/A.I.K
# Main Ramdisk Location
CR_RAMDISK=$CR_DIR/PHANTOM/universal7570
# Compiled image name and location (Image/zImage)
CR_KERNEL=$CR_DIR/arch/arm64/boot/Image
# Compiled dtb by dtbtool
CR_DTB=$CR_DIR/boot.img-dtb
# Kernel Name and Version
CR_VERSION=V1
CR_NAME=PhantomKernel
# Thread count
CR_JOBS=$(nproc --all)
# Target android version and platform (7/n/8/o/9/p)
CR_ANDROID=q
CR_PLATFORM=10.0.0
# Target ARCH
CR_ARCH=arm64
# Init build
export CROSS_COMPILE=$CR_TC
# General init
export ANDROID_MAJOR_VERSION=$CR_ANDROID
export PLATFORM_VERSION=$CR_PLATFORM
export $CR_ARCH
##########################################
# Device specific Variables [SM-G570X]
CR_DTSFILES_G570X="exynos7570-on5xelte_swa_open_00.dtb exynos7570-on5xelte_swa_open_01.dtb exynos7570-on5xelte_swa_open_02.dtb exynos7570-on5xelte_swa_open_03.dtb"
CR_CONFG_G570X=exynos7570-on5xelte_defconfig
CR_VARIANT_G570X=G570X
# Device specific Variables [SM-J330]
CR_DTSFILES_J330X="exynos7570-j3y17lte_eur_open_00.dtb exynos7570-j3y17lte_eur_open_01.dtb exynos7570-j3y17lte_eur_open_02.dtb exynos7570-j3y17lte_eur_open_03.dtb exynos7570-j3y17lte_eur_open_05.dtb exynos7570-j3y17lte_eur_open_07.dtb"
CR_CONFG_J330X=exynos7570-j3y17lte_defconfig
CR_VARIANT_J330X=J330X
# Device specific Variables [SM-G390X]
CR_DTSFILES_G390X="exynos7570-j7y17lte_eur_open_00.dtb exynos7570-j7y17lte_eur_open_01.dtb exynos7570-j7y17lte_eur_open_02.dtb exynos7570-j7y17lte_eur_open_03.dtb exynos7570-j7y17lte_eur_open_04.dtb exynos7570-j7y17lte_eur_open_05.dtb exynos7570-j7y17lte_eur_open_06.dtb exynos7570-j7y17lte_eur_open_07.dtb"
CR_CONFG_G390X=exynos7570-j7y17lte_defconfig
CR_VARIANT_G390X=G390X
# Device specific Variables [SM-J400X]
CR_DTSFILES_J400X="exynos7570-j4lte_ltn_00.dtb exynos7570-j4lte_ltn_02.dtb"
CR_CONFG_J400X=exynos7570-j4lte_defconfig
CR_VARIANT_J400X=J400X
# Device specific Variables [SM-J260X]
CR_DTSFILES_J260X="exynos7570-j2corelte_eur_open_00.dtb exynos7570-j2corelte_eur_open_01.dtb exynos7570-j2corelte_eur_open_02.dtb exynos7570-j2corelte_eur_open_03.dtb"
CR_CONFG_J260X=exynos7570-j2corelte_defconfig
CR_VARIANT_J260X=J260X
# Common configs
CR_CONFIG_AOSP=exynos7570-aosp_defconfig
CR_CONFIG_ONEUI=exynos7570-oneui_defconfig
CR_CONFIG_SPLIT=NULL
CR_CONFIG_PHANTOM=exynos7570-phantom_defconfig
# Prefixes
CR_ROOT="0"
CR_PERMISSIVE="0"
CR_HALLIC="0"
# Flashable Variables
FL_MODEL=NULL
FL_VARIANT=NULL
FL_DIR=$CR_DIR/PHANTOM/Flashable
FL_EXPORT=$CR_DIR/PHANTOM/Flashable_OUT
FL_SCRIPT=$FL_EXPORT/META-INF/com/google/android/updater-script
#####################################################

# Script functions

read -p "Clean source (y/n) > " yn
if [ "$yn" = "Y" -o "$yn" = "y" ]; then
     echo "Clean Build"
     CR_CLEAN="1"
else
     echo "Dirty Build"
     CR_CLEAN="0"
fi

# AOSP / OneUI
read -p "Variant? (1 (oneUI) | 2 (AOSP) > " aud
if [ "$aud" = "AOSP" -o "$aud" = "2" ]; then
     echo "Build AOSP Variant"
     CR_MODE="2"
     CR_PERMISSIVE="1"
else
     echo "Build OneUI Variant"
     CR_MODE="1"
     CR_HALLIC="1"
     CR_PERMISSIVE="1"
fi

# Options
#read -p "Kernel SU? (y/n) > " yn
#if [ "$yn" = "Y" -o "$yn" = "y" ]; then
#     echo " WARNING : KernelSU Enabled!"
#     export CONFIG_ASSISTED_SUPERUSER=y
#     CR_ROOT="1"
#fi
#  if [ $CR_HALLIC = "1" ]; then
#    echo " Inverting HALL_IC Status"
#    echo "CONFIG_HALL_EVENT_REVERSE=y" >> $CR_DIR/arch/$CR_ARCH/configs/tmp_defconfig
#  fi

BUILD_CLEAN()
{
if [ $CR_CLEAN = 1 ]; then
     echo " "
     echo " Cleaning build dir"
     make clean && make mrproper
     rm -r -f $CR_DTB
     rm -rf $CR_DTS/.*.tmp
     rm -rf $CR_DTS/.*.cmd
     rm -rf $CR_DTS/*.dtb
     rm -rf $CR_DIR/.config
     rm -rf $CR_DTS/exynos7570.dtsi
     rm -rf $CR_OUT/*.img
     rm -rf $CR_OUT/*.zip
fi
if [ $CR_CLEAN = 0 ]; then
     echo " "
     echo " Skip Full cleaning"
     rm -r -f $CR_DTB
     rm -rf $CR_DTS/.*.tmp
     rm -rf $CR_DTS/.*.cmd
     rm -rf $CR_DTS/*.dtb
     rm -rf $CR_DIR/.config
     rm -rf $CR_DTS/exynos7570.dtsi
fi
}

BUILD_ROOT()
{
if [ $CR_ROOT = 1 ]; then
     echo " "
     echo " WARNING : KernelSU Enabled!"
fi
}

BUILD_IMAGE_NAME()
{
	CR_IMAGE_NAME=$CR_NAME-$CR_VERSION-$CR_VARIANT

  # Flashable_script
  if [ $CR_VARIANT = $CR_VARIANT_G570X-AOSP ]; then
    FL_VARIANT="G570X-AOSP"
    FL_MODEL=on5xelte
  fi
  if [ $CR_VARIANT = $CR_VARIANT_G570X-ONEUI ]; then
    FL_VARIANT="G570X-OneUI"
    FL_MODEL=on5xelte
  fi
  if [ $CR_VARIANT = $CR_VARIANT_J330X-AOSP ]; then
    FL_VARIANT="J330X-AOSP"
    FL_MODEL=j3y17lte
  fi
  if [ $CR_VARIANT = $CR_VARIANT_J330X-ONEUI ]; then
    FL_VARIANT="J330X-OneUI"
    FL_MODEL=j3y17lte
  fi
  if [ $CR_VARIANT = $CR_VARIANT_G390X-AOSP ]; then
    FL_VARIANT="G390X-AOSP"
    FL_MODEL=j7y17lte
  fi
  if [ $CR_VARIANT = $CR_VARIANT_G390X-ONEUI ]; then
    FL_VARIANT="G390X-OneUI"
    FL_MODEL=j7y17lte
  fi
  if [ $CR_VARIANT = $CR_VARIANT_J400X-AOSP ]; then
    FL_VARIANT="J400X-AOSP"
    FL_MODEL=j4lte
  fi
  if [ $CR_VARIANT = $CR_VARIANT_J400X-ONEUI ]; then
    FL_VARIANT="J400X-OneUI"
    FL_MODEL=j4lte
  fi
  if [ $CR_VARIANT = $CR_VARIANT_J260X-AOSP ]; then
    FL_VARIANT="J260X-AOSP"
    FL_MODEL=j2corelte
  fi
  if [ $CR_VARIANT = $CR_VARIANT_J260X-ONEUI ]; then
    FL_VARIANT="J260X-OneUI"
    FL_MODEL=j2corelte
  fi
}

BUILD_GENERATE_CONFIG()
{
  # Only use for devices that are unified with 2 or more configs
  echo "----------------------------------------------"
	echo " "
	echo "Building defconfig for $CR_VARIANT"
  echo " "
  # Respect CLEAN build rules
  BUILD_CLEAN
  if [ -e $CR_DIR/arch/$CR_ARCH/configs/tmp_defconfig ]; then
    echo " cleanup old configs "
    rm -rf $CR_DIR/arch/$CR_ARCH/configs/tmp_defconfig
  fi
  echo " Copy $CR_CONFIG "
  cp -f $CR_DIR/arch/$CR_ARCH/configs/$CR_CONFIG $CR_DIR/arch/$CR_ARCH/configs/tmp_defconfig
  if [ $CR_CONFIG_SPLIT = NULL ]; then
    echo " No split config support! "
  else
    echo " Copy $CR_CONFIG_SPLIT "
    cat $CR_DIR/arch/$CR_ARCH/configs/$CR_CONFIG_SPLIT >> $CR_DIR/arch/$CR_ARCH/configs/tmp_defconfig
  fi
  if [ $CR_MODE = 2 ]; then
    echo " Copy $CR_CONFIG_USB "
    cat $CR_DIR/arch/$CR_ARCH/configs/$CR_CONFIG_USB >> $CR_DIR/arch/$CR_ARCH/configs/tmp_defconfig
  fi
  if [ $CR_MODE = 1 ]; then
    echo " Copy $CR_CONFIG_USB "
    cat $CR_DIR/arch/$CR_ARCH/configs/$CR_CONFIG_USB >> $CR_DIR/arch/$CR_ARCH/configs/tmp_defconfig
  fi
  echo " Copy $CR_CONFIG_PHANTOM "
  cat $CR_DIR/arch/$CR_ARCH/configs/$CR_CONFIG_PHANTOM >> $CR_DIR/arch/$CR_ARCH/configs/tmp_defconfig
  echo " Set $CR_VARIANT to generated config "
  CR_CONFIG=tmp_defconfig
}

BUILD_OUT()
{
    echo " "
    echo "----------------------------------------------"
    echo "$CR_VARIANT kernel build finished."
    echo "Compiled DTB Size = $sizdT Kb"
    echo "Kernel Image Size = $sizT Kb"
    echo "Boot Image   Size = $sizkT Kb"
    echo "Image Generated at $CR_PRODUCT/$CR_IMAGE_NAME.img"
    echo "Zip Generated at $CR_PRODUCT/$CR_NAME-$CR_VERSION-$FL_VARIANT.zip"
    echo "Press Any key to end the script"
    echo "----------------------------------------------"
}

BUILD_ZIMAGE()
{
	cp $CR_COMP $CR_DIR/arch/arm64/boot/dts/Makefile
	echo "----------------------------------------------"
	echo " "
	echo "Building zImage for $CR_VARIANT"
	export LOCALVERSION=-$CR_IMAGE_NAME
	echo "Make $CR_CONFIG"
	make $CR_CONFIG
	make -j$CR_JOBS
	if [ ! -e $CR_KERNEL ]; then
	exit 0;
	echo "Image Failed to Compile"
	echo " Abort "
	fi
    du -k "$CR_KERNEL" | cut -f1 >sizT
    sizT=$(head -n 1 sizT)
    rm -rf sizT
	echo " "
	echo "----------------------------------------------"
}
BUILD_DTB()
{
	echo "----------------------------------------------"
	echo " "
	echo "Building DTB for $CR_VARIANT"
	# This source compiles dtbs while doing Image
	./scripts/dtbtool_exynos/dtbTool -o $CR_DTB -d $CR_DTS/ -s 2048
	if [ ! -e $CR_DTB ]; then
    exit 0;
    echo "DTB Failed to Compile"
    echo " Abort "
	fi
	rm -rf $CR_DTS/.*.tmp
	rm -rf $CR_DTS/.*.cmd
	rm -rf $CR_DTS/*.dtb
  rm -rf $CR_DTS/exynos7570.dtsi
    du -k "$CR_DTB" | cut -f1 >sizdT
    sizdT=$(head -n 1 sizdT)
    rm -rf sizdT
	echo " "
	echo "----------------------------------------------"
}
PACK_BOOT_IMG()
{
	echo "----------------------------------------------"
	echo " "
	echo "Building Boot.img for $CR_VARIANT"
	# Copy Ramdisk
	cp -rf $CR_RAMDISK/* $CR_AIK
	# Move Compiled kernel and dtb to A.I.K Folder
	mv $CR_KERNEL $CR_AIK/split_img/boot.img-zImage
	mv $CR_DTB $CR_AIK/split_img/boot.img-dtb
	# Create boot.img
	$CR_AIK/repackimg.sh
	# Remove red warning at boot
	echo -n "SEANDROIDENFORCE" » $CR_AIK/image-new.img
  # Copy boot.img to Production folder
	cp $CR_AIK/image-new.img $CR_PRODUCT/$CR_IMAGE_NAME.img
	# Move boot.img to out dir
	mv $CR_AIK/image-new.img $CR_OUT/$CR_IMAGE_NAME.img
	du -k "$CR_OUT/$CR_IMAGE_NAME.img" | cut -f1 >sizkT
	sizkT=$(head -n 1 sizkT)
	rm -rf sizkT
	echo " "
	$CR_AIK/cleanup.sh
}

PACK_FLASHABLE()
{

  echo "----------------------------------------------"
  echo "$CR_NAME $CR_VERSION Flashable Generator"
  echo "----------------------------------------------"
	echo " "
	echo " Target device : $CR_VARIANT "
  echo " Target image $CR_OUT/$CR_IMAGE_NAME.img "
  echo " Prepare Temporary Dirs"
  FL_DEVICE=$FL_EXPORT/PHANTOM/device/$FL_MODEL/boot.img
  echo " Copy $FL_DIR to $FL_EXPORT"
  rm -rf $FL_EXPORT
  mkdir $FL_EXPORT
  cp -rf $FL_DIR/* $FL_EXPORT
  echo " Generate updater for $FL_VARIANT"
  sed -i 's/FL_NAME/ui_print("* '$CR_NAME'");/g' $FL_SCRIPT
  sed -i 's/FL_VERSION/ui_print("* '$CR_VERSION'");/g' $FL_SCRIPT
  sed -i 's/FL_VARIANT/ui_print("* For '$FL_VARIANT' ");/g' $FL_SCRIPT
  echo " Copy Image to $FL_DEVICE"
  cp $CR_OUT/$CR_IMAGE_NAME.img $FL_DEVICE
  echo " Packing zip"
  # TODO: FInd a better way to zip
  # TODO: support multi-compile
  # TODO: Conditional
  cd $FL_EXPORT
  zip -r $CR_OUT/$CR_NAME-$CR_VERSION-$FL_VARIANT.zip .
  cd $CR_DIR
  rm -rf $FL_EXPORT
  # Copy zip to production
  cp $CR_OUT/$CR_NAME-$CR_VERSION-$FL_VARIANT.zip $CR_PRODUCT
  # Move out dir to BUILD_OUT
  # Respect CLEAN build rules
  BUILD_CLEAN
}

# Main Menu
clear
echo "----------------------------------------------"
echo "$CR_NAME $CR_VERSION Build Script"
echo "----------------------------------------------"
PS3='Please select your option (1-10): '
menuvar=("SM-G570X" "SM-J330X" "SM-G390X" "SM-J710X" "SM-J701X" "SM-G610X" "SM-J400X" "SM-J260X" "Build_All" "Exit")
select menuvar in "${menuvar[@]}"
do
    case $menuvar in
        "SM-G570X")
            clear
            echo "Starting $CR_VARIANT_G570X kernel build..."
            CR_CONFIG=$CR_CONFG_G570X
            CR_DTSFILES=$CR_DTSFILES_G570X
            CR_COMP=$CR_MDTJ5
            if [ $CR_MODE = "2" ]; then
              echo " Building AOSP variant "
              CR_CONFIG_USB=$CR_CONFIG_AOSP
              CR_VARIANT=$CR_VARIANT_G570X-AOSP
              CR_RAMDISK=$CR_RAMDISK
            else
              echo " Building OneUI variant "
              CR_CONFIG_USB=$CR_CONFIG_ONEUI
              CR_VARIANT=$CR_VARIANT_G570X-ONEUI
              CR_RAMDISK=$CR_RAMDISK
            fi
            BUILD_IMAGE_NAME
            BUILD_GENERATE_CONFIG
            BUILD_ZIMAGE
            BUILD_DTB
            PACK_BOOT_IMG
            BUILD_ROOT
            PACK_FLASHABLE
            BUILD_OUT
            read -n1 -r key
            break
            ;;
        "SM-J330X")
            clear
            echo "Starting $CR_VARIANT_J330X kernel build..."
            CR_CONFIG=$CR_CONFG_J330X
            CR_DTSFILES=$CR_DTSFILES_J330X
            CR_COMP=$CR_MDTJ3
            if [ $CR_MODE = "2" ]; then
              echo " Building AOSP variant "
              CR_CONFIG_USB=$CR_CONFIG_AOSP
              CR_VARIANT=$CR_VARIANT_J330X-AOSP
              CR_RAMDISK=$CR_RAMDISK
            else
              echo " Building OneUI variant "
              CR_CONFIG_USB=$CR_CONFIG_ONEUI
              CR_VARIANT=$CR_VARIANT_J330X-ONEUI
              CR_RAMDISK=$CR_RAMDISK
            fi
            BUILD_IMAGE_NAME
            BUILD_GENERATE_CONFIG
            BUILD_ZIMAGE
            BUILD_DTB
            PACK_BOOT_IMG
            BUILD_ROOT
            PACK_FLASHABLE
            BUILD_OUT
            read -n1 -r key
            break
            ;;
        "SM-G390X")
            clear
            echo "Starting $CR_VARIANT_G390X kernel build..."
            CR_VARIANT=$CR_VARIANT_G390X
            CR_COMP=$CR_MDTX4
            CR_CONFIG=$CR_CONFG_G390X
            CR_DTSFILES=$CR_DTSFILES_G390X
            if [ $CR_MODE = "2" ]; then
              echo " Building AOSP variant "
              CR_CONFIG_USB=$CR_CONFIG_AOSP
              CR_VARIANT=$CR_VARIANT_G390X-AOSP
              CR_RAMDISK=$CR_RAMDISK
            else
              echo " Building OneUI variant "
              CR_CONFIG_USB=$CR_CONFIG_ONEUI
              CR_VARIANT=$CR_VARIANT_G390X-ONEUI
              CR_RAMDISK=$CR_RAMDISK
            fi
            BUILD_IMAGE_NAME
            BUILD_GENERATE_CONFIG
            BUILD_ZIMAGE
            BUILD_DTB
            PACK_BOOT_IMG
            BUILD_ROOT
            PACK_FLASHABLE
            BUILD_OUT
            read -n1 -r key
            break
            ;;
        "SM-J400X")
            clear
            echo "Starting $CR_VARIANT_J400X kernel build..."
            CR_DTSFILES=$CR_DTSFILES_J400X
            CR_RAMDISK=$CR_RAMDISK
            CR_CONFIG=$CR_CONFG_J400X
            CR_COMP=$CR_MDTJ4
            export ANDROID_MAJOR_VERSION=$CR_ANDROID
            export PLATFORM_VERSION=$CR_PLATFORM
            if [ $CR_MODE = "2" ]; then
              echo " Building AOSP variant "
              CR_CONFIG_USB=$CR_CONFIG_AOSP
              CR_VARIANT=$CR_VARIANT_J400X-AOSP
            else
              echo " Building OneUI variant "
              CR_CONFIG_USB=$CR_CONFIG_ONEUI
              CR_VARIANT=$CR_VARIANT_J400X-ONEUI
            fi
            BUILD_IMAGE_NAME
            BUILD_GENERATE_CONFIG
            BUILD_ZIMAGE
            BUILD_DTB
            PACK_BOOT_IMG
            BUILD_ROOT
            PACK_FLASHABLE
            BUILD_OUT
            read -n1 -r key
            break
            ;;
        "SM-J260X")
            clear
            echo "Starting $CR_VARIANT_J260X kernel build..."
            CR_DTSFILES=$CR_DTSFILES_J260X
            CR_RAMDISK=$CR_RAMDISK
            CR_CONFIG=$CR_CONFG_J260X
            CR_COMP=$CR_MDTJ52
            export ANDROID_MAJOR_VERSION=$CR_ANDROID
            export PLATFORM_VERSION=$CR_PLATFORM
            if [ $CR_MODE = "2" ]; then
              echo " Building AOSP variant "
              CR_CONFIG_USB=$CR_CONFIG_AOSP
              CR_VARIANT=$CR_VARIANT_J260X-AOSP
            else
              echo " Building OneUI variant "
              CR_CONFIG_USB=$CR_CONFIG_ONEUI
              CR_VARIANT=$CR_VARIANT_J260X-ONEUI
            fi
            BUILD_IMAGE_NAME
            BUILD_GENERATE_CONFIG
            BUILD_ZIMAGE
            BUILD_DTB
            PACK_BOOT_IMG
            BUILD_ROOT
            PACK_FLASHABLE
            BUILD_OUT
            read -n1 -r key
            break
            ;;
        "Build_All")
            echo "Starting $CR_VARIANT_G570X kernel build..."
            CR_CONFIG=$CR_CONFG_G570X
            CR_DTSFILES=$CR_DTSFILES_G570X
            CR_COMP=$CR_MDTJ5
            if [ $CR_MODE = "2" ]; then
              echo " Building AOSP variant "
              CR_CONFIG_USB=$CR_CONFIG_AOSP
              CR_VARIANT=$CR_VARIANT_G570X-AOSP
              CR_RAMDISK=$CR_RAMDISK
            else
              echo " Building OneUI variant "
              CR_CONFIG_USB=$CR_CONFIG_ONEUI
              CR_VARIANT=$CR_VARIANT_G570X-ONEUI
              CR_RAMDISK=$CR_RAMDISK
            fi
            BUILD_IMAGE_NAME
            BUILD_GENERATE_CONFIG
            BUILD_ZIMAGE
            BUILD_DTB
            PACK_BOOT_IMG
            BUILD_ROOT
            PACK_FLASHABLE
            BUILD_OUT
            echo "Starting $CR_VARIANT_J330X kernel build..."
            CR_CONFIG=$CR_CONFG_J330X
            CR_DTSFILES=$CR_DTSFILES_J330X
            CR_COMP=$CR_MDTJ3
            if [ $CR_MODE = "2" ]; then
              echo " Building AOSP variant "
              CR_CONFIG_USB=$CR_CONFIG_AOSP
              CR_VARIANT=$CR_VARIANT_J330X-AOSP
              CR_RAMDISK=$CR_RAMDISK
            else
              echo " Building OneUI variant "
              CR_CONFIG_USB=$CR_CONFIG_ONEUI
              CR_VARIANT=$CR_VARIANT_J330X-ONEUI
              CR_RAMDISK=$CR_RAMDISK
            fi
            BUILD_IMAGE_NAME
            BUILD_GENERATE_CONFIG
            BUILD_ZIMAGE
            BUILD_DTB
            PACK_BOOT_IMG
            BUILD_ROOT
            PACK_FLASHABLE
            BUILD_OUT
            echo "Starting $CR_VARIANT_J400X kernel build..."
            CR_DTSFILES=$CR_DTSFILES_J400X
            CR_RAMDISK=$CR_RAMDISK
            CR_CONFIG=$CR_CONFG_J400X
            CR_COMP=$CR_MDTJ4
            # Build Oreo WiFi HAL
            export ANDROID_MAJOR_VERSION=$CR_ANDROID
            export PLATFORM_VERSION=$CR_PLATFORM
            if [ $CR_MODE = "2" ]; then
              echo " Building AOSP variant "
              CR_CONFIG_USB=$CR_CONFIG_AOSP
              CR_VARIANT=$CR_VARIANT_J400X-AOSP
            else
              echo " Building OneUI variant "
              CR_CONFIG_USB=$CR_CONFIG_ONEUI
              CR_VARIANT=$CR_VARIANT_J400X-ONEUI
            fi
            BUILD_IMAGE_NAME
            BUILD_GENERATE_CONFIG
            BUILD_ZIMAGE
            BUILD_DTB
            PACK_BOOT_IMG
            BUILD_ROOT
            PACK_FLASHABLE
            BUILD_OUT
            echo "Starting $CR_VARIANT_J260X kernel build..."
            CR_DTSFILES=$CR_DTSFILES_J260X
            CR_RAMDISK=$CR_RAMDISK
            CR_CONFIG=$CR_CONFG_J260X
            CR_COMP=$CR_MDTJ2
            # Build Oreo WiFi HAL
            export ANDROID_MAJOR_VERSION=$CR_ANDROID
            export PLATFORM_VERSION=$CR_PLATFORM
            if [ $CR_MODE = "2" ]; then
              echo " Building AOSP variant "
              CR_CONFIG_USB=$CR_CONFIG_AOSP
              CR_VARIANT=$CR_VARIANT_J260X-AOSP
            else
              echo " Building OneUI variant "
              CR_CONFIG_USB=$CR_CONFIG_ONEUI
              CR_VARIANT=$CR_VARIANT_J260X-ONEUI
            fi
            BUILD_IMAGE_NAME
            BUILD_GENERATE_CONFIG
            BUILD_ZIMAGE
            BUILD_DTB
            PACK_BOOT_IMG
            BUILD_ROOT
            PACK_FLASHABLE
            BUILD_OUT
            echo " "
            echo " "
            echo " compilation finished "
            echo " Targets at $CR_OUT"
            echo " "
            echo "Press Any key to end the script"
            echo "----------------------------------------------"
            read -n1 -r key
            break
            ;;
        "Exit")
            break
            ;;
        *) echo Invalid option.;;
    esac
done
