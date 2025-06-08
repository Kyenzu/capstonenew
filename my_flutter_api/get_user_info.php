<?php
header("Access-Control-Allow-Origin: *");
header('Content-Type: application/json');

$conn = new mysqli("localhost", "root", "", "capstone");

// Check for connection errors
if ($conn->connect_error) {
    echo json_encode(["error" => "Database connection failed"]);
    exit();
}

$user_id = isset($_GET['user_id']) ? intval($_GET['user_id']) : 0;

// Use prepared statements for security
$stmt = $conn->prepare("SELECT first_name, last_name, email, phone, dob, age, gender, is_verified, province, city, barangay FROM users WHERE id = ?");
$stmt->bind_param("i", $user_id);
$stmt->execute();
$result = $stmt->get_result();

if ($row = $result->fetch_assoc()) {
    echo json_encode($row);
} else {
    echo json_encode(["error" => "User not found"]);
}

$stmt->close();
$conn->close();
?>