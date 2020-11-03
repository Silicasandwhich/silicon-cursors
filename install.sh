#!/usr/bin/env bash

show_question() {
  echo -e "\033[1;34m$@\033[0m"
}

show_dir() {
  echo -e "\033[1;32m$@\033[0m"
}

show_error() {
  echo -e "\033[1;31m$@\033[0m"
}

end() {
  echo -e "\nExiting...\n"
  exit 0
}

continue() {
  show_question "\nDo you want to continue? (Y)es, (N)o : \n"
  read INPUT
  case $INPUT in
    [Yy]* ) ;;
    [Nn]* ) end;;
    * ) show_error "\nSorry, try again."; continue;;
  esac
}

replace() {
  show_question "\nFound an existing installation. Replace it? (Y)es, (N)o :\n" 
  read INPUT
  case $INPUT in
    [Yy]* ) rm -rf "$@/Silicon_*" 2>/dev/null;;
    [Nn]* ) ;;
    * ) show_error "\tSorry, try again."; replace $@;;
  esac
}

install() {

  # PREVIEW

  # Show destination directory
  echo -e "\nsilicon cursors will be installed in:\n"
  show_dir "\t$DEST_DIR"
  if [ "$UID" -eq "$ROOT_UID" ]; then
    echo -e "\nIt will be available to all users."
  else
    echo -e "\nTo make it available to all users, run this script as root."
  fi

  continue

  # INSTALL

  # Check destination directory
  if [ ! -d $DEST_DIR ]; then
    mkdir -p $DEST_DIR
  elif [[ -d $DEST_DIR/silicon ]]; then
    replace $DEST_DIR
  fi

  echo -e "\nInstalling Silicon Cursors..."
  
  # Copying files
  cp -rf Silicon_Carbide $DEST_DIR
  chmod -R 755 $DEST_DIR/Silicon_*



  echo "Installation complete!"
  echo "Do not forget to set silicon as your cursor theme!"
}

remove() {

  # PREVIEW

  # Show installation directory
  if [[ -d $DEST_DIR/silicon_carbide ]]; then
    echo -e "\nsilicon cursors Theme installed in:\n"
    show_dir "\t$DEST_DIR"
    if [ "$UID" -eq "$ROOT_UID" ]; then
      echo -e "\nIt will be removed for all users."
    else
      echo -e "\nIt will be removed only for current user."
    fi

    continue
  
  else
    show_error "\nsilicon cursors are not installed in:\n"
    show_dir "\t$DEST_DIR\n"
    end
  fi

  # REMOVE

  echo -e "\nRemoving silicon..."

  # Removing files
  rm -rf $DEST_DIR/silicon_carbide

  echo "Removal complete!"
  echo "If you had any problems with the theme, feel free to let me know at the github page!"
}

main() {
  show_question "What you want to do: (I)nstall, (R)emove : \n"
  read INPUT
  case $INPUT in
    [Ii]* ) install;;
    [Rr]* ) remove;;
    * ) show_error "\nSorry, try again."; main;;
  esac
}

ROOT_UID=0
DEST_DIR=
cd "$( dirname "${BASH_SOURCE[0]}" )" || exit

# Destination directory
if [ "$UID" -eq "$ROOT_UID" ]; then
  DEST_DIR="/usr/share/icons"
else
  DEST_DIR="$HOME/.icons"
fi

echo -e "\e[1m\n+-------------------------------+"
echo -e "|     o                         |"
echo -e "|     |                         |"
echo -e "|     O      SILICON CURSORS    |"
echo -e "|   / | \                       |"
echo -e "| o   o   o                     |"
echo -e "+-------------------------------+\n\e[0m"

main
