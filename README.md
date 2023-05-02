# Finvoice Code Challenge

The repo contains my submission to the Finvoice Rails API code challenge.

## Requirements

- Ruby version 2.7.0 or later

## Quick Start

Run the following commands to run the project locally

```
bundle install
rails s
```

## Tests

The following gems are used to to help with writing tests:

- rspec
- factory_bot_rails
- rails-controller-testing
- shoulda-matchers
- faker

Run `rspec` in the project root to run the test suite.

I prioritized writing tests for the Invoice model and controller, as they contain the core application logic. However, if given more time, I would add tests for all the remaining routes and models.

## Resources

All standard CRUD routes are available for each of the resources

### Invoice

- invoice_id (string): unique identifier for the invoice
- amount (decimal): total amount due on the invoice
- fee_percentage (decimal): percentage charged on accrued fees
- due_date (date): date by which the invoice must be paid
- status (integer): current status of the invoice; can be one of the following values:
  - 0: created
  - 1: approved
  - 2: purchased
  - 3: closed
  - 4: rejected
- invoice_scan (binary): binary representation of the invoice scan
- client_id (integer): foreign key to the associated client record
- created_at (datetime): timestamp for when the record was created
- updated_at (datetime): timestamp for when the record was last updated

### Client

- name (string): name of the client
- created_at (datetime): timestamp for when the record was created
- updated_at (datetime): timestamp for when the record was last updated

### Fee

- invoice_id (integer): foreign key to the associated invoice record
- amount (float): fee amount charged daily
- purchase_date (date): the date at which the invoice was purchased (i.e status changed to "purchased")
- end_date (date): the date at which the invoice was closed (i.e status changed to "closed")
- created_at (datetime): timestamp for when the record was created
- updated_at (datetime): timestamp for when the record was last updated

### Features

- ✅ Users can create clients and invoices
- ✅ Users can make valid status updates to invoices
- ✅ Users are not allowed to make invalid status updates
- ✅ Fees are created when an invoice status changes to "purchased"
- ✅ Fees are updated to have an end date when their associated invoice status is changed to "closed"
