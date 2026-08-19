# Validation Contract Rules

Date: 2026-04-01

Use these rules for validation, parsing, and schema-related tasks.

1. For each field, specify coverage for:
   - missing
   - wrong type
   - invalid value
2. Name distinct invalid-value classes explicitly when they differ semantically.
3. If a collection is returned, specify whether ordering matters and require a focused test if it does.
4. Do not rely on “valid enough” parser behavior when the contract requires canonical validation.
5. If a task says “validate each field,” the focused tests must cover the entire field table.
6. Distinguish parse failure from degraded-but-partially-readable state when operator truth depends on it.
