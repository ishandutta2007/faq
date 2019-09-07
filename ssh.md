#### SSH

Test ssh access

    ssh -T -v git@git.test.com

Add domains handling

    # content of ~/.ssh/config (it should be chmod 0600)
    CanonicalizeHostname yes
    CanonicalDomains domain.company.com

Set passwordless access

    ssh-keygen -t rsa
    cat .ssh/id_rsa.pub | ssh user@remote 'cat >> .ssh/authorized_keys'


