# About

# Testing

## Shellcheck
```bash
make shellcheck
```

## Local testing
```bash
cliv -l aws2050 || ../cliv -n aws2050
DEBUG=1 CLIV_HTTP_PATH=file://`pwd`/.. cliv -I aws-cli-v2=2.0.50 aws2050
```
