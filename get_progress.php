<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

$conn = new mysqli("localhost", "root", "", "LearningApp");

if ($conn->connect_error) {
    echo json_encode(["status" => "error", "message" => "Connection failed"]);
    exit;
}

$user_id = $_GET['user_id'] ?? null;

if (!$user_id) {
    echo json_encode(["status" => "error", "message" => "Missing user_id"]);
    exit;
}

$result = $conn->query("SELECT week, quizzes_passed, badges_earned FROM progress WHERE user_id = $user_id");

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();

    echo json_encode([
        "status" => "success",
        "progress" => [
            "week" => (int)$row['week'],
            "quizzes_passed" => (int)$row['quizzes_passed'],
            "badges_earned" => (int)$row['badges_earned']
        ]
    ]);
} else {
    echo json_encode(["status" => "error", "message" => "Progress not found"]);
}

$conn->close();
?>
