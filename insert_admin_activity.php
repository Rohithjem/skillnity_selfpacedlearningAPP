<?php
// Enable error reporting for debugging (disable in production)
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Include DB config
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

$conn = new mysqli("localhost", "root", "", "LearningApp");
$conn->set_charset("utf8mb4");

if ($conn->connect_error) {
    echo json_encode(["status" => false, "message" => "Database connection failed"]);
    exit;
}

// Get JSON input
$data = json_decode(file_get_contents("php://input"), true);

// Validate required fields
if (!isset($data['title']) || !isset($data['description'])) {
    echo json_encode([
        "status" => false,
        "message" => "Missing required fields: title and description"
    ]);
    exit;
}

$title = trim($data['title']);
$description = trim($data['description']);

// Prepare and execute insert
$sql = "INSERT INTO admin_activities (title, description) VALUES (?, ?)";
$stmt = $conn->prepare($sql);

if ($stmt === false) {
    echo json_encode([
        "status" => false,
        "message" => "Failed to prepare statement"
    ]);
    exit;
}

$stmt->bind_param("ss", $title, $description);

if ($stmt->execute()) {
    echo json_encode([
        "status" => true,
        "message" => "Activity inserted successfully",
        "id" => $stmt->insert_id
    ]);
} else {
    echo json_encode([
        "status" => false,
        "message" => "Failed to insert activity"
    ]);
}

$stmt->close();
$conn->close();
