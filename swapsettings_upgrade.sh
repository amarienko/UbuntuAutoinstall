#!/bin/bash
## Swap file setting changes after system autoinstall with default
## swap.img file (Ubuntu Server).
## 1.3.6
#
version="1.3.6"
#
set -e
. /lib/lsb/init-functions

swap_file="/swap.img"
sysctl_add_file="/etc/sysctl.d/90-system-swap.conf"

usage() {
    # Print short script usage
    printf "swapsettings_upgrade.sh script\n" && printf "\n"
    printf "swap file settings changes after system autoinstall\n"
    printf "\n"
    printf "Script usage: \n"
    printf "\n"
    printf "$0 [-r] [-n <btrfs>] [-c] [-u <btrfs>] [-h]\n"
    printf "\n" && printf "\t-r\tdeleting the current swap file\n"
    printf "\t-n\tcreating a new swap file (see details below on usage with 'btrfs'\n"
    printf "\t  \tfile system)\n"
    printf "\t-c\tchanging sysctl.conf options\n"
    printf "\t-u\tbatch processing: remove current swap file, creating new swap file\n"
    printf "\t  \tand adding sysctl.conf options (see details below on usage with\n"
    printf "\t  \t'btrfs' file system)\n"
    printf "\t-p\tdisplay current swap configuration and usage\n"
    printf "\t-h\tdisplay this help and exit\n"
    printf "\t-v\tprint script version\n"
    printf "\n\tbtrfs\tthe parameter is required for '-n' and '-u' options if 'btrfs'\n"
    printf "\t  \tfile system is used\n"
    printf "\n"
    printf "Examples:\n" && printf "\n"
    printf "\t$0 -p\n"
    printf "\t$0 -n btrfs\n"
    printf "\t$0 -u\n"
    printf "\n"
    printf "\n"
}

remove_swap() {
    echo "👷 Update configuration...."
    echo ""
    echo "" && echo -n "Switch Off & Remove current swap file... "
    sudo swapoff --verbose $swap_file &> /dev/null
    sudo rm $swap_file &> /dev/null
    # update /etc/fstab
    #timestamp="$(TZ=UTC date +%H%M.%Y-%m-%d@%H%M%SZ)~"
    timestamp="$(date +%H%M.%F@%T%Z)~"
    sudo cp /etc/fstab /etc/fstab.$timestamp
    # commenting fstab 'swap' line
    sudo sed -i -e "s|^[^#]*swap|#&|" /etc/fstab
    echo "[ Done ]"
    echo "The backup copy of file 'fstab' is saved in file 'fstab.$timestamp'"
    echo ""
}

new_swap() {
    btrfs=$1
    echo "🔧 Creating a new swap file...  " # removed -n
    ## File system type: https://www.tecmint.com/find-linux-filesystem-type/
    # https://linuxconfig.org/detect-filesystem-type-of-unmonted-partition
    #
    sudo truncate -s 0 $swap_file
    if $btrfs; then
        echo "Swap file will be optimized for the 'btrfs' filesystem"
	sudo chattr +C $swap_file
	sudo btrfs property set $swap_file compression none
    else
        echo "'btrfs' file system is not used"
    fi
    echo "[ 👍 Done ]"

    echo "" && echo "New swap file:"
    ls -lh $swap_file
    echo "" && echo "🔧 Swap file adjust to 2G..."
    sudo fallocate -l 2G $swap_file
    sudo chmod 600 $swap_file
    sudo mkswap $swap_file
    echo "" && echo "🧩🧩 Setting up new swap file..."
    sudo swapon --verbose $swap_file
    echo "" && echo ""
    echo "📦 New swapspace summary: "
    echo ""
    sudo swapon --summary
    echo ""
    # update /etc/fstab
    #timestamp="$(TZ=UTC date +%H%M.%Y-%m-%d@%H%M%SZ)~"
    timestamp="$(date +%H%M.%F@%T%Z)~"
    sudo cp /etc/fstab /etc/fstab.$timestamp
    # adding fstab new 'swap' file line
    printf "# File modified with script. Timestamp: $timestamp\n" | sudo tee -a /etc/fstab &> /dev/null
    printf "$swap_file\tnone\tswap\tsw\t0\t0\n" | sudo tee -a /etc/fstab &> /dev/null
    free -h && echo ""
    echo "[ 👍 Done ]"
}

