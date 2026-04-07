# Roadmap

## Blocked — Subscription Restriction

### `app_service_domain` — Domain purchase not available on all subscriptions

**Module:** `modules/azure/app_service_domain/`
**API:** `Microsoft.DomainRegistration/domains` (2024-11-01)
**Status:** Module implemented, blocked on subscription capability

The `Microsoft.DomainRegistration` API returns a 500 with:

```
DomainResellerWebService_DIRECT_CLIENT_CERT_AUTH_DISABLED
Direct client certificate authentication is disabled.
Please use certificate-based JWT authentication.
```

**Root cause:** Despite the misleading error message, this is **not** an auth issue. The same error occurs with a raw `curl` using a valid bearer token from `az account get-access-token`. The GoDaddy reseller backend that powers App Service Domain purchases is not enabled on the subscription. This is a known restriction on:
- Sandbox / lab subscriptions (e.g. MCAP, Visual Studio Enterprise)
- Subscriptions without a payment instrument that supports domain purchases
- Some Enterprise Agreement subscriptions

**Verified:** The REST provider sends the exact same token (CLI client ID `04b07795-...`) via the same ARM endpoint. The error is server-side, not client-side.

**To unblock:**
1. Use a production subscription with domain purchase capability enabled.
2. Purchase the domain via Azure Portal or CLI on a supported subscription, then manage DNS/email via this config with `check_existance = true`.
3. Use an external domain registrar and only manage DNS zones + records through this config.

**Workaround (current):** Remove the `azure_app_service_domains` block, use a domain purchased elsewhere, and hardcode the domain name in `azure_dns_zones` and `azure_email_communication_service_domains`.
