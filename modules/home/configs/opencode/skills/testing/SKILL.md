---
name: testing
description: Apply strict fail-fast testing practices with boundary validation, explicit contracts, meaningful failure tests, and no fallback-driven or over-defensive test design.
compatibility: opencode
metadata:
audience: developers
focus: testing
---

---

# Testing Philosophy

Use this skill whenever writing, reviewing, or modifying tests.

The goal is to test real behavior and explicit contracts, not implementation accidents, defensive fallbacks, or artificially tolerant behavior.

Tests should make incorrect assumptions fail clearly. They should not normalize broken inputs, hide invalid states, or prove that code survives impossible conditions unless those conditions are part of the domain.

## Core Principles

### Test contracts, not internals

Prefer tests that verify public behavior through the module, service, API, command, or component boundary.

Do not test private methods directly. If private logic is complex enough to need direct tests, extract it into a separate unit with its own public contract.

**Bad:**

```php
public function test_private_discount_calculation(): void
{
    $service = new OrderService();

    $result = $this->callPrivateMethod($service, 'calculateDiscount', [100]);

    $this->assertSame(10, $result);
}
```

**Good:**

```php
public function test_it_applies_discount_to_eligible_order(): void
{
    $order = $this->orders->createEligibleOrder(total: Money::from(100));

    $pricedOrder = $this->service->price($order);

    $this->assertTrue($pricedOrder->discount()->equals(Money::from(10)));
}
```

### Validate boundaries once

Tests should confirm that invalid external input is rejected at the boundary.

After boundary validation, internal tests should use valid typed inputs and should not repeatedly test impossible malformed states.

**Bad:**

```php
public function test_service_handles_missing_user_id(): void
{
    $result = $this->service->createOrder([
        'product_id' => 'product-1',
    ]);

    $this->assertNull($result);
}
```

**Good:**

```php
public function test_request_requires_user_id(): void
{
    $response = $this->postJson('/orders', [
        'product_id' => 'product-1',
        'quantity' => 1,
    ]);

    $response->assertUnprocessable();
    $response->assertJsonValidationErrors(['user_id']);
}
```

### Do not test fallback behavior unless fallback behavior is explicit domain behavior

Do not add tests that expect fake defaults, placeholder values, silent empty collections, or fallback data unless the specification explicitly requires that behavior.

**Bad:**

```php
public function test_missing_currency_defaults_to_usd(): void
{
    $order = $this->service->create([
        'product_id' => 'product-1',
        'quantity' => 1,
    ]);

    $this->assertSame('USD', $order->currency);
}
```

**Good:**

```php
public function test_currency_is_required(): void
{
    $response = $this->postJson('/orders', [
        'product_id' => 'product-1',
        'quantity' => 1,
    ]);

    $response->assertUnprocessable();
    $response->assertJsonValidationErrors(['currency']);
}
```

**Good, if the domain explicitly defines a default:**

```php
public function test_currency_defaults_to_usd_for_domestic_orders(): void
{
    $order = $this->service->createDomesticOrder(
        productId: ProductId::fromString('product-1'),
        quantity: Quantity::fromInt(1),
    );

    $this->assertTrue($order->currency()->equals(Currency::USD));
}
```

### Do not test that code was written

Avoid tests that merely repeat the implementation, model fields, constants, route names, enum cases, configuration values, or class structure.

These tests do not verify behavior. They usually fail only when someone intentionally changes the code, and they force the test suite to be updated without catching a real bug.

Tests should prove that the system behaves correctly, not that a class contains the same fields the test author copied from the class.

**Bad:**

```python
class Product(models.Model):
    name = models.CharField(max_length=255)
    price = models.DecimalField(max_digits=10, decimal_places=2)
    sku = models.CharField(max_length=64, unique=True)
```

```python
def test_product_has_name_field():
    assert hasattr(Product(), "name")


def test_product_has_price_field():
    assert hasattr(Product(), "price")


def test_product_has_sku_field():
    assert hasattr(Product(), "sku")
```

These tests only mirror the model definition. They do not prove that products can be created, priced, searched, validated, or used by the application.

**Good:**

```python
def test_product_requires_unique_sku(db):
    Product.objects.create(
        name="Stimpack",
        price=Decimal("25.00"),
        sku="STIM-001",
    )

    with pytest.raises(IntegrityError):
        Product.objects.create(
            name="Stimpack Copy",
            price=Decimal("25.00"),
            sku="STIM-001",
        )
```

This verifies meaningful behavior: the application cannot persist two products with the same SKU.

**Good:**

```python
def test_product_price_must_be_positive():
    with pytest.raises(ValidationError):
        Product(
            name="Stimpack",
            price=Decimal("-1.00"),
            sku="STIM-001",
        ).full_clean()
```

This verifies a business invariant.

### Avoid reflection-based field tests

Do not use reflection, introspection, or metadata checks to assert that fields, methods, routes, properties, or enum values exist unless the existence itself is part of the public contract.

**Bad:**

