/**
On your local machine, replace 'bookstore' with 'bookstore_db'
**/

-- Use JAWS_DB Database
USE bookstore;

-- Create Table Author on DB
CREATE TABLE `bookstore`.`Author` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `firstName` VARCHAR(45) NOT NULL,
  `lastName` VARCHAR(45) NOT NULL,
  `createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`));

-- Create Table Book after Author because of FK constraint to Author Tbl
CREATE TABLE `bookstore`.`Book` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(255) NOT NULL,
  `genre` VARCHAR(255) NOT NULL,
  `pubYear` INT NOT NULL,
  `price` DECIMAL(13,2) NOT NULL,
  `inventory` INT NOT NULL,
  `bookDescription` TEXT NOT NULL,
  `createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `AuthorId` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `AuthorId_idx` (`AuthorId` ASC),
  CONSTRAINT `AuthorId`
    FOREIGN KEY (`AuthorId`)
    REFERENCES `bookstore`.`Author` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- Create Table Cart
CREATE TABLE `bookstore`.`Cart` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `quantity` INT NOT NULL,
  `price` DECIMAL(13,2) NOT NULL,
  `createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`));

-- Insert Sample Authors
INSERT INTO `bookstore`.`Author` (firstName, lastName) VALUES ('F. Scott', 'Fitzgerald');
INSERT INTO `bookstore`.`Author` (firstName, lastName) VALUES ('George', 'Orwell');

-- Insert Sample Books (Seed Data)
INSERT INTO `bookstore`.`Book` (title, genre, pubYear, price, inventory, bookDescription, AuthorId) 
VALUES ('The Great Gatsby', 'Classic', 1925, 15.99, 50, 'A story of wealth, love, and the American Dream.', 1);

INSERT INTO `bookstore`.`Book` (title, genre, pubYear, price, inventory, bookDescription, AuthorId) 
VALUES ('1984', 'Dystopian', 1949, 12.99, 40, 'A dystopian social science fiction novel.', 2);