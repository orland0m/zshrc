#!/usr/bin/env zsh

USER_ZSHRC=~/.zshrc
SCRIPT_DIR=${0:a:h}
BASE_OH_MH_ZSH=$SCRIPT_DIR/config/transient/zshrc.ohmyzsh
TRANSIENT_ZSHRC_OVERRIDES=$SCRIPT_DIR/config/transient/zshrc.overrides

# 1. Backup whatever was already there in the system
if [ -f "$USER_ZSHRC" ]; then
    BACKUP="$USER_ZSHRC.back.$RANDOM"
    echo "Current $USER_ZSHRC will be backed up in $BACKUP"
    cp $USER_ZSHRC $BACKUP
    echo "Removing $USER_ZSHRC"
    rm $USER_ZSHRC
fi

# 2. Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# 3. Create the transient directory structure
mkdir -p $SCRIPT_DIR/config/transient
printf "#!/usr/bin/env zsh\n\n" > $TRANSIENT_ZSHRC_OVERRIDES
mv $USER_ZSHRC $BASE_OH_MH_ZSH

# 5. Main file should reference all other configurations
printf "#!/usr/bin/env zsh\n\n" > $USER_ZSHRC
printf "source $SCRIPT_DIR/config/persistent/zshrc\n" >> $USER_ZSHRC

# 6. Custom adhoc commads
hash git &>/dev/null && git config --global core.excludesfile $SCRIPT_DIR/config/persistent/gitignore_global