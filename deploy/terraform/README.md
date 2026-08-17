# Terraform: provision a relay VM

Minimal, sanitized example that stands up a VM running the self-hosted Buzz/Nostr relay
stack (via `../cloud-init.yaml`). **A template, not a turnkey production module.**

> **Cost warning.** `terraform apply` provisions **billable** cloud resources (a VM, disk,
> egress). You own that cost. Run `terraform destroy` when you are done testing.

## Use

```bash
cd deploy/terraform
cp terraform.tfvars.example terraform.tfvars   # edit: region, ssh_key_name, your IP
terraform init
terraform plan      # review what will be created
terraform apply     # provisions the VM; cloud-init brings the relay up on boot
terraform output    # prints the wss endpoint + ssh command
# ... test ...
terraform destroy   # tear it down
```

The relay comes up on `wss://<public-ip>:3000`. Point Buzz clients/agents there.

## Security defaults

- **Lock SSH.** Set `ssh_allowed_cidrs` to your own IP (e.g. `["203.0.113.4/32"]`). It
  defaults to empty (blocks all SSH) so you make an explicit choice.
- **Restrict the relay** for a private test: set `relay_allowed_cidrs` to known IPs instead
  of `0.0.0.0/0`.
- **No secrets in state.** Relay/datastore secrets are generated on the VM by cloud-init and
  never pass through Terraform. `terraform.tfvars` and `*.tfstate` are gitignored — never
  commit them.

## Swapping clouds

The portable part is `../cloud-init.yaml`; it runs on any cloud's VM. To target GCP,
DigitalOcean, Hetzner, etc.:

1. Replace the `aws` provider + `aws_instance` + `aws_security_group` with that provider's VM
   and firewall resources.
2. Keep passing `cloud-init.yaml` as the instance's user-data / startup script.
3. Keep the same two open ports (SSH, relay) and the same outputs.

Nothing else changes — the relay bootstrap is provider-agnostic.

## Note

The relay image in `../compose.yaml` is a placeholder (`ghcr.io/block/buzz-relay:latest`).
Pin it to the upstream Buzz relay image/tag you are evaluating (`github.com/block/buzz`)
before relying on this.
