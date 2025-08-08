<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

// Get incoming JSON data
$data = json_decode(file_get_contents("php://input"));

if (!isset($data->user_id) || !isset($data->points) || !isset($data->badges)) {
    echo json_encode(["status" => "error", "message" => "Missing parameters"]);
    exit;
}

$userID = intval($data->user_id);
$points = intval($data->points);
$badges = intval($data->badges);

// Connect to database
$conn = new mysqli("localhost", "root", "", "LearningApp");

if ($conn->connect_error) {
    echo json_encode(["status" => "error", "message" => "Database connection failed"]);
    exit;
}

// Check if the user already has a progress row
$check = $conn->prepare("SELECT id FROM progress WHERE user_id = ?");
$check->bind_param("i", $userID);
$check->execute();
$check->store_result();

if ($check->num_rows > 0) {
    // Update existing record
    $stmt = $conn->prepare("UPDATE progress SET quizzes_passed = quizzes_passed + ?, badges_earned = badges_earned + ? WHERE user_id = ?");
    $stmt->bind_param("iii", $points, $badges, $userID);
} else {
    // Insert new record
    $stmt = $conn->prepare("INSERT INTO progress (user_id, quizzes_passed, badges_earned, week) VALUES (?, ?, ?, 1)");
    $stmt->bind_param("iii", $userID, $points, $badges);
}

if ($stmt->execute()) {
    echo json_encode(["status" => "success", "message" => "Leaderboard updated"]);
} else {
    echo json_encode(["status" => "error", "message" => "Failed to update leaderboard"]);
}

$stmt->close();
$conn->close();
?>