```python
def test_product_model_fields():
    field_names = [field.name for field in Product._meta.fields]

    assert "name" in field_names
    assert "price" in field_names
    assert "sku" in field_names
```

**Good:**

```python
def test_product_can_be_found_by_sku(db):
    product = Product.objects.create(
        name="Stimpack",
        price=Decimal("25.00"),
        sku="STIM-001",
    )

    found = Product.objects.get(sku="STIM-001")

    assert found == product
```

### Test behavior, not shape

A test should usually answer one of these questions:

- What user-visible or domain-visible behavior does this guarantee?
- What business rule does this protect?
- What failure mode does this intentionally catch?
- What integration contract does this verify?
- What regression would this test catch?

If the only answer is “it proves the field exists,” “it proves the method exists,” or “it proves the code looks the way it currently looks,” do not write the test.

**Bad:**

```python
def test_order_has_status_field():
    assert hasattr(Order(), "status")
```

**Good:**

```python
def test_new_order_starts_pending(db):
    order = Order.objects.create(
        customer=create_customer(),
        total=Money("100.00", "USD"),
    )

    assert order.status == OrderStatus.PENDING
```

This verifies domain behavior: newly created orders start in the pending state.

### Prefer explicit fixtures over magic factories

Factories are fine, but avoid hidden defaults that make tests unclear.

A reader should be able to see which data matters for the behavior under test.

**Bad:**

```php
public function test_admin_can_publish_post(): void
{
    $user = User::factory()->create();
    $post = Post::factory()->create();

    $this->assertTrue($this->policy->publish($user, $post));
}
```

**Good:**

```php
public function test_admin_can_publish_post(): void
{
    $user = User::factory()->admin()->create();
    $post = Post::factory()->draft()->create();

    $this->assertTrue($this->policy->publish($user, $post));
}
```

### Name tests after behavior

Test names should describe the behavior being specified.

Avoid vague names like `test_create_order`, `test_validation`, or `test_success`.

**Bad:**

```php
public function test_create_order(): void
{
    // ...
}
```

**Good:**

```php
public function test_it_creates_an_order_for_a_valid_checkout_command(): void
{
    // ...
}
```

### Use one reason to fail per test

A test may have multiple assertions when they verify one coherent behavior.

Avoid tests that verify unrelated behavior in one method.

**Bad:**

```php
public function test_order_flow(): void
{
    $order = $this->service->create($this->validCommand());

    $this->assertSame(OrderStatus::Pending, $order->status());
    $this->assertDatabaseHas('orders', ['id' => $order->id()]);
    $this->assertQueued(OrderConfirmationMail::class);
    $this->assertLogged('order_created');
}
```

**Good:**

```php
public function test_it_creates_order_as_pending(): void
{
    $order = $this->service->create($this->validCommand());

    $this->assertSame(OrderStatus::Pending, $order->status());
}

public function test_it_sends_order_confirmation_after_order_creation(): void
{
    Mail::fake();

    $order = $this->service->create($this->validCommand());

    Mail::assertQueued(OrderConfirmationMail::class);
}
```

### Test meaningful failures

Do not only test happy paths. Test failures that are part of the contract or domain.

Good failure tests include:

- Invalid boundary input
- Unauthorized access
- Unavailable required resource
- Violated business invariant
- Rejected command
- Failed domain precondition
- External dependency failure when there is defined recovery behavior

Do not test random impossible values inside internal code that cannot occur after validation.

**Bad:**

```php
public function test_order_service_handles_null_command(): void
{
    $result = $this->service->create(null);

    $this->assertNull($result);
}
```

**Good:**

```php
public function test_it_rejects_order_when_product_is_out_of_stock(): void
{
    $product = Product::factory()->outOfStock()->create();

    $this->expectException(ProductOutOfStockException::class);

    $this->service->create(new CreateOrderCommand(
        productId: ProductId::fromString($product->id),
        quantity: Quantity::fromInt(1),
    ));
}
```

### Do not swallow errors in tests

Tests should not catch exceptions unless asserting something specific about the exception.

**Bad:**

```php
public function test_import(): void
{
    try {
        $this->importer->import($this->validFile());
        $this->assertTrue(true);
    } catch (Throwable $e) {
        $this->assertTrue(false);
    }
}
```

**Good:**

```php
public function test_it_imports_a_valid_file(): void
{
    $this->importer->import($this->validFile());

    $this->assertDatabaseHas('imports', [
        'status' => ImportStatus::Completed,
    ]);
}
```

**Good, when testing the exception itself:**

```php
public function test_it_rejects_files_with_missing_required_columns(): void
{
    $this->expectException(MissingRequiredColumnException::class);

    $this->importer->import($this->fileMissingRequiredColumns());
}
```

### Avoid over-mocking

Mock only architectural boundaries:

- External APIs
- Mail
- Queues
- Notifications
- Payment providers
- Filesystem
- Time
- Random values
- Slow or nondeterministic dependencies

