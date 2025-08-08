<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

// 1. Connect to DB
$conn = new mysqli("localhost", "root", "", "LearningApp");

// 2. Check connection
if ($conn->connect_error) {
    echo json_encode(["error" => "Connection failed: " . $conn->connect_error]);
    exit;
}

// 3. Validate input
if (!isset($_GET['week']) || !is_numeric($_GET['week'])) {
    echo json_encode(["error" => "Invalid or missing 'week' parameter."]);
    exit;
}

$week = intval($_GET['week']);

// 4. Query using prepared statement
$stmt = $conn->prepare("SELECT title, description, week FROM courses WHERE week = ? AND is_active = 1 LIMIT 1");
$stmt->bind_param("i", $week);
$stmt->execute();
$result = $stmt->get_result();

// 5. Return result
if ($row = $result->fetch_assoc()) {
    echo json_encode(["data" => $row]);
} else {
    // Return empty 'data' field for Swift decoding safety
    echo json_encode(["data" => null, "message" => "No active course found for week $week"]);
}

$stmt->close();
$conn->close();
?>
