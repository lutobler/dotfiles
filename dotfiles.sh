#!/usr/bin/env bash

# Format "<source file relative to $PWD>, <target file relative to $HOME>"
# If a directory, a target directory will be created and everything in the
# source symlinked into it.
readonly sources=(
    "config/dunst, .config/dunst"
    "config/nvim, .config/nvim"
    "config/herbstluftwm, .config/herbstluftwm"
    "config/redshift.conf, .config/redshift.conf"
    "bash.d, bash.d"
    ".bashrc, .bashrc"
    ".bash_profile, .bash_profile"
    ".xinitrc, .xinitrc"
    ".Xresources, .Xresources"
    ".xserverrc, .xserverrc"
)

readonly fg_red="$(tput setaf 1)"
readonly fg_green="$(tput setaf 2)"
readonly reset="$(tput sgr0)"

die() {
    printf "Usage: \
            \n  help        print this help message \
            \n  deploy      set up the symlinks and execute a check \
            \n  check       check if the symlinks are set up correctly\n"

    [[ -n "$1" ]] && printf "\nError: $1\n"
    exit $2
}

[[ -n "$1" ]] || die "Argument required" 1

# $1: source, $2: target
check_link() {
    s="$1"
    t="$2"
    if [[ -L "$t" ]]; then
        if [[ "$(realpath $t)" == "$s" ]]; then
            echo "$fg_green    Symlink $t is correct $reset"
        else
            echo "$fg_red    Symlink $t exists, but is invalid $reset"
        fi
    else
        echo "$fg_red    Symlink $t doesn't exist $reset"
    fi
}

# $1: an element of the sources array
check_source() {
    IFS=', ' read -ra tupel <<< "$1"
    src=${tupel[0]}
    target=${tupel[1]}
    src_abs="$PWD/$src"
    target_abs="$HOME/$target"
    echo "CHECK: $target_abs -> $src_abs"

    # source is directory
    if [[ -d "$src_abs" ]]; then
        if [[ -d "$target_abs" ]]; then
            echo "$fg_green    Target directory $target_abs exists $reset"
        else
            echo "$fg_red    Target directory $target_abs doesn't exists $reset"
        fi

        # get the source files with a wildcard (absolute paths)
        src_files=( $(echo "$src_abs/*") )

        # create array of target links
        target_links=()
        for (( i=0; i < ${#src_files[@]}; i += 1 )); do
            target_links[$i]=$target_abs/$(basename "${src_files[$i]}")
        done

        for (( i=0; i < ${#src_files[@]}; i += 1 )); do
            check_link "${src_files[$i]}" "${target_links[$i]}"
        done

    # source is regular file
    else
        check_link "$src_abs" "$target_abs"
    fi

    echo
}

check_all() {
    for i in "${sources[@]}"; do
        check_source "$i"
    done
}

deploy_all() {
    for i in "${sources[@]}"; do
        IFS=', ' read -ra tupel <<< "$i"
        src=${tupel[0]}
        target=${tupel[1]}
        src_abs="$PWD/$src"
        target_abs="$HOME/$target"

        # source is directory
        if [[ -d "$src_abs" ]]; then
            [[ -d "$target_abs" ]] || mkdir -p "$(dirname $target_abs)"

            src_files=( $(echo "$src_abs/*") )
            target_links=()
            for (( i=0; i < ${#src_files[@]}; i += 1 )); do
                target_links[$i]=$target_abs/$(basename "${src_files[$i]}")
            done

            for (( i=0; i < ${#src_files[@]}; i += 1 )); do
                ln -sf "${src_files[$i]}" "${target_links[$i]}"
            done

        # source is regular file
        else
            echo "SYMLINK $target_abs -> $src_abs"
            ln -sf "$src_abs" "$target_abs"
        fi
    done
}

case "$1" in
    deploy)
        echo "Deploying dotfiles ..."
        deploy_all
        echo
        echo "Executing checks ..."
        check_all
        ;;
    check)
        echo "Executing checks ..."
        echo
        check_all
        ;;
    *)
        die "Unknown argument" 1
        ;;
esac
