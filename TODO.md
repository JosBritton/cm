# Todo
## DNS
- Implement DNSSEC signing on authoritative-zones and validate DNSSEC on all servers (with trust-anchors?).
- Multi-master config with dynamic-syncing
  1. Determine which host has the newest zone (by comparing serial)
  2. Freeze other host(s)
  3. Transfer using ansible "slurp"
  4. Reload zone `rndc reload example.org`
- Implement update process for config file via `rndc reconfig`, in case of server exit due to error
  restart service.
- Implement `named-checkconf` testing before finalizing conf or zone templating
  This is important as certain zone config errros will not result in an exit code >1 for status commands,
  even `rndc zonestatus 'example.org'` as may be expected.
- Add tests for canonical hostname in {{ inventory_hostname }} of records in `ns_auth_primary`

## DHCP
- Implemenet `kea-dhcp <module> -t <filename>` testing before templating.
