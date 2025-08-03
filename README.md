# Overview

The Revision Scheduler can AI-generate multiple-choice quizzes from user input and allows users to set themselves quizzes on different days.

# Features
- Enter a prompt to AI-generate a multiple choice quiz
- Edit generated quiz titles, choice and answers
- Take any quiz saved to your account to see how well you do
- Add a saved quiz to the calendar or enter some text to remind yourself to complete a task


# Installation Guide


## Java Program Setup
- Install IntelliJ IDEA
- Install Open JDK 17.0.2
- Open IntelliJ and open the Revision Scheduler folder
- Click Trust Project
- There will be a Maven notification in the bottom right to install dependencies. Click this so it can resolve dependencies for JavaFX and other libraries.
- Go to File > Project Structure > Modules > TaskAndQuizScheduler > Module SDK > OpenJDK 17.0.2 (wherever you have saved it) > check JARs or Directories > FinalProject > src > mysql-connector-java-8.0.28 > check > OK
- IntelliJ will report errors with identifying table names across the project and the JavaFXThemes and MaterialFXStylesheets variables in the ViewHandler method but the application should still work by the end of this guide

## Python Program Setup
- Install VSCode
- Install at least Python 3.9
- Open quizPrompter folder from the extracted ZIP file
- Open quizPrompter.py
- Open Terminal in VSCode and type ``` pip install --upgrade openai ```
- Change the file location in the open line to “OPENAI_API_KEY.txt”
- Get OpenAI API Key from OpenAI from https://platform.openai.com/settings/profile?tab=api-keys
- A key is free if your phone number wasn’t used to activate ChatGPT in the past but if not, it will cost around £5.
- Paste in OPENAI_API_KEY.txt (must be in same folder as quizPrompter.py)

## Database Setup
- Install XAMPP
- Open XAMPP and run Apache and MySQL
- Open browser and go to http://localhost/phpmyadmin/
- Create new database
- Enter revision_scheduler > Create
- At the top bar, click Import > Choose file > select revision_scheduler.sql

## Running The Application
- Ensure XAMPP is still running
- Run quizPrompter.py
- Go to RevisionScheduler and build it from the green hammer button. Go to StartTaskAndQuizScheduler method and run
- There is some test data in the database already. For testing purposes, you can sign in with the credentials:
  - Username: q
  - Password: w
- Any other login details in the database will also work
- The example provided above would not normally be allowed as a registration for the software because it does not fit the validation requirements but it has been provided for testing
- If you decide to close the application, ensure quizPrompter.py has stopped too. If not, terminate it.
- Every time you decide to test the application, restart quizPrompter.py, StartTaskAndQuizScheduler method. XAMPP does not need to be terminated/restarted each time. It can stay running throughout testing

# Future Improvements

- Friends system to be able to share quizzes and set them to each other's calendars
- Content moderation system to focus users on generating only educational and/or suitable content for quizzes
- Improvements to UI appearance
- Gamification of UX
- Functional website blocker
- Create an executable file for use as a complete software prototype
