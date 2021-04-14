### Usage
Add this to /etc/hosts:
```shell
10.222.42.64	aasasmt.aasa.com.pe
```
Fingerprint can be get from certificate by running this:
```shell
openssl x509 -fingerprint -in server.crt -noout
```

Now, run this command for registering a system to SMT
```shell
clientSetup4SMT.sh --host aasasmt.aasa.com.pe --fingerprint <FINGERPRINT> --yes
```

Finally, run this command for de-registering a system from SMT
```shell
clientSetup4SMT.sh --de-register --yes
```
