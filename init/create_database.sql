-- Create the database
-- CREATE DATABASE haha;

-- Connect to the database
\c haha;

-- Create the tables
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    address_line1 VARCHAR(100),
    address_line2 VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50),
    postal_code VARCHAR(20),
    country VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price NUMERIC(10, 2) NOT NULL,
    stock_quantity INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    product_url TEXT UNIQUE NOT NULL,
    retailer VARCHAR(255) NOT NULL
);

CREATE TABLE product_views (
    view_id SERIAL PRIMARY KEY,
    user_id INT NULL,
    product_id INT NOT NULL,
    view_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    session_id VARCHAR(100),
    user_agent VARCHAR(255),
    ip_address VARCHAR(45),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE product_suggestions (
    suggestion_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    suggested_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expiration_date TIMESTAMP,
    reason VARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE product_media (
    media_id SERIAL PRIMARY KEY,
    product_id INT NOT NULL,
    media_data BYTEA NOT NULL,
    is_primary BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    parent_id INT,
    FOREIGN KEY (parent_id) REFERENCES categories(category_id)
);

CREATE TABLE product_categories (
    product_id INT NOT NULL,
    category_id INT NOT NULL,
    PRIMARY KEY (product_id, category_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE CASCADE
);

CREATE TABLE order_head (
    order_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    total_amount NUMERIC(10, 2) NOT NULL,
    order_status VARCHAR(20) CHECK (order_status IN ('Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled')) DEFAULT 'Pending',
    payment_status VARCHAR(20) CHECK (payment_status IN ('Pending', 'Paid', 'Failed', 'Refunded')) DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price NUMERIC(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES order_head(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE reviews (
    review_id SERIAL PRIMARY KEY,
    product_id INT NOT NULL,
    user_id INT NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE shopping_cart (
    cart_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE cart_items (
    cart_item_id SERIAL PRIMARY KEY,
    cart_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (cart_id) REFERENCES shopping_cart(cart_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE wish_lists (
    wish_list_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    name VARCHAR(100) DEFAULT 'My Wish List',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE wish_list_items (
    wish_list_item_id SERIAL PRIMARY KEY,
    wish_list_id INT NOT NULL,
    product_id INT NOT NULL,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (wish_list_id) REFERENCES wish_lists(wish_list_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

