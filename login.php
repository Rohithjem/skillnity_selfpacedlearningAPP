<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");
header("Access-Control-Allow-Methods: POST");

$host = "localhost";
$db_name = "LearningApp";
$username = "root";
$password = "";

$conn = new mysqli($host, $username, $password, $db_name);

// Check connection
if ($conn->connect_error) {
    echo json_encode(["success" => false, "message" => "Connection failed: " . $conn->connect_error]);
    exit;
}

// Get POST data
$data = [];
parse_str(file_get_contents("php://input"), $data);

$user = $data['username'] ?? '';
$plainPassword = $data['password'] ?? '';

if (empty($user) || empty($plainPassword)) {
    echo json_encode(["success" => false, "message" => "Username and password are required."]);
    exit;
}

// Check user existence
$stmt = $conn->prepare("SELECT id, username, password FROM users WHERE username = ?");
$stmt->bind_param("s", $user);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows === 1) {
    $row = $result->fetch_assoc();
    if (password_verify($plainPassword, $row['password'])) {
        echo json_encode([
            "success" => true,
            "id" => $row['id'],
            "username" => $row['username']
        ]);
    } else {
        echo json_encode(["success" => false, "message" => "Invalid password."]);
    }
} else {
    echo json_encode(["success" => false, "message" => "User not found."]);
}

$stmt->close();
$conn->close();
?>