Do not mock value objects, entities, simple services, collections, or code you own just to isolate every class.

**Bad:**

```php
public function test_total(): void
{
    $lineItem = Mockery::mock(LineItem::class);
    $lineItem->shouldReceive('total')->andReturn(Money::from(100));

    $order = new Order([$lineItem]);

    $this->assertTrue($order->total()->equals(Money::from(100)));
}
```

**Good:**

```php
public function test_order_total_is_sum_of_line_items(): void
{
    $order = new Order([
        new LineItem(Money::from(40), Quantity::fromInt(1)),
        new LineItem(Money::from(30), Quantity::fromInt(2)),
    ]);

    $this->assertTrue($order->total()->equals(Money::from(100)));
}
```

### Prefer deterministic tests

Tests must not depend on real time, random values, network state, execution order, or existing database state.

Inject or freeze nondeterministic values.

**Bad:**

```php
public function test_trial_expires_in_14_days(): void
{
    $trial = Trial::start();

    $this->assertSame(now()->addDays(14)->toDateString(), $trial->expiresAt()->toDateString());
}
```

**Good:**

```php
public function test_trial_expires_14_days_after_start_date(): void
{
    Carbon::setTestNow('2026-01-01 10:00:00');

    $trial = Trial::start();

    $this->assertSame('2026-01-15', $trial->expiresAt()->toDateString());
}
```

### Use precise assertions

Avoid vague assertions like `assertNotNull`, `assertTrue`, or snapshot-only tests when a more precise assertion is available.

**Bad:**

```php
public function test_user_is_created(): void
{
    $user = $this->service->create($this->validCommand());

    $this->assertNotNull($user);
}
```

**Good:**

```php
public function test_user_is_created_with_email_address(): void
{
    $user = $this->service->create($this->validCommand(email: 'nico@example.com'));

    $this->assertSame('nico@example.com', $user->email()->toString());
}
```

### Keep setup explicit and minimal

Each test should create only the data required for that behavior.

Avoid large shared setup methods that hide important preconditions.

**Bad:**

```php
protected function setUp(): void
{
    parent::setUp();

    $this->user = User::factory()->admin()->verified()->create();
    $this->product = Product::factory()->active()->inStock()->create();
    $this->coupon = Coupon::factory()->valid()->create();
    $this->address = Address::factory()->create();
}
```

**Good:**

```php
public function test_verified_admin_can_publish_post(): void
{
    $user = User::factory()->admin()->verified()->create();
    $post = Post::factory()->draft()->create();

    $this->assertTrue($this->policy->publish($user, $post));
}
```

### Test observable side effects

When behavior includes persistence, emitted events, queued jobs, mail, notifications, or logs, assert those observable effects explicitly.

**Bad:**

```php
public function test_order_created(): void
{
    $this->service->create($this->validCommand());

    $this->assertTrue(true);
}
```

**Good:**

```php
public function test_it_dispatches_order_created_event(): void
{
    Event::fake();

    $order = $this->service->create($this->validCommand());

    Event::assertDispatched(OrderCreated::class, function (OrderCreated $event) use ($order) {
        return $event->orderId->equals($order->id());
    });
}
```

### Avoid testing framework behavior

Do not write tests that mostly prove Laravel, Symfony, PHPUnit, Pest, React, Vue, Django, pytest, or another framework works.

Focus on application-specific behavior.

**Bad:**

```php
public function test_route_returns_200(): void
{
    $response = $this->get('/dashboard');

    $response->assertOk();
}
```

**Good:**

```php
public function test_dashboard_shows_pending_orders_for_current_user(): void
{
    $user = User::factory()->create();
    $order = Order::factory()->for($user)->pending()->create();

    $response = $this->actingAs($user)->get('/dashboard');

    $response->assertOk();
    $response->assertSee($order->number);
}
```

### Keep tests readable over clever

Duplication is acceptable in tests when it makes the scenario clearer.

Do not over-abstract test setup into helpers, builders, or traits unless the abstraction improves readability.

**Bad:**

```php
public function test_policy(): void
{
    $this->assertPolicyResult('publish', true, ['admin', 'verified'], ['draft']);
}
```

**Good:**

```php
public function test_verified_admin_can_publish_draft_post(): void
{
    $user = User::factory()->admin()->verified()->create();
    $post = Post::factory()->draft()->create();

    $this->assertTrue($this->policy->publish($user, $post));
}
```

## Review Checklist

Before considering test work complete:

- The happy path is covered.
- Important domain failures are covered.
- Boundary validation is covered at the boundary.
- No test expects silent fallbacks unless the domain explicitly requires them.
- No test merely proves that code was written.
- No test mirrors model fields, class structure, enum cases, constants, routes, or configuration without behavior.
- No test catches exceptions unless asserting the exception.
- No test relies on real time, random values, network state, external services, execution order, or existing database state.
- Assertions are precise.
- Mocks are limited to true architectural boundaries.
- Setup is explicit and minimal.
- The test name describes behavior.
- The full relevant test suite passes.
