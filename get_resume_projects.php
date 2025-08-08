<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

$conn = new mysqli("localhost", "root", "", "LearningApp");
$conn->set_charset("utf8mb4");

if ($conn->connect_error) {
    echo json_encode(["error" => "Database connection failed"]);
    exit;
}

$sql = "SELECT * FROM resume_projects ORDER BY id ASC";
$result = $conn->query($sql);

$projects = [];
while ($row = $result->fetch_assoc()) {
    $projects[] = [
        "id" => (int)$row["id"],
        "title" => $row["title"],
        "type" => $row["type"],
        "short_description" => $row["short_description"],
        "full_description" => $row["full_description"],
        "icon_name" => $row["icon_name"]
    ];
}

echo json_encode($projects, JSON_UNESCAPED_UNICODE);
$conn->close();
