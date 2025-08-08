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
$password = trim($_POST['password'] ?? '');

// Validate required
if (empty($user_id) || empty($username)) {
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

// Build update query dynamically
$fields = [];
$params = [];
$types = "";

$fields[] = "username = ?";
$params[] = $username
; $types .= "s";

if (!empty($password)) {
    $hashedPassword = password_hash($password, PASSWORD_DEFAULT);
    $fields[] = "password = ?";
    $params[] = $hashedPassword;
    $types .= "s";
}

if ($profilePicURL !== null) {
    $fields[] = "profile_pic = ?";
    $params[] = $profilePicURL;
    $types .= "s";
}

$types .= "i"; // for WHERE id = ?
$params[] = $user_id;

$setClause = implode(", ", $fields);
$sql = "UPDATE admins SET {$setClause} WHERE id = ?";

$stmt = $conn->prepare($sql);
if (!$stmt) {
    http_response_code(500);
    echo json_encode(["error" => "Prepare failed: " . $conn->error]);
    exit;
}

// bind params dynamically
$stmt->bind_param($types, ...$params);

if ($stmt->execute()) {
    // Return updated user
    $result = $conn->query("SELECT id, username, profile_pic FROM admins WHERE id = $user_id");
    if ($row = $result->fetch_assoc()) {
        echo json_encode([
            "data" => [
                "id" => (int)$row["id"],
                "username" => $row["username"],
                "profile_pic" => $row["profile_pic"]
            ]
        ], JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);
    } else {
        http_response_code(404);
        echo json_encode(["error" => "User not found"]);
    }
} else {
    http_response_code(500);
    echo json_encode(["error" => "Failed to update profile"]);
}

$stmt->close();
$conn->close();
?>
