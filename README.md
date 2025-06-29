# Library Management API

## Starting up the project.

To start the project you just need to have Docker in your machine then run:

```sh
docker-compose up
```

After docker is up, you need to run the database create command `bin/rails db:create` and then run the migrations with `bin/rails db:migrate`, optionally you can seed the database with `bin/rails db:seed`.

This will start the Rails application and the PostgreSQL database. The application will be available at `http://localhost:3000`.

## User Roles

- **Librarian**: Can manage books, view all borrows and return books.
- **Member**: Can borrow books and view their own borrows.

---

## Authentication

All endpoints (except registration and login) require a Bearer token in the `Authorization` header.

---

## Endpoints

### User Registration

**POST /api/v1/users**

Registers a new user (Member or Librarian).

**Request Body**
```json
{
  "name": "Jane Doe",
  "email": "jane@doe.com",
  "password": "password123",
  "password_confirmation": "password123",
  "role": "member" // or "librarian"
}
```

**Response**
```json
{
  "token": "jwt_token_here"
}
```

---

### Login

**POST /api/v1/auth**

Authenticates a user and returns a JWT token.

**Request Body**
```json
{
  "email": "jane@doe.com",
  "password": "password123"
}
```

**Response**
```json
{
  "token": "jwt_token_here"
}
```

---

### Logout

**DELETE /api/v1/auth**

Logs out the user (token invalidation is handled client-side).

**Headers**
```
Authorization: Bearer jwt_token_here
```

**Response**
```json
{
  "message": "Logged out successfully"
}
```

---

### Books

#### List Books

**GET /api/v1/books**

- Members: Lists available books.
- Librarians: Lists all books.

### Search Books
**GET /api/v1/books?query=Ruby**
Returns a list of books matching the search query.

#### Show Book

**GET /api/v1/books/:id**

Returns details for a specific book.

#### Create Book (Librarian only)

**POST /api/v1/books**

```json
{
  "book": {
    "title": "Sample Book",
    "author": "Sample Author",
    "genre": "Fiction",
    "isbn": "1234567890",
    "copies": 3
  }
}
```

#### Update Book (Librarian only)

**PUT /api/v1/books/:id**

#### Delete Book (Librarian only)

**DELETE /api/v1/books/:id**

---

### Borrows

#### List Borrows

**GET /api/v1/borrows**

- Members: Lists their own borrows.
- Librarians: Lists all borrows.

#### Borrow a Book (Member only)

**POST /api/v1/borrows**

```json
{
  "borrow": {
    "book_id": 1
  }
}
```

#### Return a Book

**PATCH /api/v1/borrows/:id/return_book**

---

### Dashboard

**GET /api/v1/dashboard**

For librarians it returns statistics about the library, such as total books, total borrows, overdue books, etc.

For members it returns current borrows and with due dates and possible overdue books.


---

## Example: Authenticated Request

```sh
curl -H "Authorization: Bearer <token>" https://localhost:3000/api/v1/books
```

---

## Error Responses

- `401 Unauthorized`: Missing or invalid token.
- `403 Forbidden`: Insufficient permissions.
- `422 Unprocessable Entity`: Validation errors.

---

## Running Tests

```sh
bundle exec rspec
```
