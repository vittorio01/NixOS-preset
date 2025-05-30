#!/run/current-system/sw/bin/bash

## Load VM variables
source "/var/lib/libvirt/hooks/qemu.d/win11/vm-vars.conf"

## Remove Hugepages
echo "Releasing hugepage memory back to the host..."
echo 0 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages

## Advise if successful
ALLOC_PAGES=$(cat /proc/sys/vm/nr_hugepages)

if [ "$ALLOC_PAGES" -eq 0 ]
then
    echo "Memory successfully released!"
fi

sleep 1
