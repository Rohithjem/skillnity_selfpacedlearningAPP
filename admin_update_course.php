<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");
$host = 'localhost';
$dbname = 'LearningApp';
$dbUser = 'root';
$dbPass = '';
$conn = new mysqli("localhost", "root", "", "LearningApp");
if (!$conn) {
    echo json_encode(["status" => "error", "message" => "DB connection failed"]);
    exit;
}

$data = json_decode(file_get_contents("php://input"), true);
if (!isset($data['id'])) {
    echo json_encode(["status" => "error", "message" => "Missing id"]);
    exit;
}

$id = intval($data['id']);
$title = isset($data['title']) ? $conn->real_escape_string($data['title']) : "";
$description = isset($data['description']) ? $conn->real_escape_string($data['description']) : "";
$image_url = isset($data['image_url']) ? $conn->real_escape_string($data['image_url']) : "";
$is_active = isset($data['is_active']) ? intval($data['is_active']) : 0;

$stmt = $conn->prepare("UPDATE newcourses SET title = ?, description = ?, image_url = ?, is_active = ? WHERE id = ?");
if (!$stmt) {
    echo json_encode(["status" => "error", "message" => "Prepare failed: " . $conn->error]);
    exit;
}
$stmt->bind_param("sssii", $title, $description, $image_url, $is_active, $id);

if ($stmt->execute()) {
    $activityTitle = "Updated Course";
    $activityDesc = "Course ID $id was updated. Title: $title";

    $activityStmt = $conn->prepare("INSERT INTO admin_activities (title, description) VALUES (?, ?)");
    if ($activityStmt) {
        $activityStmt->bind_param("ss", $activityTitle, $activityDesc);
        $activityStmt->execute();
        $activityStmt->close();
    }
    echo json_encode(["status" => "success", "message" => "Course updated"]);
} else {
    echo json_encode(["status" => "error", "message" => "Update failed: " . $stmt->error]);
}
$stmt->close();
$conn->close();
?>
