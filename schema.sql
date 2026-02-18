CREATE TABLE themes (
    id INT PRIMARY KEY,
    name VARCHAR(255),
    parent_id INT
);

CREATE TABLE sets (
    set_num VARCHAR(50) PRIMARY KEY,
    name VARCHAR(255),
    year INT,
    theme_id INT,
    num_parts INT
);

CREATE TABLE parts (
    part_num VARCHAR(250) PRIMARY KEY,
    name VARCHAR(255),
    part_cat_id INT
);

CREATE TABLE part_categories (
    id INT PRIMARY KEY,
    name VARCHAR(255)
);

CREATE TABLE colors (
    id INT PRIMARY KEY,
    name VARCHAR(255),
    rgb VARCHAR(6),
    is_trans VARCHAR(1)
);

CREATE TABLE inventories (
    id INT PRIMARY KEY,
    version INT,
    set_num VARCHAR(50)
);

CREATE TABLE inventory_sets (
    inventory_id INT,
    set_num VARCHAR(50),
    quantity INT,
    PRIMARY KEY (inventory_id, set_num)
);

CREATE TABLE inventory_parts (
    inventory_id INT,
    part_num VARCHAR(250),
    color_id INT,
    quantity INT,
    is_spare VARCHAR(1)
    -- FK for part_num purposefully omitted due to dataset issues
);