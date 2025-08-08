<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");
$host = 'localhost';
$dbname = 'LearningApp';
$dbUser = 'root';
$dbPass = '';
$conn = new mysqli("localhost", "root", "", "LearningApp");
$data = json_decode(file_get_contents("php://input"), true);

$title = isset($data['title']) ? $conn->real_escape_string($data['title']) : "";
$description = isset($data['description']) ? $conn->real_escape_string($data['description']) : "";
$image_url = isset($data['image_url']) ? $conn->real_escape_string($data['image_url']) : "";
$is_active = isset($data['is_active']) ? intval($data['is_active']) : 1;
$created_at = date('Y-m-d H:i:s');

if (empty($title) || empty($description)) {
    echo json_encode(["status" => "error", "message" => "Title and description required"]);
    exit;
}

$stmt = $conn->prepare("INSERT INTO newcourses (title, description, image_url, is_active, created_at) VALUES (?, ?, ?, ?, ?)");
if (!$stmt) {
    echo json_encode(["status" => "error", "message" => "Prepare failed: " . $conn->error]);
    exit;
}
$stmt->bind_param("sssis", $title, $description, $image_url, $is_active, $created_at);

if ($stmt->execute()) {
    $activityTitle = "Created Course";
    $activityDesc = "A new course (ID: $courseId) was created. Title: $title";

    $activityStmt = $conn->prepare("INSERT INTO admin_activities (title, description) VALUES (?, ?)");
    if ($activityStmt) {
        $activityStmt->bind_param("ss", $activityTitle, $activityDesc);
        $activityStmt->execute();
        $activityStmt->close();
    }
    echo json_encode(["status" => "success", "message" => "Course created", "id" => $stmt->insert_id]);
} else {
    echo json_encode(["status" => "error", "message" => "Insert failed: " . $stmt->error]);
}
$stmt->close();
$conn->close();
?>
