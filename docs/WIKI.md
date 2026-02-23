
# terraform-demo — Project Wiki

Index
- Overview
- Architecture thinking (why variables, tfvars, modules, folders)
- Resource relationships (example: Resource Group ⇄ VNet)
- How to add parameterized values (step-by-step)
- Environment strategy (env-specific `*.tfvars` and backends)
- Module & repo layout (index + details)
- Quick commands & troubleshooting

Overview
This repository contains a Terraform demo with a root configuration and a reusable `rg` module. The intention is to demonstrate a small, modular pattern you can extend for multiple environments.

Architecture thinking — why this structure
- Variables and `*.tfvars`:
  - Purpose: separate configuration from code so the same templates can be reused across environments and teams.
  - Why add parameters: parameters make the configuration declarative and configurable without editing `.tf` files. This enables automation, safer reviews, and fewer human errors.
  - `var.tf` vs `terraform.tfvars`: `var.tf` declares variables and types/defaults; `terraform.tfvars` (or `env`.tfvars) provides concrete values per environment.
- Subfolders for resources (modules):
  - Purpose: encapsulation and reuse. Each subfolder (for example, `rg/`) is a module that owns a specific concern (resource group creation, tagging, etc.).
  - Benefits: easier testing, clearer ownership, smaller diffs, and the ability to reuse across multiple stacks.
- Environment-wise `tfvars` reasoning:
  - Use separate `dev.tfvars`, `stage.tfvars`, `prod.tfvars` to keep environment differences explicit (size, naming, CIDR ranges, tags).
  - Keep secrets out of these files — use secure variable injection in CI/CD or secret stores.

Resource relationships (example)
- Resource Group (RG): a logical container for resources. It provides a lifecycle and scope for access control.
- Virtual Network (VNet): a network boundary inside which subnets and network interfaces are created.
- Relationship example:
  - The `rg` module creates an RG. The root config or another module creates the VNet inside that RG by using the RG name/id as an input.
  - Reasoning: separating the RG into a module lets other modules (network, compute, storage) accept the RG as an input and create resources scoped to that RG.
  - Consequence: to move resources between RGs you must update inputs/vars and perform a controlled `terraform plan`/`apply`.

How to add parameterized values — a short guide
1. Decide the parameter scope: root-level (global) or module-level.
2. Add the variable declaration in the appropriate `var.tf` file. Example for module:

```
variable "vnet_cidr" {
  type    = string
  default = "10.0.0.0/16"
  description = "CIDR for the primary VNet"
}
```

3. Use the variable in resources: `cidr_block = var.vnet_cidr` (or provider-specific attribute).
4. Provide environment values in `dev.tfvars` / `stage.tfvars` / `prod.tfvars`, or add to `terraform.tfvars` for local testing.
5. Run `terraform plan -var-file=dev.tfvars` to validate.

Example: add a new module input for `rg` module
1. Edit `rg/var.tf` and add the variable declaration (see step 2).
2. Update `rg/main.tf` to reference the variable and use it in the resource block.
3. Update the root `modules.tf` module block to pass the value: `vnet_cidr = var.vnet_cidr` (or a literal for quick tests).

Environment strategy and backend recommendations
- Local state is OK for experiments, but for team use set up a remote backend (Azure Storage, S3, or Terraform Cloud). Remote backends enable locking and safe collaboration.
- Store backend configuration outside of source control or use partial configuration with environment variables.
- Keep `dev.tfvars` in the repo only if it contains non-sensitive example values; otherwise exclude and document how to supply secrets.

Module and repo layout — index and details
- Root files:
  - `main.tf` — provider and top-level resources or module calls
  - `modules.tf` — module instantiation and wiring
  - `var.tf` — root-level variables and defaults
  - `terraform.tfvars` — local example values (do not store secrets)
  - `Output.tf` — outputs the root module exposes
- Module `rg/`:
  - `rg/var.tf` — module inputs (e.g., `name`, `location`, `tags`)
  - `rg/main.tf` — resources (e.g., `azurerm_resource_group` or provider equivalent)
  - `rg/output.tf` — outputs (e.g., `rg_name`, `rg_id`)

Quick commands
```
terraform init
terraform fmt
terraform validate
terraform plan -var-file=dev.tfvars
terraform apply -var-file=dev.tfvars
```

Troubleshooting & best practices
- Do not commit `terraform.tfstate` or backups. Add them to `.gitignore` if not already ignored.
- Use `terraform state` commands for repairs — avoid manual edits.
- Run `terraform fmt` and `terraform validate` before commits or in CI.
- Add small, focused change sets: add a variable, test with `plan`, then `apply`.

Guide for contributors — checklist for adding new parameterized values
- 1) Add variable to the appropriate `var.tf` (module or root) with description & type.
- 2) Add the variable usage in resource definitions.
- 3) Add example values to the appropriate `*.tfvars` file for each environment (avoid secrets).
- 4) Run `terraform fmt` and `terraform validate`.
- 5) Create a PR and include a short example `plan` showing the expected changes.

Next steps
- Create per-module `README.md` files describing inputs/outputs for quick reference.
- Add CI to run `terraform fmt`, `terraform validate`, and `terraform plan`.

