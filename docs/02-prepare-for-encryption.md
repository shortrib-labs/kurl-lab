# Prepare for encryption

This repository stores some of your secrets. The original versions in my source
reposiotory are encrytped using [SOPS](/mozilla/sops) and
[GPG](https://gnupg.org). All the cool kids use AGE with SOPS, but since I have
a hardware backed PGP key that's the way I went. This instructions assume
you're using GPG and a brand new key. If you want to use AGE or an existing key
that's cool, you can probably sort out what needs to change pretty easily.

First we'll create our key, then we'll change the SOPS configuration to use 
that key for encryption instead of mine.

1. #Create the key for your email and name

```bash
export KEY_NAME="your@email.tld"
export KEY_COMMENT="You Name Here"

gpg --batch --full-generate-key <<EOF
%no-protection
Key-Type: 22
Key-Curve: cv25519
Subkey-Type: 22
Subkey-Curve: cv25519
Expire-Date: 0
Name-Comment: ${KEY_COMMENT}
Name-Real: ${KEY_NAME}
EOF
```

2. Export the public key to overwrite the file `.sops.asc` at the root of the
   repository. This will allow you to encrypt files on any system witout moving
   your secret key to it.

```bash
gpg --list-secret-keys "${KEY_NAME}"
```

Look for a pair of lines like this:

```
sec   ed25519 2020-09-06 [SC]
      420FB4E016EF66D1A4AF58970805EEDF0FEA6ACD
```

```bash
export KEY_FP=420FB4E016EF66D1A4AF58970805EEDF0FEA6ACD
```

Your fingerprint will be different from mine, since you've generated your own
key.

3. Make sure you are using your new key with SOPS

``bash
yq -i ".creation_rules[].pgp = \"${KEY_FP}\"" .sops.yaml
```

Next: [Set your parameters](03-set-parameters.md)
