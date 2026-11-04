-- ---------------------------------------------------------------------------
-- N-Logistics - development seed data
--
-- Optional. Run this after schema.sql if you want an account you can log in
-- with straight away.
--
--   mysql -u root -p logistics_db < database/seed.sql
--
-- WARNING: the password below is public because it is committed to this
-- repository. It exists only so the project can be tried out locally.
-- Change or delete this account before running the application anywhere
-- that is reachable from the internet.
-- ---------------------------------------------------------------------------

-- Development Super Admin
--   username: superadmin
--   password: Admin@12345
--
-- The hash is BCrypt, cost factor 12, generated with the same jBCrypt
-- library the application uses.

INSERT IGNORE INTO `users`
    (`username`, `email`, `password_hash`, `phone`,
     `role_id`, `company_id`, `status`)
SELECT
    'superadmin',
    'superadmin@nlogistics.com',
    '$2a$12$aH7AavrTY83D6S7Ta7kXCudBXXhsr5JxDqPyqYMsUkknoKsxqNGt.',
    NULL,
    r.role_id,
    NULL,
    'Active'
FROM `roles` r
WHERE r.role_name = 'Super Admin';
