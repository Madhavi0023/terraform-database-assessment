INSERT INTO hotel_bookings (
    id,
    org_id,
    hotel_id,
    city,
    checkin_date,
    checkout_date,
    amount,
    status,
    created_at
)
SELECT
    gen_random_uuid(),
    CASE
        WHEN gs % 3 = 0 THEN '11111111-1111-1111-1111-111111111111'::UUID
        WHEN gs % 3 = 1 THEN '22222222-2222-2222-2222-222222222222'::UUID
        ELSE '33333333-3333-3333-3333-333333333333'::UUID
    END,
    'HOTEL-' || gs,
    CASE
        WHEN gs % 5 = 0 THEN 'Delhi'
        WHEN gs % 5 = 1 THEN 'Mumbai'
        WHEN gs % 5 = 2 THEN 'Jaipur'
        WHEN gs % 5 = 3 THEN 'Pune'
        ELSE 'Bangalore'
    END,
    CURRENT_DATE + (gs % 10),
    CURRENT_DATE + (gs % 10) + 2,
    (1000 + gs * 100),
    CASE
        WHEN gs % 4 = 0 THEN 'CONFIRMED'
        WHEN gs % 4 = 1 THEN 'PENDING'
        WHEN gs % 4 = 2 THEN 'CANCELLED'
        ELSE 'FAILED'
    END,
    NOW() - (gs || ' days')::INTERVAL
FROM generate_series(1,100) AS gs;