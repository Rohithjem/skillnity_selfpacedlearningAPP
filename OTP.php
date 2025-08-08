<?php
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

session_start(); // Required for $_SESSION

ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

require 'PHPMailer/src/Exception.php';
require 'PHPMailer/src/PHPMailer.php';
require 'PHPMailer/src/SMTP.php';
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");


$conn = new mysqli("localhost", "root", "", "LearningApp");
if ($conn->connect_error) {
    echo json_encode(["status" => "error", "message" => "Database connection failed"]);
    exit;
}

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Access-Control-Allow-Methods: POST");
header("Content-Type: application/json");

function sendOTP($toEmail, $subject, $body) {
     $mail = new PHPMailer(); // ✅ Correct instantiation

    $mail->isSMTP();
    $mail->Host = 'smtp.gmail.com';
    $mail->SMTPAuth = true;
    $mail->Username = ''; //replace with your gmail 
    $mail->Password = ''; //app password
    $mail->SMTPSecure = 'tls';
    $mail->Port = 587;
   


    $mail->setFrom('rohithjem@gmail.com', 'Skillnity');
    $mail->addAddress($toEmail);
    $mail->Subject = $subject;
    $mail->Body = $body;

    if ($mail->send()) {
        return true;
    } else {
        return $mail->ErrorInfo;
    }
}
