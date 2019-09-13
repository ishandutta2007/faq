#### SSH

Test ssh access

    ssh -T -v git@git.test.com

Add domains handling

    # content of ~/.ssh/config (it should be chmod 0600)
    CanonicalizeHostname yes
    CanonicalDomains domain.company.com

Set passwordless access

    ssh-keygen -t rsa
    cat ~/.ssh/id_rsa.pub | ssh user@remote 'cat >> .ssh/authorized_keys'

Handle different keys for different hosts

    Host git.domain.com
     IdentityFile ~/.ssh/id_rsa.git
     IdentitiesOnly yes

Batch mode

    for box in $(cat box.list.csv | awk -F',' '{print $1}' | sed 's/"//g')
    do
     command="ifconfig | grep enp2s0 >/dev/null && echo ${box}"
     ssh-keygen -R ${box} 2>/dev/null
     ssh-keyscan -H ${box} >> ~/.ssh/known_hosts 2>/dev/null
     ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=1 ${box} "${command}"
    done