sysctl_settings() {
    echo "👷 Update System Swap Settings: "
    echo "" && echo "🔧 Adjusting the Swappiness Property..."
    # Default value - 60
    sudo sysctl vm.swappiness=25
    echo "🔧 Adjusting the Cache Pressure Setting"
    # Default value - 100
    sudo sysctl vm.vfs_cache_pressure=50

    echo ""
    echo -n "🧩 /etc/sysctl.conf update....  "
    sudo cp /etc/sysctl.conf /etc/sysctl.conf.bak
    if [ -f $sysctl_add_file ]; then
	sudo rm $sysctl_add_file
    fi
    sudo touch $sysctl_add_file
    echo "" | sudo tee -a $sysctl_add_file &> /dev/null
    echo "# Adjusting the Swappiness Property" | sudo tee -a $sysctl_add_file &> /dev/null
    echo "vm.swappiness=25" | sudo tee -a $sysctl_add_file &> /dev/null
    echo "# Adjusting the Cache Pressure Setting" | sudo tee -a $sysctl_add_file &> /dev/null
    echo "vm.vfs_cache_pressure=50" | sudo tee -a $sysctl_add_file &> /dev/null
    echo "[ Done ]"
}

filesystem_param_check() {
    if [ ! -z $1 ]; then
        if [ $1 == "btrfs" ]; then
            new_swap "true"
        else
            echo "Incorrect filesystem value!"
            echo ""
            exit 1
        fi
    else
        new_swap "false"
    fi
}

print_info() {
    echo "" && echo "Current swap configuration and usage: "
    echo ""
    sudo swapon --show
    echo ""
    free -h
}

echo ""
echo "Ubuntu swap file modification..."

## Checking startup option
#
option_list="r n c u p v h"
current_option=$1
#current_option=$(awk '{ print substr( $0, 2 ) }' <<< $current_option)
#current_option=$(tr -d - <<< $current_option)
#current_option=$(sed "s/^-//" <<< $current_option)
current_option=$(sed -E "s/^.{1}//" <<< $current_option)

if [[ ! " $option_list " =~ " $current_option " ]]; then
    echo "Error: Invalid option to run '$1'"
    echo "Run $0 script with '-h' option for help."
    echo ""
fi

## Process the input options
while getopts ":rncupvh" option; do
    case $option in
        r )
            ## Remove current swap file
            echo ""
            remove_swap
            ;;
        n )
            ## New swap file
            echo "" && shift $((OPTIND -1))
            # Checking btrfs parameter and run new_swap
            filesystem_param_check $1
            ;;
        c )
            ## sysctl.conf settings update
            echo ""
            sysctl_settings
            ;;
        u )
            ## Batch processing (remove > new > sysctl)
            echo "" && shift $((OPTIND -1))
            remove_swap && echo ""
            sleep 15s
            # Checking btrfs parameter and run new_swap
            filesystem_param_check $1
            echo ""
            #
            sysctl_settings
            echo ""
            ;;
        p )
            ## Print current configuration and exit
            echo "" && print_info
            ;;
        v )
            ## Print script version
            echo "" && echo "$0"
            echo "$version"
            exit 0
            ;;
        h )
            ## Display script info & usage and exit
            echo "" && usage
            exit 0
            ;;
        \? | * )
            ## Invalid options
            echo ""
            echo "Runtime error: Invalid option or argument '-$OPTARG'"
            echo "Run $0 script with '-h' option for help." && echo ""
            exit 1
            ;;
    esac
done

echo "" && echo "✅ Operation Completed!"
echo ""

exit 0
