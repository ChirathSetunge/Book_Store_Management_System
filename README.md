# Book Store Management System
The Book Haven database supports core online store operations: customer registration, order placement, inventory management, supplier management, payment processing (online and bank transfer), and delivery tracking. The design supports partial payments, multi-valued contacts, and both book and stationery product lines.

---

## Conceptual Design

### Main Entities

- **Customer:** Stores customer details and multiple contact numbers.
- **OnlineOrder:** Captures orders, links to customers, items, payments, and deliveries.
- **Item:** Abstracts both books and stationery, with specializations for each.
- **Supplier:** Manages supplier details and multiple contacts.
- **Payment:** Supports both online and bank transfer payments.
- **Delivery:** Tracks delivery details and status.

### Key Relationships & Multiplicity

- Customers can place multiple orders and make multiple payments.
- Orders may include multiple items (books or stationery).
- Items can be supplied by multiple suppliers.
- Payments confirm orders; deliveries are linked to orders and customers.
- Specializations and many-to-many relationships are handled via associative tables (e.g., BookOrderItem, StationeryOrderItem, BookItemSupplier)[1].

### Assumptions

- Only books and stationery are sold.
- Domestic shipping only.
- Customers may use multiple contact numbers and delivery addresses.
- Orders and deliveries have predefined status values.
- Partial payments are allowed, but items are delivered only after full payment.

---

## Relational Schema & Assumptions

- **Normalization:** All tables are normalized to eliminate redundancy and ensure referential integrity.
- **Specializations:** BookItem and StationeryItem inherit from Item.
- **Multi-valued attributes:** Contact numbers for customers and suppliers are stored in separate tables.
- **Many-to-many relationships:** Managed via associative tables (e.g., BookOrderItem, StationeryOrderItem).
- **Foreign Keys:** Enforced for all relevant relationships to maintain data consistency

## Author

Chirath Setunge 
