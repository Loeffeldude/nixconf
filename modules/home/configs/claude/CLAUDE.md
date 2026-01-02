# Coding Guidelines

## No Emojis

Never use emojis in code responses, lists, or communication.

**Bad:**

```
✅ Tests passing
🚀 Deploy to production
```

**Good:**

```
Tests passing
Deploy to production
```

## Use Early Returns

Exit functions early to reduce nesting.

**Bad:**

```php
public function processUser(User $user): bool
{
    if ($user->isActive()) {
        if ($user->hasPermission('admin')) {
            if ($user->emailVerified()) {
                return $this->grantAccess($user);
            } else {
                return false;
            }
        } else {
            return false;
        }
    } else {
        return false;
    }
}
```

**Good:**

```php
public function processUser(User $user): bool
{
    if (!$user->isActive()) {
        return false;
    }

    if (!$user->hasPermission('admin')) {
        return false;
    }

    if (!$user->emailVerified()) {
        return false;
    }

    return $this->grantAccess($user);
}
```

## Extract Complicated Expressions

Assign complex expressions to named variables.

**Bad:**

```php
if ($request->user()->hasRole('admin') && $request->input('status') === 'active' && Carbon::parse($request->input('expires_at'))->isFuture()) {
    return true;
}
```

**Good:**

```php
$isAdmin = $request->user()->hasRole('admin');
$isActive = $request->input('status') === 'active';
$notExpired = Carbon::parse($request->input('expires_at'))->isFuture();

if ($isAdmin && $isActive && $notExpired) {
    return true;
}
```

## Prefer DTOs Over Untyped Data

Use data transfer objects instead of arrays.

**Bad:**

```php
public function createOrder(array $data): Order
{
    $order = new Order();
    $order->user_id = $data['user_id'];
    $order->product_id = $data['product_id'];
    $order->quantity = $data['quantity'];
    $order->price = $data['price'];
    return $order;
}
```

**Good:**

```php
class CreateOrderDTO
{
    public function __construct(
        public string $userId,
        public string $productId,
        public int $quantity,
        public float $price
    ) {}
}

public function createOrder(CreateOrderDTO $dto): Order
{
    $order = new Order();
    $order->user_id = $dto->userId;
    $order->product_id = $dto->productId;
    $order->quantity = $dto->quantity;
    $order->price = $dto->price;
    return $order;
}
```

## Be Terse in Communication

Keep responses brief and focused. Don't over-explain or add unnecessary commentary.

**Bad:**

```
I've successfully completed the implementation! The code now handles all edge cases
beautifully and follows best practices. I'm really excited about how clean this turned
out. Let me walk you through everything I did in great detail...
```

**Good:**

```
Done. The handler now validates input and returns appropriate errors.
```

## Line Count Doesn't Matter

Write clear, readable code. More lines is fine if it improves clarity.

**Bad:**

```php
return $user && $user->isActive() && $user->hasPermission('admin') && $user->emailVerified() ? $this->grantAccess($user) : false;
```

**Good:**

```php
if (!$user) {
    return false;
}

if (!$user->isActive()) {
    return false;
}

if (!$user->hasPermission('admin')) {
    return false;
}

if (!$user->emailVerified()) {
    return false;
}

return $this->grantAccess($user);
```

## Avoid Comments Unless Doing Something Unexpected

Only comment when code behavior is non-obvious.

**Bad:**

```php
// Get the user
$user = User::find($id);

// Check if user exists
if (!$user) {
    return null;
}

// Return the user's email
return $user->email;
```

**Good:**

```php
$user = User::find($id);

if (!$user) {
    return null;
}

return $user->email;
```

**Good (with justified comment):**

```php
// Using raw query because Eloquent doesn't support this specific JSON operation
$results = DB::select('SELECT * FROM users WHERE data->>\'status\' = ?', ['active']);

// Intentionally bypassing validation here because legacy data doesn't conform to new rules
$order->saveQuietly();
```

## Write Tests

When implementing a feature, always write tests. Never declare work done unless tests are passing. That's what tests are for.

**Bad:**

```
User: Add validation to the order creation endpoint
```
