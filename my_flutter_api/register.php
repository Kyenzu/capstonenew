<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization, Accept, X-Requested-With");
header("Content-Type: application/json");

// Handle preflight OPTIONS request
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit();
}

$conn = new mysqli("localhost", "root", "", "capstone");

if ($conn->connect_error) {
    die(json_encode(["success" => false, "message" => "Database connection failed."]));
}

$data = json_decode(file_get_contents("php://input"));

$firstName = $data->first_name;
$lastName = $data->last_name;
$username = $data->username;
$email = $data->email;
$phone = $data->phone;
$dob = $data->dob;
$age = $data->age;
$gender = $data->gender;
$status = $data->status;
$province = $data->province;
$city = $data->city;
$barangay = $data->barangay;
$password = password_hash($data->password, PASSWORD_BCRYPT);

// Prepare SQL statement
$stmt = $conn->prepare("INSERT INTO users 
    (first_name, last_name, username, email, phone, dob, age, gender, status, province, city, barangay, password) 
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");

// Check if prepare worked
if (!$stmt) {
    echo json_encode(["success" => false, "message" => "Failed to prepare statement: " . $conn->error]);
    exit();
}

// Bind parameters
// Types: s = string, i = integer
$stmt->bind_param(
    "ssssssissssss",
    $firstName,
    $lastName,
    $username,
    $email,
    $phone,
    $dob,
    $age,
    $gender,
    $status,
    $province,
    $city,
    $barangay,
    $password
);

// Execute statement
if ($stmt->execute()) {
    echo json_encode(["success" => true]);
} else {
    echo json_encode(["success" => false, "message" => $stmt->error]);
}

$stmt->close();
$conn->close();
?>
