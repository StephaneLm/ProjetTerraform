<?php
$servername = getenv('DB_HOST');
$username = getenv('DB_USER');
$password = getenv('DB_PASSWORD');
$dbname = getenv('DB_NAME');

// Créer la connexion
$conn = new mysqli($servername, $username, $password, $dbname);

// Vérifier la connexion
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Créer une table si elle n'existe pas
$conn->query("CREATE TABLE IF NOT EXISTS visitors (id INT AUTO_INCREMENT PRIMARY KEY, visit_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");

// Insérer un enregistrement
$conn->query("INSERT INTO visitors () VALUES ()");

// Sélectionner les enregistrements
$result = $conn->query("SELECT COUNT(*) AS visit_count FROM visitors");
$row = $result->fetch_assoc();
echo "Total visits: " . $row['visit_count'];

$conn->close();
?>
