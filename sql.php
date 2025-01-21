CREATE TABLE IF NOT EXISTS `vehicle_storage` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `vehicle_id` VARCHAR(255) NOT NULL,
    `owner` VARCHAR(255) NOT NULL,
    `item_name` VARCHAR(255) NOT NULL,
    `item_count` INT NOT NULL,
    UNIQUE (`vehicle_id`, `item_name`, `owner`)
);