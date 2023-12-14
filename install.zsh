#!/usr/bin/env zsh

USER_ZSHRC=~/.zshrc
SCRIPT_DIR=${0:a:h}

echo "1. Backup whatever was already there in the system"
if [ -f "$USER_ZSHRC" ]; then
    BACKUP="$USER_ZSHRC.back.$RANDOM"
    echo "Current $USER_ZSHRC will be backed up in $BACKUP"
    cp $USER_ZSHRC $BACKUP
    echo "Removing $USER_ZSHRC"
    rm $USER_ZSHRC
fi

echo "2. Install Oh My Zsh (!!! Leave inner shell on completion !!!)"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "3. Remove default OMZ configuration, already have in this repository"
rm $USER_ZSHRC

echo "5. Invoke main script in ~/.zshrc"
printf "#!/usr/bin/env zsh\n\n" > $USER_ZSHRC
printf "source $SCRIPT_DIR/config/zshrc\n" >> $USER_ZSHRC

echo "6. Custom adhoc commads"
source config/once_on_install.zsh