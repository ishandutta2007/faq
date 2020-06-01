#### email

Send email from command line

    # with mail
    ( cat body-message.txt; uuencode attachment1.txt attachment2.txt ) \
     | mail -s "Here goes subject" name@gmail.com

    # with mailx
    mailx -q body-message.txt -s "Here goes subject" -a attachment1.txt name@gmail.com 
