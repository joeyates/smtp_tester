SmtpTester
==========

Send emails via the command line to test interaction with SMTP servers.

```
mix smtp_tester.send \
  --server=mail.example.com \
  --from=me@example.com \
  --username=me@example.com
  --password=$PASSWORD
  --to=you@example.com
  --subject="The Subject"
  --file=priv/message.txt
```
