<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");
header("Access-Control-Allow-Methods: POST");

// Database credentials
$host = "localhost";
$db_name = "LearningApp";
$username = "root";
$password = "";

// Establish connection
$conn = mysqli_connect($host, $username, $password, $db_name);

// Check connection
if (!$conn) {
    http_response_code(500);
    echo json_encode(["error" => "Database connection failed."]);
    exit();
}

// Query to fetch active courses
$sql = "SELECT * FROM newcourses WHERE is_active = 1";
$result = mysqli_query($conn, $sql);

$courses = [];
while ($row = mysqli_fetch_assoc($result)) {
    $courses[] = $row;
}

// Return result
echo json_encode($courses);
?>
