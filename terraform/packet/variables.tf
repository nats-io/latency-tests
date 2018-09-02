# User must define this
variable auth_token {}

# project ID to use, found under project settings.  e.g. 9999999-abcd-ef00-1234-567abcde
variable project_id {}

#
# Machine type reference (July 2018)
#
# "c2.medium.x86","c2.medium.x86", "Our c2.medium.x86 configuration is an AMD 7401P EPYC server.",
# "m2.xlarge.x86","m2.xlarge.x86","Our m2.xlarge.x86 configuration is a...",
# "storage_1","Standard","TBD"
# "storage_2","Performance","TBD",
# "baremetal_2a","c1.large.arm","Our Type 2A configuration is a 96-core dual socket ARM 64 beast based on Cavium ThunderX chips",
# "baremetal_1","c1.small.x86","Our Type 1 configuration is a zippy general use server, with an Intel E3-1240 v3 processor and 32GB of RAM.",
# "baremetal_3","c1.xlarge.x86","Our Type 3 configuration is a high core, high IO server, with dual Intel E5-2640 v3 processors, 128GB of DDR4 RAM and ultra fast NVME flash drives.",
# "baremetal_2","m1.xlarge.x86","Our Type 2 configuration is the perfect all purpose virtualization server, with dual E5-2650 v4 processors, 256 GB of DDR4 RAM, and six SSDs totaling 2.8 TB of storage.",
# "baremetal_s","s1.large.x86","Our Type S server packs in 24TB of storage and is perfect for large object or file needs.",
# "baremetal_0","t1.small.x86", "Our Type 0 configuration is a general use \"cloud killer\" server, with a Intel Atom 2.4Ghz processor and 8GB of RAM.",
# "baremetal_1e", "x1.small.x86","Our Type 1e ...",

variable server_type {
  default = "baremetal_1"
}

variable client_type {
  default = "baremetal_1"
}

# As of 8/28/2018
# Toronto, ON, CA   "yyz1"
# Tokyo, JP         "nrt1"
# Atlanta, GA       "atl1"
# Hong Kong 1, HK   "hkg1"
# Los Angeles, CA   "lax1"
# Dallas, TX        "dfw1"
# Amsterdam, NL     "ams1"
# Parsippany, NJ    "ewr1"
# Singapore         "sin1"
# Sydney, Australia "syd1"
# Chicago, IL       "ord1"
# Ashburn, VA       "iad1"
# Sunnyvale, CA     "sjc1"
# Frankfurt, DE     "fra1"
# Seattle, WA       "sea1"
variable facility {
  default = "sjc1"
}
