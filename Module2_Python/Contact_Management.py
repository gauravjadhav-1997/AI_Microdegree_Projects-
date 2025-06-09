import json
import os

# File to store the contact data
CONTACTS_FILE = 'contacts_data.json'

# Function to load contacts from a file
def load_contacts():
    if not os.path.exists(CONTACTS_FILE):
        return {}
    try:
        with open(CONTACTS_FILE, 'r') as file:
            return json.load(file)
    except Exception as e:
        print(f"Error loading contacts data: {e}")
        return {}

# Function to save contacts to a file
def save_contacts(contacts):
    try:
        with open(CONTACTS_FILE, 'w') as file:
            json.dump(contacts, file, indent=4) # Added indent for better readability
    except Exception as e:
        print(f"Error saving contacts data: {e}")

# Function to add a contact
def add_contact(contacts, name, phone, email):
    if name in contacts:
        print("Contact already exists. Use update option to modify.")
    else:
        contacts[name] = {'phone': phone, 'email': email}
        save_contacts(contacts)
        print(f"Contact '{name}' added successfully!")

# Function to view all contacts
def view_contacts(contacts):
    if not contacts:
        print("No contacts found.")
        return

    for name, details in contacts.items():
        print(f"Name: {name}, Phone: {details['phone']}, Email: {details['email']}")

# Function to update a contact
def update_contact(contacts, name, phone=None, email=None):
    if name not in contacts:
        print(f"Contact '{name}' not found.")
        return

    if phone:
        contacts[name]['phone'] = phone

    if email:
        contacts[name]['email'] = email

    save_contacts(contacts)
    print(f"Contact '{name}' updated successfully!")

# Function to delete a contact
def delete_contact(contacts, name):
    if name not in contacts:
        print(f"Contact '{name}' not found.")
        return

    del contacts[name]
    save_contacts(contacts)
    print(f"Contact '{name}' deleted successfully!")

# Main function to run the Contact Management System
def main():
    contacts = load_contacts()

    while True:
        print("\nContact Management System")
        print("1. Add Contact")
        print("2. View Contacts")
        print("3. Update Contact")
        print("4. Delete Contact")
        print("5. Exit")

        choice = input("Enter your choice: ")

        if choice == '1':
            name = input("Enter the contact name: ")
            phone = input("Enter the contact phone number: ")
            email = input("Enter the contact email: ")
            add_contact(contacts, name, phone, email)

        elif choice == '2':
            view_contacts(contacts)

        elif choice == '3':
            name = input("Enter the contact name to update: ")
            phone = input("Enter the new phone number (leave blank to keep current): ")
            email = input("Enter the new email (leave blank to keep current): ")
            update_contact(contacts, name, phone if phone else None, email if email else None)

        elif choice == '4':
            name = input("Enter the contact name to delete: ")
            delete_contact(contacts, name)

        elif choice == '5':
            print("Exiting the system. Goodbye!")
            break

        else:
            print("Invalid choice. Please enter a number between 1 and 5.")

if __name__ == "__main__":
    main()
