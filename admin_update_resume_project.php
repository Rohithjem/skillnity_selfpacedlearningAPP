<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

// DB connection
$conn = new mysqli("localhost", "root", "", "LearningApp");
$conn->set_charset("utf8mb4");

if ($conn->connect_error) {
    echo json_encode(["status" => false, "message" => "Database connection failed"]);
    exit;
}

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(["status" => false, "message" => "Only POST method allowed"]);
    exit;
}

// Check if all required POST fields are set
if (
    !isset($_POST['id']) ||
    !isset($_POST['title']) ||
    !isset($_POST['type']) ||
    !isset($_POST['short_description']) ||
    !isset($_POST['full_description'])
) {
    echo json_encode(["status" => false, "message" => "Missing required fields"]);
    exit;
}

$id = (int)$_POST['id'];
$title = $conn->real_escape_string($_POST['title']);
$type = $conn->real_escape_string($_POST['type']);
$short = $conn->real_escape_string($_POST['short_description']);
$full = $conn->real_escape_string($_POST['full_description']);
$icon = isset($_POST['icon_name']) ? $conn->real_escape_string($_POST['icon_name']) : null;

// Prepare update
$stmt = $conn->prepare("UPDATE resume_projects SET title = ?, type = ?, short_description = ?, full_description = ?, icon_name = ? WHERE id = ?");
$stmt->bind_param("sssssi", $title, $type, $short, $full, $icon, $id);

// if ($stmt->execute()) {
//     echo json_encode(["status" => true, "message" => "Project updated successfully"]);
// } else {
//     echo json_encode(["status" => false, "message" => "Update error: " . $stmt->error]);
// }
if ($stmt->execute()) {
    if ($stmt->affected_rows > 0) {
        // ✅ Correct Activity Logging
        $activityTitle = "Updated Resume Project";
        $activityDesc = "Project ID $id was updated. Title: $title";

        $activityStmt = $conn->prepare("INSERT INTO admin_activities (title, description) VALUES (?, ?)");
        if ($activityStmt) {
            $activityStmt->bind_param("ss", $activityTitle, $activityDesc);
            $activityStmt->execute();
            $activityStmt->close();
        }
        echo json_encode(["status" => true, "message" => "Project updated successfully"]);
    } else {
        echo json_encode(["status" => false, "message" => "No rows updated. ID may not exist."]);
    }
}

$stmt->close();
$conn->close();
?>
