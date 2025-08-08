<?php
require('fpdf/fpdf.php');
header("Content-Type: application/pdf");

$name = $_GET['name'] ?? 'Student';
$college = $_GET['college'] ?? 'College Name';

$pdf = new FPDF();
$pdf->AddPage();
$pdf->SetFont('Arial', 'B', 24);

// Skillnity Header
$pdf->Cell(0, 15, 'Skillnity', 0, 1, 'C');

// Title
$pdf->SetFont('Arial', 'B', 20);
$pdf->Cell(0, 20, 'Certificate of Achievement', 0, 1, 'C');

// Line
$pdf->SetDrawColor(180, 180, 180);
$pdf->Line(10, 60, 200, 60);

// Body
$pdf->SetFont('Arial', '', 14);
$pdf->Ln(10);
$pdf->MultiCell(0, 10, "This is to certify that\n\n$name\n\nfrom\n$college\n\nhas successfully completed the DSA course under Skillnity with distinction.", 0, 'C');

// Footer
$pdf->SetY(-30);
$pdf->SetFont('Arial', 'I', 10);
$pdf->Cell(0, 10, 'Approved Certificate • Skillnity', 0, 1, 'C');

$pdf->Output('I', 'certificate.pdf');
