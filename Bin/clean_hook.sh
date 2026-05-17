#!/bin/bash
# Shell authon: JackA1ltman <cs2dtzq@163.com>
# Tested kernel versions: 5.4, 4.19, 4.14, 4.9, 4.4, 3.18
# 20251120

KSU_FOLDER=("drivers/kernelsu" "KernelSU" "KernelSU-Next")

KSU_CLEAN_FILES=("fs/exec.c" "fs/read_write.c" "fs/open.c" "fs/stat.c" "fs/devpts/inode.c" "fs/namei.c" "drivers/input/input.c" "drivers/tty/pty.c" "security/selinux/hooks.c" "kernel/reboot.c" "kernel/sys.c")

SUSFS_CLEAN_FILES=("security/selinux/avc.c" "kernel/kallsyms.c" "kernel/sys.c" "kernel/reboot.c" "fs/dcache.c" "fs/statfs.c" "fs/namespace.c" "fs/proc_namespace.c" "fs/stat.c" "fs/namei.c" "fs/readdir.c" "fs/exec.c" "fs/proc/task_mmu.c" "fs/proc/base.c" "fs/proc/fd.c" "fs/proc/cmdline.c" "fs/overlayfs/super.c" "fs/overlayfs/overlayfs.h" "fs/overlayfs/inode.c" "fs/overlayfs/inode.c" "fs/notify/fdinfo.c" "fs/devpts/inode.c" "include/linux/sched.h" "include/linux/mount.h")

SUSFS_REMAIN_CLEAN_FILES=("fs/susfs.c" "fs/sus_su.c" "include/linux/susfs.h" "include/linux/susfs_def.h")

# Removal of KernelSU

for file in "${KSU_FOLDER[@]}"; do
    rm -rf "${file}"

    if [ -f "${file}" ] || [ -d "${file}" ]; then
        echo "[-] Could not remove ${file}."
    else
        echo "[+] Cleaned for ${file}."
    fi
done

# Removal of KernelSU Hook

for file in "${KSU_CLEAN_FILES[@]}"; do
    sed -i '/#ifdef CONFIG_KSU/,/#endif/d' "${file}"

    if grep -q "CONFIG_KSU" "${file}"; then
        echo "[-] Could not remove KernelSU hook from ${file}."
    else
        echo "[+] Cleaned KernelSU Hook for ${file}."
    fi
done

# Removal of SuSFS
# Disabled: this kernel source repo (a32) pre-applies SUSFS with device-specific
# hand-ported hunks. Letting clean_hook strip those would re-introduce the same
# rejected-hunk problem on every CI run. KSU cleanup above stays — setup.sh
# always re-creates KSU fresh.
echo "[i] SuSFS cleanup skipped (source already SUSFS-patched in repo)."
