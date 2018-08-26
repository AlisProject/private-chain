# run
```bash
# Add private key to ~/.ssh/private-chain

# Add requirements 
ansible-galaxy install -p ./roles -r requirements.yml

# Execute
ansible-playbook -i hosts site.yml

# Specify
ansible-playbook -i hosts site.yml -l parity-poa --start-at "Install lsyncd" --step
ansible-playbook -i hosts site.yml -l parity-poa --tags "tmp"
```
