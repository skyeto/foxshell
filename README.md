# Foxshell

Tiny SSH server

## Development
```bash
# Run
mix deps.get
mix run --no-halt

# Connect
ssh localhost -p1234
```

## Deployment

```bash
# Build release
git clone https://github.com/skyeto/foxshell
cd foxshell
MIX_ENV=prod mix release
cd ..

# Create archive and copy
tar -cvf foxshell.tar foxshell
rsync foxshell.tar [remote ssh]:~/test.tar

# Run
_build/prod/rel/foxshell/bin/foxshell start
```