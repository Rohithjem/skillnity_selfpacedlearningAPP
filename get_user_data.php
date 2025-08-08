<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

// 1. Connect to database
$conn = new mysqli("localhost", "root", "", "LearningApp");

// 2. Check connection
if ($conn->connect_error) {
    echo json_encode(["error" => "Connection failed: " . $conn->connect_error]);
    exit;
}

// 3. Validate user_id input
if (!isset($_GET['user_id']) || !is_numeric($_GET['user_id'])) {
    echo json_encode(["error" => "Invalid or missing user_id"]);
    exit;
}

$user_id = intval($_GET['user_id']);

// 4. Prepare and execute SQL query
$query = "SELECT id, username, college_name, email, profile_pic FROM users WHERE id = ?";
$stmt = $conn->prepare($query);
$stmt->bind_param("i", $user_id);
$stmt->execute();
$result = $stmt->get_result();

// 5. Return result
if ($row = $result->fetch_assoc()) {
    echo json_encode(["data" => $row]);
} else {
    echo json_encode(["data" => null, "message" => "User not found"]);
}

$stmt->close();
$conn->close();
?>
