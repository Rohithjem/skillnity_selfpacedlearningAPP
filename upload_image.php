<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Content-Type: application/json");

$target_dir = "uploads/";

// Generate a unique filename
$extension = pathinfo($_FILES["image"]["name"], PATHINFO_EXTENSION);
$uniqueName = uniqid("img_", true) . '.' . $extension;
$target_file = $target_dir . $uniqueName;

if (move_uploaded_file($_FILES["image"]["tmp_name"], $target_file)) {
    echo json_encode(["status" => "success", "path" => "/" . $target_file]);
} else {
    echo json_encode(["status" => "error", "message" => "Upload failed"]);
}
?>
