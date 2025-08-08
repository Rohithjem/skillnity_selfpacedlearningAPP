
<?php
// Allow cross-origin requests (CORS)
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

// Connect to MySQL database
$conn = new mysqli("localhost", "root", "", "LearningApp");
$conn->set_charset("utf8mb4");

// Check connection
if ($conn->connect_error) {
    echo json_encode(["status" => false, "message" => "Database connection failed"]);
    exit;
}

// Only allow POST method
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(["status" => false, "message" => "Only POST method allowed"]);
    exit;
}

// Decode the JSON request body
$data = json_decode(file_get_contents("php://input"), true);

// Check if ID is provided
if (!isset($data['id'])) {
    echo json_encode(["status" => false, "message" => "Missing project ID"]);
    exit;
}

$id = (int)$data['id'];

// 🔍 Get project title before deletion
$title = "";
$titleStmt = $conn->prepare("SELECT title FROM resume_projects WHERE id = ?");
$titleStmt->bind_param("i", $id);
$titleStmt->execute();
$titleResult = $titleStmt->get_result();

if ($titleRow = $titleResult->fetch_assoc()) {
    $title = $titleRow['title'];
}
$titleStmt->close();

// 🗑️ Proceed to delete the project
$stmt = $conn->prepare("DELETE FROM resume_projects WHERE id = ?");
$stmt->bind_param("i", $id);

if ($stmt->execute()) {
    if ($stmt->affected_rows > 0) {
        // 📝 Log admin activity
        $activityTitle = "Deleted Resume Project";
        $activityDesc = "A resume project was deleted. Title: $title";

        $activityStmt = $conn->prepare("INSERT INTO admin_activities (title, description) VALUES (?, ?)");
        if ($activityStmt) {
            $activityStmt->bind_param("ss", $activityTitle, $activityDesc);
            $activityStmt->execute();
            $activityStmt->close();
        }

        echo json_encode(["status" => true, "message" => "Project deleted successfully"]);
    } else {
        echo json_encode(["status" => false, "message" => "Project not found or already deleted"]);
    }
} else {
    echo json_encode(["status" => false, "message" => "Delete error: " . $stmt->error]);
}

// Cleanup
$stmt->close();
$conn->close();
?>
