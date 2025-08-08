<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

// Get JSON input
$data = json_decode(file_get_contents("php://input"));

if (!isset($data->user_id)) {
    echo json_encode(["status" => "error", "message" => "Missing user_id"]);
    exit;
}

$conn = new mysqli("localhost", "root", "", "LearningApp");

if ($conn->connect_error) {
    echo json_encode(["status" => "error", "message" => "Connection failed"]);
    exit;
}

$user_id = intval($data->user_id);
$new_quiz_cleared = boolval($data->quiz_cleared ?? false); // ✅ Clearly named
$new_badge_earned = boolval($data->badge_earned ?? false); // ✅ Clearly named
$new_week = min(intval($data->week ?? 1), 5);

// Fetch current progress
$result = $conn->query("SELECT quizzes_passed, badges_earned, week FROM progress WHERE user_id = $user_id");

if ($result && $row = $result->fetch_assoc()) {
    $current_week = intval($row["week"]);
    $total_quizzes = intval($row["quizzes_passed"]);
    $total_badges = intval($row["badges_earned"]);

    if ($new_week >= $current_week) {
        if ($new_quiz_cleared) {
        $total_quizzes += 1;
    }

    if ($new_badge_earned) {
        $total_badges += 1;
    }

    $updated_week = max($current_week, $new_week);

        $stmt = $conn->prepare("UPDATE progress SET quizzes_passed = ?, badges_earned = ?, week = ? WHERE user_id = ?");
        $stmt->bind_param("iiii", $total_quizzes, $total_badges, $updated_week, $user_id);

        if ($stmt->execute()) {
            echo json_encode(["status" => "success", "message" => "Progress updated"]);
        } else {
            echo json_encode(["status" => "error", "message" => "Update failed"]);
        }

        $stmt->close();
    } else {
        echo json_encode(["status" => "ignored", "message" => "Week already completed"]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Progress not found"]);
}

$conn->close();
?>
