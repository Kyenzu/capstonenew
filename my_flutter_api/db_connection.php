<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "capstone"; // replace with your DB

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die(json_encode(["success" => false, "message" => "Database connection failed"]));
}
?>
