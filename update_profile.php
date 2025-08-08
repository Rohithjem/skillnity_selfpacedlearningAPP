<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json; charset=UTF-8");

$conn = new mysqli("localhost", "root", "", "LearningApp");
$conn->set_charset("utf8mb4");

if ($conn->connect_error) {
    http_response_code(500);
    echo json_encode(["error" => "Connection failed"]);
    exit;
}

// Get form inputs
$user_id = intval($_POST['user_id'] ?? 0);
$username = trim($_POST['username'] ?? '');
$email = trim($_POST['email'] ?? '');
$college_name = trim($_POST['college_name'] ?? '');
$password = trim($_POST['password'] ?? '');


if (empty($user_id) || empty($username) || empty($email) || empty($college_name)) {
    http_response_code(400);
    echo json_encode(["error" => "Missing required fields"]);
    exit;
}

$uploadDir = __DIR__ . "/uploads/";
$webBaseURL = "http://localhost/skillnity/uploads/";
$profilePicURL = null;

// Handle profile picture upload
if (isset($_FILES['profile_pic']) && $_FILES['profile_pic']['error'] === UPLOAD_ERR_OK) {
    $fileTmp = $_FILES['profile_pic']['tmp_name'];
    $fileName = "profile_" . time() . ".jpg";
    $filePath = $uploadDir . $fileName;

    if (move_uploaded_file($fileTmp, $filePath)) {
        $profilePicURL = $webBaseURL . $fileName;
    } else {
        http_response_code(500);
        echo json_encode(["error" => "Failed to upload image"]);
        exit;
    }
}

// Prepare the SQL
if (!empty($password)) {
    $hashedPassword = password_hash($password, PASSWORD_DEFAULT);
    $stmt = $conn->prepare("UPDATE users SET username = ?, email = ?, college_name = ?, password = ?, profile_pic = ? WHERE id = ?");
    $stmt->bind_param("sssssi", $username, $email, $college_name, $hashedPassword, $profilePicURL, $user_id);
}

if ($profilePicURL) {
    $stmt = $conn->prepare("UPDATE users SET username = ?, email = ?, college_name = ?, profile_pic = ? WHERE id = ?");
    $stmt->bind_param("ssssi", $username, $email, $college_name, $profilePicURL, $user_id);
} else {
    $stmt = $conn->prepare("UPDATE users SET username = ?, email = ?, college_name = ? WHERE id = ?");
    $stmt->bind_param("sssi", $username, $email, $college_name, $user_id);
}

if ($stmt->execute()) {
    $result = $conn->query("SELECT id, username, email, college_name, profile_pic FROM users WHERE id = $user_id");
    if ($row = $result->fetch_assoc()) {
        echo json_encode([
            "id" => (int)$row["id"],
            "username" => $row["username"],
            "email" => $row["email"],
            "college_name" => $row["college_name"],
            "profile_pic" => $row["profile_pic"]
        ], JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);
    } else {
        echo json_encode(["error" => "User not found"]);
    }
} else {
    echo json_encode(["error" => "Failed to update profile"]);
}

$stmt->close();
$conn->close();
