<?php
header('Content-Type: application/json');
$conn = new mysqli("localhost", "root", "", "capstone");
$user_id = $_GET['user_id'];
$result = $conn->query("SELECT first_name, last_name, email FROM users WHERE id = $user_id");
if ($row = $result->fetch_assoc()) {
    echo json_encode($row);
} else {
    echo json_encode(["error" => "User not found"]);
}
$conn->close();
?>