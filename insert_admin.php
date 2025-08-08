<?php
$host = "localhost";
$dbname = "LearningApp";
$user = "root";
$pass = "";

$conn = new mysqli($host, $user, $pass, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Add a second admin
$username = 'admin2';
$password = password_hash('adminpass123', PASSWORD_DEFAULT); // securely hash

$sql = "INSERT INTO admins (username, password) VALUES (?, ?)";
$stmt = $conn->prepare($sql);
$stmt->bind_param("ss", $username, $password);

if ($stmt->execute()) {
    echo "Second admin inserted successfully.";
} else {
    echo "Error: " . $conn->error;
}

$conn->close();
?>
