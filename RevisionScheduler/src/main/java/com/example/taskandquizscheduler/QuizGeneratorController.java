package com.example.taskandquizscheduler;


import io.github.palexdev.materialfx.controls.MFXButton;
import io.github.palexdev.materialfx.controls.MFXFilterComboBox;
import io.github.palexdev.materialfx.controls.MFXRadioButton;
import io.github.palexdev.materialfx.controls.MFXTextField;
import io.github.palexdev.materialfx.utils.StringUtils;
import io.github.palexdev.materialfx.utils.others.FunctionalStringConverter;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.TextArea;
import javafx.scene.input.KeyEvent;
import javafx.stage.Stage;
import javafx.util.StringConverter;

import java.io.*;
import java.net.Socket;
import java.util.ArrayList;
import java.util.function.Function;
import java.util.function.Predicate;

//handles loading and generating quizzes from user input
public class QuizGeneratorController {

    //used to switch between scenes/pages
    private ViewHandler viewHandler;

    //the questions generated and received from the Python program
    private ArrayList<ArrayList<String>> questionList;
    //question number to iterate through the questions in the output area
    private int currentQuestion = 0;
    //the output of the prompt (generated quiz)
    private String quizGenOutput;
    private String quizName = "Multiple Choice Quiz";
    //used to access user-related data
    private User user;
    private QuizDataAccessor quizDataAccessor;

    //used for saving generated quiz outputs
    private BufferedWriter bw = null;
    //used for writing to Python server
    private PrintWriter pw;
    //used for retrieving previously generated quizzes
    private BufferedReader br = null;
    //used for connecting to and requesting from Python program for generating quizzes
    private ClientController clientController;
    //used for enabling client-server communication to Python program
    private Socket clientSocket;

    @FXML
    private MFXButton generateQuizButton = new MFXButton();
    @FXML
    private MFXButton startQuizButton = new MFXButton();
    @FXML
    private MFXButton saveQuizButton = new MFXButton();

    //holds saved quizzes
    @FXML
    private MFXFilterComboBox<Quiz> loadQuizComboBox = new MFXFilterComboBox<>();

    //input area for user to enter text to be used in the prompt to generate a quiz
    @FXML
    private TextArea quizGenInputArea;
    //used to specify the number of questions that should be generated
    @FXML
    private MFXTextField numQuestionsField;
    @FXML
    private MFXTextField questionDescField;
    @FXML
    private MFXTextField quizNameField;

    //text fields for specifying what each option should be for any given question
    @FXML
    private MFXTextField option1Field;
    @FXML
    private MFXTextField option2Field;
    @FXML
    private MFXTextField option3Field;
    @FXML
    private MFXTextField option4Field;
    @FXML
    private MFXTextField[] optionFields;

    //radio buttons for assigning the correct answer for a question
    @FXML
    private MFXRadioButton option1Radio;
    @FXML
    private MFXRadioButton option2Radio;
    @FXML
    private MFXRadioButton option3Radio;
    @FXML
    private MFXRadioButton option4Radio;
    @FXML
    private MFXRadioButton[] optionRadios;

    @FXML
    private MFXButton nextQuestionButton;
    @FXML
    private MFXButton prevQuestionButton;


    public QuizGeneratorController() {
        quizDataAccessor = new QuizDataAccessor();

        try {
            clientController = new ClientController();
            clientSocket = new Socket("localhost", 3007);

            //set up to write to Python program
            pw = new PrintWriter(clientSocket.getOutputStream(), true);

        } catch (IOException e) {
            e.printStackTrace();
        }

    }

    //This method was reused from (Troels Mortensen, 2019)
    public void init(ViewHandler viewHandler){
        this.viewHandler = viewHandler;
    }

    @FXML
    public void initialize(){
        quizGenInputArea.setPromptText("Enter or paste text here. " +
                "\nYou can then edit the generated quiz's questions and answers on the right");
        initialiseTextFields();
        disableButtons();
    }

    @FXML
    protected void initialiseComboBox(){
        //retrieve all the user's saved quizzes
        ArrayList<Quiz> quizzesFromDB = quizDataAccessor.retrieveQuizzesDB(user);

        // ### start: from MaterialFX library (palexdev, 2024), edited with my Quiz class and quizzesFromDB variable

        //add the quizzes to the combobox
        ObservableList<Quiz> loadedQuizzes = FXCollections.observableArrayList();
        loadedQuizzes.addAll(quizzesFromDB);
        //convert Quiz objects to Strings to be displayed in loadQuizComboBox
        StringConverter<Quiz> converter = FunctionalStringConverter.to(quiz -> (quiz == null) ? "" : quiz.getQuizName());
        //filter Quiz objects that match what was selected by the user
        Function<String, Predicate<Quiz>> filterFunction = s -> quiz -> StringUtils.containsIgnoreCase(converter.toString(quiz), s);
        loadQuizComboBox.setItems(loadedQuizzes);
        loadQuizComboBox.setConverter(converter);
        loadQuizComboBox.setFilterFunction(filterFunction);

        // ### end
    }

