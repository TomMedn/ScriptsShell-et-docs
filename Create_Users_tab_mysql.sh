#!/bin/bash

# MySQL credentials
MYSQL_USER="root"
MYSQL_PASSWORD="admin"
MYSQL_DATABASE="Medigroup"

# Création de la table avec une clé primaire
mysql -u $MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE <<EOF
CREATE TABLE IF NOT EXISTS Utilisateurs (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Departement VARCHAR(255),
    Prenom VARCHAR(255),
    Nom VARCHAR(255),
    Embauche DATE,
    Telephone VARCHAR(20),
    Fincontrat DATE,
    MotDePasse VARCHAR(255)
);
EOF

# Chargement des données depuis users_data.txt
mysql -u $MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE <<EOF
LOAD DATA LOCAL INFILE 'users_data.txt'
INTO TABLE Utilisateurs
CHARACTER SET utf8
FIELDS TERMINATED BY '\t' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(Departement, Prenom, Nom, @Embauche, Telephone, @Fincontrat, @MotDePasse)
SET Embauche = STR_TO_DATE(@Embauche, '%d/%m/%Y'),
    Fincontrat = STR_TO_DATE(@Fincontrat, '%d/%m/%Y'),
    MotDePasse = SHA2(@MotDePasse, 256);
EOF
