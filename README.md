# Library Management API

## User Roles

- **Librarian**: Can manage books and view all borrows.
- **Member**: Can borrow/return books and view their own borrows.

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

#### Search Books

**GET /api/v1/books/search?query=Ruby**

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
