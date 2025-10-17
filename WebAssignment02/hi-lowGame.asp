<% @language = "VBScript" %>
<% Option Explicit %>
<% 
' Server-side game logic
Dim playerName, maxNumber, randomNumber, minRange, maxRange, guess 
Dim currentSection, errorMessage, feedbackMessage

'Initilaizing the session variables if they do not exist
If Session("playerName") = "" Then Session("playerName") = ""
If Session("maxNumber") = "" Then Session("maxNumber") = 0
If Session("randomNumber") = "" Then Session("randomNumber") = 0
If Session("minRange") = "" Then Session("minRange") = 1
If Session("maxRange") = "" Then Session("maxRange") = 0

'Process form for submissions

If Request.ServerVariables("REQUEST_METHOD") = "POST" Then
    If Request.Form("action") = "submitName" Then
        'Validate name
    playerName = Trim(Request.Form("playerName"))
    If playerName = "" Then
        errorMessage = "Name cannot be empty"
        currentSection = "name"
    Else
        Session("playerName") = playerName
        currentSection = "maxNumber"
    End If
ElseIf Request.Form("action") = "submitMaxNumber" Then
    'Validate max number on Server
    If IsNumeric(Request.Form("maxNumber")) Then
        maxNumber = CInt(Request.Form("maxNumber"))
        If maxNumber > 1 Then
            Session("maxNumber") = maxNumber
            Session("minRange") = 1
            Session("maxRange") = maxNumber
            Randomize
            Session("randomNumber") = Int((maxNumber * Rnd()) + 1)
            currentSection = "game"
        Else
        errorMessage = "Enter a value that is greater than 1"
        currentSection = "maxNumber"
        EndIf
    Else
        errorMessage = "Enter a Valid Number"
        currentSection = "maxNumber"
    End If
ElseIf Request.Form("action") = "submitGuess" Then
    'Process guess 
    If IsNumeric(Request.Form("guess")) Then
        guess = CInt(Request.Form("guess"))
        minRange = Session("minRange")
        maxRange = Session("maxRange")
        randomNumber = Session("randomNumber")


        'The Server Side Range Validation
        If guess < minRange or guess > maxRange Then
            feedbackMessage = "Your guess is outside the range " & minRange & " to " & maxRange
            currentSection = "game"
            ElseIf guess = randomNumber Then
                currentSection = "win"
            Else
                'Updatin the game range based on the guess
                If guess < randomNumber Then
                    Session("minRange") = guess + 1
                    feedbackMessage = "Your guess is too low"
                Else
                    Session("maxRange") = guess - 1
                    feedbackMessage = "Your guess is too high"
                End If
                currentSection = "game"
            End If
        Else
            feedbackMessage = "Please enter a valid Number"
            currentSection = "game"
        End If

    ElseIf Request.Form("action") = "playAgain" Then
    'Resetting the game
        Session.Contents.Remove("playerName")
        Session.Contents.Remove("maxNumber")
        Session.Contents.Remove("randomNumber")
        Session.Contents.Remove("minRange")
        Session.Contents.Remove("maxRange")
        currentSection = "name"
    End If
End If

'Determine the current section to display

If currentSection = "" Then
    If Session("playerName") = "" Then
        currentSection = "name"
    ElseIf Session("maxNumber") = 0 Then
        currentSection = "maxNumber"
    Else
        currentSection = "game"
    End If
End If
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>PROG1275 - A02: Hi-Low Game</title>
    <style>
        body{
            font-family: Arial, Helvetica, sans-serif;
            text-align: center;
            margin: 0;
            padding: 20px;
            background-color: white;
           
        }

        .game-container{
            max-width: 600px;
            margin: auto;
            padding: 20px;
            background-color: white;
            border-radius: 10px;
        }

        .input-selection{
            margin: 20px 0;
        }

        input{
            padding: 8px;
            margin: 10px 0;
            width: 200px;
        }



        button{
            padding: 8px 15px;
            background-color: #4caf50;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin: 5px;
        }

        button:hover{
            background-color: rgb(29, 234, 2);
        }

        .error{
            color: red;
            margin: 10px 0;

        }

        .hidden{
            display: none;
        }

        #winMessage{
            font-size: 24px;
            font-weight: bold;
            color: blueviolet;
            margin: 20px 0;
        }

    </style>
</head>
<body>
    <!-- Game heading -->
    <h1> Hi-Low Game</h1>

    <div id="game-container">
        <!-- Input for Name-->
        <div type="text" id="nameSection" class="input-selection">
            <label for="playerName">Please Enter your Name: </label><br>
            <input type="text" id="playerName" required>
            <button id="submitName">Submit Name</button>
        </div>
        <!--Name error message that is hidden initially-->
        <div id="nameError" class="error hidden"></div>
    </div>
    
    <div id="maxNumberSelection" class="hidden">
        <!--Max Number Selection Section-->
        <h2> Hi  <span id="displayName" style="color: blue"></span></h2>
        <div class="input-selection">
            <label for="maxNumber"> Enter the Maximum Number for game: </label><br>
            <input type="number" id="maxNumber" min="2" required>
            <button id="submitMaxNumber">Submit Max</button>
        </div>
        <!--Max number Error mesage that is initally hidden-->
        <div id="maxNumberError" class="error hidden"></div>
    </div>
        
        
    <div id="gameSelection" class="hidden">
        <!--Game Logic Section-->
        <h2> Hi, <span id="displayingGameName" style="color: blue"></span>!</h2>
        <div class="message" id="rangeMessage"></div>
        <div class="input-selection">
            <label for="guess">Enter your guess: </label><br>
            <input type="number" id="guess" required>
            <!--Error message for invalid guess-->
            <div id="guessError" class="error hidden"></div>
            <button id="submitGuess">Make this guess</button>
            <!--Feedback message regarding the guess-->
            <div id="feedbackMessage"></div>
        </div>
    </div>
        
    <div id="winSelection" class="hidden">
         <div id="winMessage">YOU WIN!!! YOU GUESSED THE NUMBER!!</div>
          <button id="playAgain">Play Again</button>
    </div>
    

</body>
</html>


        

