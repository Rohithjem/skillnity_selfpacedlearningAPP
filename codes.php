<!-- <?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

$conn = new mysqli("localhost", "root", "", "LearningApp");

// 1. Check DB connection
if ($conn->connect_error) {
    echo json_encode(["error" => "Connection failed: " . $conn->connect_error]);
    exit;
}

// 2. Validate input
if (!isset($_GET['user_id']) || !is_numeric($_GET['user_id'])) {
    echo json_encode(["error" => "Invalid or missing user_id"]);
    exit;
}

$user_id = intval($_GET['user_id']);

// 3. Try to fetch progress
$query = "SELECT * FROM progress WHERE user_id = ?";
$stmt = $conn->prepare($query);
$stmt->bind_param("i", $user_id);
$stmt->execute();
$result = $stmt->get_result();

if ($row = $result->fetch_assoc()) {
    // ✅ Progress exists, return it
    echo json_encode(["data" => $row]);
} else {
    // ❌ No progress — insert default one
    $insert = $conn->prepare("INSERT INTO progress (user_id, badges_earned, quizzes_passed, week, updated_at) VALUES (?, 0, 0, 1, NOW())");
    $insert->bind_param("i", $user_id);
    if ($insert->execute()) {
        // Fetch and return the newly inserted progress
        $query = "SELECT * FROM progress WHERE user_id = ?";
        $stmt = $conn->prepare($query);
        $stmt->bind_param("i", $user_id);
        $stmt->execute();
        $result = $stmt->get_result();

        if ($row = $result->fetch_assoc()) {
            echo json_encode(["data" => $row]);
        } else {
            echo json_encode(["error" => "Failed to fetch newly inserted progress."]);
        }
    } else {
        echo json_encode(["error" => "Failed to create default progress."]);
    }
    $insert->close();
}

$stmt->close();
$conn->close();
?> -->
