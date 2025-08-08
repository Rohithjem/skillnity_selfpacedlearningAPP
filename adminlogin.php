<?php
header('Content-Type: application/json');

// Read JSON input
$input = json_decode(file_get_contents("php://input"), true);

// Validate input
if (!$input || !isset($input['username']) || !isset($input['password'])) {
    echo json_encode(["success" => false, "message" => "Invalid JSON"]);
    exit;
}

// DB credentials
$host = 'localhost';
$dbname = 'LearningApp';
$dbUser = 'root';
$dbPass = '';

// Connect to DB
$conn = new mysqli($host, $dbUser, $dbPass, $dbname);
if ($conn->connect_error) {
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => 'Database connection failed']);
    exit;
}

// Escape username
$usernameInput = $conn->real_escape_string($input['username']);
$passwordInput = $input['password'];

// Fetch admin record
$sql = "SELECT * FROM admins WHERE username = '$usernameInput'";
$result = $conn->query($sql);

if ($result && $result->num_rows === 1) {
    $admin = $result->fetch_assoc();

    // Verify hashed password
    if (password_verify($passwordInput, $admin['password'])) {
        echo json_encode([
            'success' => true,
            'id' => (int)$admin['id'],
            'username' => $admin['username']
        ]);
    } else {
        echo json_encode(['success' => false, 'message' => 'Invalid password']);
    }
} else {
    echo json_encode(['success' => false, 'message' => 'Admin not found']);
}

$conn->close();
?>
