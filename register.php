<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");
header("Access-Control-Allow-Methods: POST");

// 1. Connect to Database
$host = "localhost";
$db_name = "LearningApp";
$username = "root";
$password = "";

$conn = new mysqli($host, $username, $password, $db_name);

// 2. Check connection
if ($conn->connect_error) {
    echo json_encode(["success" => false, "message" => "Connection failed: " . $conn->connect_error]);
    exit;
}

// 3. Get POST data
$data = json_decode(file_get_contents("php://input"), true);

$user = $data['username'] ?? '';
$college = $data['collegeName'] ?? '';
$email = $data['email'] ?? '';
$plainPassword = $data['password'] ?? '';

// 4. Basic validation
if (empty($user) || empty($college) || empty($email) || empty($plainPassword)) {
    echo json_encode(["success" => false, "message" => "All fields are required."]);
    exit;
}

// 5. Check for duplicate username or email
$checkStmt = $conn->prepare("SELECT id FROM users WHERE username = ? OR email = ?");
$checkStmt->bind_param("ss", $user, $email);
$checkStmt->execute();
$checkStmt->store_result();

if ($checkStmt->num_rows > 0) {
    echo json_encode(["success" => false, "message" => "Username or email already exists."]);
    $checkStmt->close();
    $conn->close();
    exit;
}
$checkStmt->close();

// 6. Hash the password
$hashedPassword = password_hash($plainPassword, PASSWORD_DEFAULT);

// 7. Insert new user
$stmt = $conn->prepare("INSERT INTO users (username, college_name, email, password) VALUES (?, ?, ?, ?)");
$stmt->bind_param("ssss", $user, $college, $email, $hashedPassword);

if ($stmt->execute()) {
    $newUserId = $stmt->insert_id;

    // 8. Insert default progress
    $progress_stmt = $conn->prepare("INSERT INTO progress (user_id, badges_earned, quizzes_passed, week, updated_at) VALUES (?, 0, 0, 1, NOW())");
    $progress_stmt->bind_param("i", $newUserId);
    $progress_stmt->execute();
    $progress_stmt->close();

    // 9. Send success response
    echo json_encode([
        "success" => true,
        "message" => "Registration successful.",
        "id" => $newUserId,
        "username" => $user
    ]);
} else {
    echo json_encode(["success" => false, "message" => "Registration failed: " . $stmt->error]);
}

$stmt->close();
$conn->close();
?>
