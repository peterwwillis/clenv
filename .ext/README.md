# About

# Testing

## Shellcheck
```bash
make shellcheck
```

## Local testing
```bash
clenv -l aws2050 || ../clenv -n aws2050
DEBUG=1 CLENV_HTTP_PATH=file://`pwd`/.. clenv -I aws-cli-v2=2.0.50 aws2050
```
