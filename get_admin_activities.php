<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

$conn = new mysqli("localhost", "root", "", "LearningApp");
$conn->set_charset("utf8mb4");

if ($conn->connect_error) {
    echo json_encode(["status" => false, "message" => "Database connection failed"]);
    exit;
}

$result = $conn->query("SELECT id, title, description, timestamp FROM admin_activities ORDER BY timestamp DESC");
 
$activities = [];

while ($row = $result->fetch_assoc()) {
    $activities[] = $row;
}

echo json_encode([
    "status" => true,
    "activities" => $activities
]);

$conn->close();
?>