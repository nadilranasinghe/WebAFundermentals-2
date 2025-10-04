<?php
//PHP server size for animal Zoo
?>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Animal Information - PHP version </title>
        <style>
            body{
                font-family: 'Times New Roman', Times, serif;
                max-width: 800;
                margin: 0 auto;
                padding: 20px;
                background-color: bisque;
            }
            .container {
                background: white;
                padding: 20px;
                border-radius: 15px;
               
            }
            h1{
                color:orangered;
                text-align: center;
            }
            .animal-display{
                display: flex;
                margin-top: 20px;
                gap: 20px;
            }
            .animal-image{
                max-width: 400px;
                max-height: 400px;
                border-radius: 8px;
            }
            .animal-description{
                flex: 1;
                padding: 10px;
            }

            .back-button {
            background-color: red;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            margin-top: 20px;
            text-decoration: none;
            display: inline-block;
        }
        .back-button:hover {
            background-color: chocolate;
        }
        </style>

    </head>
    <body>
        <div class="container">
            <?php
            //Get form data
            $userName = isset($_POST['userName']) ? htmlspecialchars(trim($_POST['userName'])) : 'Visitor';
            $animal = isset($_POST['animal']) ? $_POST['animal'] : '';

            //Valid animals
            $validAnimals = ['lion', 'elephant', 'giraffe','dolphin', 'penguin', 'tiger'];

            if (empty($userName) || empty($animal) || !in_array($animal, $validAnimals)){
                echo "<h1>Error</h1>";
                echo "<p>Invalid input or animal selection. Please try again</p>";
                echo "<a href='php-zoo.html' class='back-button'>Back to Zoo</a>";
                exit;

            }

            //Welcoming the user
            echo "<h1>Hello, $userName!</h1>";
            echo "<h2>Welcome to the $animal's habitat!</h2>";

            //Displayin the animal information
            $imagePath = "theZoo/$animal.jpg";
            $descriptionPath = "theZoo/$animal.txt";

            echo "<div class='animal-display'>";
            if(file_exists($imagePath)){
                echo "<img src='$imagePath' alt='$animal' class='animal-image'>";
            } else{
                echo "<div class='animal-image'>Image Not Found: $imagePath</div>";
            }

            echo "<div class='animal-description'>";
            if (file_exists($descriptionPath)){
                $description = file_get_contents($descriptionPath);
                echo $description;
            }else{
                echo "<h3>About the $animal</h3>";
                echo "<p>Description file not found. Please check the file path: $descriptionPath</p>";

            }
            echo "</div>";
            echo "</div>";

            //Back button
            echo "<a href='php-zoo.html' class='back-button'>Back to Zoo Entrance</a>";


            ?>
        </div>
    </body>

</html>