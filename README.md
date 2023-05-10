# vault-enterpriseListNamespace
Script to list all namespaces for a Vault Enterprise or HCP Vault
You don't need to install the binary of HashiCorp Vault.
We will use the API directly

First you need to set all environments variables

```bash
export VAULT_ADDR=<adress_vault:port>
export VAULT_TOKEN=<token>
```

:warning: *For the address of Vault do not terminate the line with `/`*
:warning: *For the token you need to have admin role*

Exemple :

```bash
export VAULT_ADDR=http://127.0.0.1:8200
export VAULT_TOKEN=root
```

Add the possibility to run the script

```bash
chmod +x ListNamespaceVault.sh
```

Run the script without parameter

```bash
./ListNamespaceVault.sh
```

```texte
Return:
Default Root Namespace selected
All Namespaces listed in VaultNamespaceList.txt
```

This will create a file VaultNamespaceList.txt with all namespaces

You can also specify a Namespace

```bash
./ListNamespaceVault.sh <namespace>
```

```texte
Return :
Namespace: <namespace> selected
All Namespaces listed in VaultNamespaceList.txt
```
