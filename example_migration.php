<?php
/**
 * Excel-to-SQL Bridge Demo
 * Author: Murat Göcmen (ExcelPHPBridge)
 * Purpose: Demonstrating a secure data migration from a data array to a MySQL database.
 */

// 1. Database Configuration (Example credentials)
$host    = 'localhost';
$db      = 'excel_bridge_demo';
$user    = 'db_user';
$pass    = 'secure_password';
$charset = 'utf8mb4';

$dsn = "mysql:host=$host;dbname=$db;charset=$charset";
$options = [
    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    PDO::ATTR_EMULATE_PREPARES   => false,
];

try {
    // 2. Establishing a secure connection using PDO
    $pdo = new PDO($dsn, $user, $pass, $options);

    // 3. Simulated data from an Excel file
    $excelData = [
        ['customer_name' => 'Max Mustermann', 'email' => 'max@example.com', 'service' => 'SQL-Migration'],
        ['customer_name' => 'Erika Muster', 'email' => 'erika@example.com', 'service' => 'PHP-Automation'],
    ];

    // 4. Prepared Statement for high security against SQL Injection
    $sql = "INSERT INTO customers (name, email, service_type) VALUES (:name, :email, :service)";
    $stmt = $pdo->prepare($sql);

    foreach ($excelData as $row) {
        $stmt->execute([
            ':name'    => $row['customer_name'],
            ':email'   => $row['email'],
            ':service' => $row['service']
        ]);
    }

    echo "Migration erfolgreich: " . count($excelData) . " Datensätze verarbeitet.";

} catch (\PDOException $e) {
    // Secure error handling
    error_log($e->getMessage());
    exit("Ein Datenbankfehler ist aufgetreten.");
}
