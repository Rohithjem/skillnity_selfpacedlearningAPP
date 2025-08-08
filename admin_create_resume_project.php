<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

// Database connection
$conn = new mysqli("localhost", "root", "", "LearningApp");
$conn->set_charset("utf8mb4");

// Check connection
if ($conn->connect_error) {
    echo json_encode(["status" => false, "message" => "Database connection failed"]);
    exit;
}

// Allow only POST
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(["status" => false, "message" => "Only POST method is allowed"]);
    exit;
}

// Decode incoming JSON
$data = json_decode(file_get_contents("php://input"), true);

// Required fields check
if (
    !isset($data['title']) ||
    !isset($data['type']) ||
    !isset($data['short_description']) ||
    !isset($data['full_description'])
) {
    echo json_encode(["status" => false, "message" => "Missing required fields"]);
    exit;
}

// Sanitize input
$title = $conn->real_escape_string($data['title']);
$type = $conn->real_escape_string($data['type']);
$short = $conn->real_escape_string($data['short_description']);
$full = $conn->real_escape_string($data['full_description']);
$icon = isset($data['icon_name']) ? $conn->real_escape_string($data['icon_name']) : null;

// SQL Insert
$stmt = $conn->prepare("INSERT INTO resume_projects (title, type, short_description, full_description, icon_name) VALUES (?, ?, ?, ?, ?)");
$stmt->bind_param("sssss", $title, $type, $short, $full, $icon);

if ($stmt->execute()) {
    $activityTitle = "Created Resume Project";
    $activityDesc = "A new resume project was created. Title: $title";

    $activityStmt = $conn->prepare("INSERT INTO admin_activities (title, description) VALUES (?, ?)");
    if ($activityStmt) {
        $activityStmt->bind_param("ss", $activityTitle, $activityDesc);
        $activityStmt->execute();
        $activityStmt->close();
    }
    echo json_encode(["status" => true, "message" => "Project created successfully", "id" => $stmt->insert_id]);
} else {
    echo json_encode(["status" => false, "message" => "Insert error: " . $stmt->error]);
}

$stmt->close();
$conn->close();
?>