    @FXML
    protected void initialiseTextFields(){
        optionFields = new MFXTextField[] {option1Field, option2Field, option3Field, option4Field};
        optionRadios = new MFXRadioButton[] {option1Radio, option2Radio, option3Radio, option4Radio};

        // ### start AI-generated

        // Add event listeners to text fields and radio buttons to save edits
        quizNameField.textProperty().addListener((obs, oldText, newText) -> saveQuizNameEdit(quizNameField));
        questionDescField.textProperty().addListener((obs, oldText, newText) -> saveOptionEdits(questionDescField, 0));
        for (int i = 0; i < optionFields.length; i++) {
            final int index = i + 1; // To capture the correct index in the lambda expression
            optionFields[i].textProperty().addListener((obs, oldText, newText)
                    -> saveOptionEdits(optionFields[index - 1], index));
            //this line (optionRadios) by me, inspired by the AI-generated code block above
            optionRadios[i].setOnAction(e -> saveAnswerEdit(optionFields[index - 1]));
        }
        // ### end AI-generated

        // ### start AI-generated, changed field name to numQuestionsField
        //add filter to prevent non-numerical input
        numQuestionsField.addEventFilter(KeyEvent.KEY_TYPED, event -> {
            if (!event.getCharacter().matches("[0-9]")) {
                event.consume();
            }
        });
        // ### end AI-generated
    }

    @FXML
    protected void disableButtons(){
        //should only be enabled once there's text provided as input
        generateQuizButton.setDisable(true);
        quizGenInputArea.textProperty().addListener((obs, oldText, newText) -> toggleGenerateQuizButton());
        //should only be enabled when a quiz has been loaded or generated
        saveQuizButton.setDisable(true);
        startQuizButton.setDisable(true);
        prevQuestionButton.setDisable(true);
        nextQuestionButton.setDisable(true);
    }

    @FXML
    private void toggleGenerateQuizButton(){
        if (quizGenInputArea.getText().isBlank()){
            generateQuizButton.setDisable(true);
        }
        else {
            generateQuizButton.setDisable(false);
        }
    }

    @FXML
    protected void goToSchedule(){
        pw.close();
        viewHandler.openView("Schedule");
    }

    @FXML
    protected void goToWebsiteBlocker(){
        viewHandler.openView("WebsiteBlocker");
    }

    @FXML
    protected void logout() {
        pw.close();
        viewHandler.setUser(null);
        viewHandler.openView("Login");
    }


    @FXML
    protected void startQuiz() {
        pw.close();
        viewHandler.setQuizName(quizName);
        viewHandler.setQuestionList(questionList);
        //set previousView so if user exits from quiz, they return to Quiz Generator
        viewHandler.setPreviousView("QuizGenerator");
        viewHandler.openView("Quiz");
    }

    @FXML
    protected void loadQuiz(){
        quizName = loadQuizComboBox.getSelectedItem().getQuizName();
        formatQuizFromDB();
        displayQuizOutput();
    }



    //sends the user input text as a prompt to the Python program to generate and display a quiz
    @FXML
    protected void generateQuiz() {
        //minimum 1 / maximum 10 questions can be generated at once
        int numQuestions;
        if (numQuestionsField.getText().isBlank()){
            numQuestions = 3;
        }
        else if (Integer.parseInt(numQuestionsField.getText()) > 10){
            numQuestions = 10;
        }
        else if (Integer.parseInt(numQuestionsField.getText()) < 1){
            numQuestions = 1;
        }
        else {
            numQuestions = Integer.parseInt(numQuestionsField.getText());
        }
        //send to ClientSocket to send to Python program
        clientController.setQuizGenInput(quizGenInputArea.getText());
        clientController.sendInfo(pw);
        clientController.setQuizGenInput(String.valueOf(numQuestions));
        clientController.sendInfo(pw);
        //get outputted quiz from ClientSocket from Python program
        quizGenOutput = String.valueOf(clientController.retrieveInfo(clientSocket));
        formatQuizFromGenerator();
        displayQuizOutput();
    }

