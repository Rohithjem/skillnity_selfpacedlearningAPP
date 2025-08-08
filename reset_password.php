<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

// STEP 1: Parse incoming JSON payload
$data = json_decode(file_get_contents("php://input"));
if (!isset($data->email)) {
    echo json_encode(["status" => "error", "message" => "Email is required"]);
    exit;
}

$email = $data->email;

// STEP 2: Validate user exists in database
$conn = new mysqli("localhost", "root", "", "LearningApp");
if ($conn->connect_error) {
    echo json_encode(["status" => "error", "message" => "Database connection failed"]);
    exit;
}

$stmt = $conn->prepare("SELECT id FROM users WHERE email = ?");
$stmt->bind_param("s", $email);
$stmt->execute();
$stmt->store_result();

if ($stmt->num_rows === 0) {
    echo json_encode(["status" => "error", "message" => "Email not registered"]);
    $stmt->close();
    $conn->close();
    exit;
}
$stmt->close();

// STEP 3: Generate temporary password
$tempPassword = bin2hex(random_bytes(4)); // e.g., '7a3f9b4c'
$hashedPassword = password_hash($tempPassword, PASSWORD_BCRYPT);

// STEP 4: Update password in DB
$updateStmt = $conn->prepare("UPDATE users SET password = ? WHERE email = ?");
$updateStmt->bind_param("ss", $hashedPassword, $email);
$updateStmt->execute();
$updateStmt->close();
$conn->close();

// STEP 5: Send email via MailerSend
$apiKey = "i have key here as in swift"; // ✅ Replace with your actual MailerSend API key
$senderEmail = "rohithroyal001@gmail.com"; // ✅ Verified sender in MailerSend

$payload = [
    "from" => ["email" => $senderEmail, "name" => "Skillnity"],
    "to" => [["email" => $email]],
    "subject" => "Skillnity Password Reset",
    "text" => "Your temporary password is: $tempPassword\nUse it to log in and change your password.",
    "html" => "<p>Hello,</p><p>Your temporary password is: <strong>$tempPassword</strong></p><p>Use it to log in and change your password.</p>"
];

$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, "https://api.mailersend.com/v1/email");
curl_setopt($ch, CURLOPT_HTTPHEADER, [
    "Authorization: Bearer $apiKey",
    "Content-Type: application/json"
]);
curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($payload));
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);

$response = curl_exec($ch);
$httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
curl_close($ch);

// STEP 6: Final response
if ($httpCode === 202) {
    echo json_encode(["status" => "success", "message" => "Password reset. Email sent."]);
} else {
    echo json_encode(["status" => "error", "message" => "Failed to send email"]);
}
