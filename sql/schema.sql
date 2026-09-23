-- MiniPay Database Schema Definition

CREATE TABLE IF NOT EXISTS customers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS transactions (
    id SERIAL PRIMARY KEY,
    reference VARCHAR(50) NOT NULL,
    customer_id INT REFERENCES customers(id),
    amount DECIMAL(12,2) NOT NULL,
    status VARCHAR(20) NOT NULL, -- SUCCESS, FAILED, PROCESSING, CANCELLED
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE IF NOT EXISTS callbacks (
    id SERIAL PRIMARY KEY,
    transaction_reference VARCHAR(50) NOT NULL,
    status VARCHAR(20) NOT NULL, -- SUCCESS, FAILED
    received_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Seed Initial Test Data
INSERT INTO customers (id, name, email) VALUES 
(1, 'Ali Khan', 'ali@example.com'),
(2, 'Sara Ahmed', 'sara@example.com'),
(3, 'Usman Tariq', 'usman@example.com')
ON CONFLICT DO NOTHING;

INSERT INTO transactions (reference, customer_id, amount, status, created_at, updated_at) VALUES
('TXN1001', 1, 5000.00, 'SUCCESS', NOW() - INTERVAL '10 minutes', NOW() - INTERVAL '9 minutes'),
('TXN1002', 2, 12000.00, 'SUCCESS', NOW() - INTERVAL '1 hour', NOW() - INTERVAL '58 minutes'),
('TXN1003', 1, 3000.00, 'PROCESSING', NOW() - INTERVAL '20 minutes', NOW() - INTERVAL '20 minutes'),
('TXN1004', 3, 15000.00, 'FAILED', NOW() - INTERVAL '2 hours', NOW() - INTERVAL '2 hours'),
('TXN1001', 1, 5000.00, 'SUCCESS', NOW() - INTERVAL '5 minutes', NOW() - INTERVAL '4 minutes'), -- Intentional Duplicate Reference
('TXN1005', 2, 8500.00, 'PROCESSING', NOW() - INTERVAL '25 minutes', NOW() - INTERVAL '25 minutes');

INSERT INTO callbacks (transaction_reference, status, received_at) VALUES
('TXN1001', 'SUCCESS', NOW() - INTERVAL '9 minutes'),
('TXN1002', 'SUCCESS', NOW() - INTERVAL '58 minutes'),
('TXN1004', 'FAILED', NOW() - INTERVAL '2 hours');
