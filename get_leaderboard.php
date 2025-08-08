<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

$host = "localhost";
$user = "root";
$password = "";
$dbname = "LearningApp";

// Create connection
$conn = new mysqli($host, $user, $password, $dbname);
$conn->set_charset("utf8mb4");

// Check connection
if ($conn->connect_error) {
    http_response_code(500);
    echo json_encode(["error" => "Database connection failed"]);
    exit;
}

// SQL Query: Top 10 users by badges
$sql = "
    SELECT 
        u.id,
        u.username,
        u.college_name AS college,
        u.profile_pic,
        COALESCE(p.badges_earned, 0) AS badges
    FROM users u
    LEFT JOIN progress p ON u.id = p.user_id
    GROUP BY u.id
    ORDER BY badges DESC
    LIMIT 10
";

$result = $conn->query($sql);

// Prepare JSON output
$users = [];

if ($result && $result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $users[] = [
            "id" => (int)$row["id"],
            "username" => $row["username"],
            "college" => $row["college"],
            "profile_pic" => $row["profile_pic"] ?? null,
            "badges" => (int)$row["badges"]
        ];
    }
    echo json_encode($users, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
} else {
    echo json_encode([]);
}

$conn->close();
?>
