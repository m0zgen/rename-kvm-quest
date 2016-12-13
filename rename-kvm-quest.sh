#!/bin/bash
# Rename KVM quest
#
# ---------------------------------------------------------- VARIABLES #
PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin

# Determine script location
SCRIPT_PATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)

# Script name
SCRIPT_NAME=`basename "$0"`

# BODY
#
DUMPED="$SCRIPT_PATH/dumped"

if [[ -z $1 ]]; then
  echo -e "\nNeed enter quest name, you can see all quest after use command - virsh list --all.\nExamle: $SCRIPT_NAME quest-name\n"
  exit 1
else
  VM="$1"
  # mkdir -p $DUMPED
  virsh dumpxml $VM > $DUMPED/$VM.xml

  read -p "Please enter new machine name: " answer

  sed -i "s/<name>$VM<\/name>/<name>$answer<\/name>/g" $DUMPED/$VM.xml
  virsh undefine $VM
  cp $DUMPED/$VM.xml /var/lib/libvirt/qemu/$answer.xml
  virsh define /var/lib/libvirt/qemu/$answer.xml
fi