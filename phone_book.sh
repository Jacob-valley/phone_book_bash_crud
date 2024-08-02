#!/bin/bash

# Проверка наличия файла телефонной книги
if [ $# -ne 1 ] ||! [ -f "$1" ]; then
  echo "Usage: $0 <phone_book_file>"
  exit 1
fi

PHONE_BOOK_FILE=$1

# Функция добавления записи
add_entry() {
  read -p "Enter last name: " last_name
  read -p "Enter first name: " first_name
  read -p "Enter phone number: " phone_number
  read -p "Enter notes: " notes
  echo "$last_name|$first_name|$phone_number|$notes" >> $PHONE_BOOK_FILE
}

# Функция удаления записи
delete_entry() {
  read -p "Enter last name or first name to delete: " search_string
  if grep -q "$search_string" "$PHONE_BOOK_FILE"; then
    read -p "Do you want to delete this: $(grep -i "$search_string" "$PHONE_BOOK_FILE") y/n? " awnser
    if [ "$awnser" == "y" ]; then  
      grep -iv "$search_string" "$PHONE_BOOK_FILE" > temp && mv temp "$PHONE_BOOK_FILE"
      read -p "Entry deleted successfully, press Enter"
    fi
  else
    read -p "No entry found for: $search_string, press Enter"
  fi
}


# Функция редактирования записи
edit_entry() {
  read -p "Enter last name or first name to edit: " search_string
  
  # Поиск записи в файле
  entry=$(grep -i "$search_string" "$PHONE_BOOK_FILE")
  
  # Проверка, что запись найдена
  if [ -n "$entry" ]; then
    echo "You are editing this entry: $entry"
    read -p "Enter new last name: " new_last_name
    read -p "Enter new first name: " new_first_name
    read -p "Enter new phone number: " new_phone_number
    read -p "Enter new notes: " new_notes
    
    # Формирование новой строки
    new_entry="$new_last_name|$new_first_name|$new_phone_number|$new_notes"
    
    Замена старой строки на новую
    grep -iv "$entry" "$PHONE_BOOK_FILE" > temp && mv temp "$PHONE_BOOK_FILE"
    echo "$new_last_name|$new_first_name|$new_phone_number|$new_notes" >> $PHONE_BOOK_FILE
    read -p "Entry updated successfully."
  else
    read -p "Entry not found."
  fi
}


# Функция вывода записей
list_entries() {
  cat $PHONE_BOOK_FILE
  read -p "Press Enter to continue..."
}

# Функция поиска записей
search_entries() {
  read -p "Enter last name or first name to search: " search_string
  grep -i "$search_string" $PHONE_BOOK_FILE
  read -p "Press Enter to continue..."
}

# Меню
while true; do
  clear
  echo "Phone Book Menu"
  echo "----------------"
  echo "1. Add entry"
  echo "2. Delete entry"
  echo "3. Edit entry"
  echo "4. List entries"
  echo "5. Search entries"
  echo "6. Quit"
  read -p "Choose an option: " option

  case $option in
    1) add_entry ;;
    2) delete_entry ;;
    3) edit_entry ;;
    4) list_entries ;;
    5) search_entries ;;
    6) exit 0 ;;
    *) echo "Invalid option" ;;
  esac
done