    //formats ChatGPT String output into ArrayList
    private void formatQuizFromGenerator(){
        //split up the string of questions into separate strings, using # as delimiter
        String[] questions = quizGenOutput.split("#");
        //list of all questions
        questionList = new ArrayList<>();
        //used as a counter to add the relevant information to the corresponding ArrayList
        int questionNumber = 0;
        //for every question, split up into lines as [question, 1, 2, 3, 4, answer]
        for (String question : questions){
            //split based on new lines
            String[] splitQuestion = question.split("\n");
            //add new ArrayList to hold new question and its contents
            questionList.add(new ArrayList<>());
            //add corresponding question info to the ArrayList
            for (String line : splitQuestion){
                questionList.get(questionNumber).add(line);
            }
            //increment to make room for next question
            questionNumber += 1;
        }
    }

    private void formatQuizFromDB(){
        String quizID = loadQuizComboBox.getSelectedItem().getQuizID();
        //list of all questions in the quiz in the form [quizName, question 1, ... question n]
        questionList = new ArrayList<>();
        questionList.add(new ArrayList<>());
        questionList.get(0).add(quizName);
        //every element after 0th in questionList is a question in the form [question, option 1, 2, 3, 4, answer]
        ArrayList<Question> questions = quizDataAccessor.retrieveQuestionsDB(quizID);
        ArrayList<ArrayList<String>> wholeQuiz = quizDataAccessor.reconstructQuizFromDB(questions);
        questionList.addAll(wholeQuiz);
        quizNameField.setText(quizName);
    }

    @FXML
    protected void displayQuizOutput(){
        //reset currentQuestion so quiz output starts from question 1
        currentQuestion = 0;
        nextQuestionButton.setDisable(false);
        goToNextQuestion();
        //prevent going out of bounds of array indices
        prevQuestionButton.setDisable(true);
        //enable save and start quiz buttons because an output will have been generated
        saveQuizButton.setDisable(false);
        startQuizButton.setDisable(false);
    }

    @FXML
    protected void goToNextQuestion(){
        currentQuestion += 1;
        populateFields();
        prevQuestionButton.setDisable(false);
        if (currentQuestion == (questionList.size() - 1)){
            nextQuestionButton.setDisable(true);
        }
    }

    @FXML
    protected void goToPrevQuestion(){
        currentQuestion -= 1;
        populateFields();
        nextQuestionButton.setDisable(false);
        if (currentQuestion == 1){
            prevQuestionButton.setDisable(true);
        }
    }

    @FXML
    protected void populateFields(){
        //display the question
        questionDescField.setText(questionList.get(currentQuestion).get(0));
        //remove unnecessary String from ChatGPT 3.5 prompt in Python program
        String answer = questionList.get(currentQuestion).get(5).replaceFirst("Answer: ", "");
        //display options for the current question
        for (int i = 0; i < optionFields.length; i++){
            MFXTextField optionField = optionFields[i];
            MFXRadioButton optionRadio = optionRadios[i];
            //field shows corresponding text for the current question (i + 1 because of alignment differences)
            optionField.setText(questionList.get(currentQuestion).get(i + 1));
            //use radio buttons to indicate the correct answer
            String optionText = optionField.getText();
            if (optionText.equals(answer)){
                optionRadio.setSelected(true);
            }
        }
    }

    private void saveQuizNameEdit(MFXTextField nameField){
        //replace quiz name, located at [0][0]
        questionList.get(0).set(0, nameField.getText());
    }


    //This method was AI-generated but with names changed to currentQuestionList, questionList and currentQuestion
    private void saveOptionEdits(MFXTextField optionField, int index) {
        //get the option's corresponding question
        ArrayList<String> currentQuestionList = questionList.get(currentQuestion);
        //replace the text for that option
        currentQuestionList.set(index, optionField.getText());
    }

    private void saveAnswerEdit(MFXTextField optionField) {
        //get the answer's corresponding question
        ArrayList<String> currentQuestionList = questionList.get(currentQuestion);
        //answers have this format in the questionList
        String answerText = "Answer: " + optionField.getText();
        currentQuestionList.set(5, answerText);
    }

    @FXML
    protected void saveQuiz() {
        String quizName = String.valueOf(questionList.get(0).get(0));
        //retrieve ID of newly saved quiz to associate it with its questions and options in the database
        String quizID = quizDataAccessor.addQuizDB(user, quizName);
        //for every question, save options and answers
        for (int i = 1; i < questionList.size(); i++){
            ArrayList<String> questionAndOptions = questionList.get(i);
            String questionDesc = questionAndOptions.get(0);
            String questionID = quizDataAccessor.addQuestionDB(quizID, questionDesc);
            quizDataAccessor.addOptionsDB(questionID, questionAndOptions);
        }
        //add new quiz name to combo box so user can immediately access it
        Quiz quiz = new Quiz();
        quiz.setQuizName(quizName);
        quiz.setQuizID(quizID);
        loadQuizComboBox.getItems().add(quiz);
    }

    public void setUser(User user){
        this.user = user;
    }
}