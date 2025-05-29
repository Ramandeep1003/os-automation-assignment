# Operating Systems Automation Assignment

**Author:** Ramandeep Singh  
**Student ID:** [1000117882]  
**Course:** IA616001 Operating Systems Concepts  
**Lecturer:** [Dr. Sonia Gul]  
**Last Updated:** May 29, 2025

---

## Project Structure

OS_Assignment/
├── task1/
| ├──  backup.sh
│ ├── user_setup.sh # Automates user creation and setup
│ ├── users.csv # CSV file with user information
├── task2/
│ ├── backup.sh # Script to back up specified directories
├── README.md # Project documentation

## ⚙How to Run the Scripts
### Task 1: User Setup
1. Ensure the `users.csv` file contains user data in this format:
firstname,lastname,group
linus,torvalds,sudo
2. Run the script:
```bash
sudo ./task1/user_setup.sh task1/users.csv
 Task 2: Backup Script
./task2/backup_script.sh
Follow the on-screen prompts to enter:
The full path of the directory to back up
The destination path to store the backup
