import dns.resolver
import sys

# Make sure you have dnspython installed

name = sys.argv[1]
for qtype in [
    "A",
    "AAAA",
    "APL",
    "CAA",
    "CDNSKEY",
    "CDS",
    "CERT",
    "CNAME",
    "CSYNC",
    "DLV",
    "DNAME",
    "DNSKEY",
    "DS",
    "HTTPS",
    "IPSECKEY",
    "KEY",
    "LOC",
    "MX",
    "NS",
    "OPENPGPKEY",
    "PTR",
    "RP",
    "RRSIG",
    "SMIMEA",
    "SOA",
    "SRV",
    "SSHFP",
    "SVCB",
    "TA",
    "TLSA",
    "TXT",
    "URI",
]:
    answer = dns.resolver.resolve(name, qtype, raise_on_no_answer=False)
    if answer.rrset is not None:
        print(answer.rrset)
