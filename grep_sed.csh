#!/bin/csh -f

# This script grep files with given "STRING", pipe file names to STDIN, and use sed to edit STDIN file.
# So, we can edit matching STRING to NEW_STRING in any directory/ any file!
# see more: https://theoryapp.com/searching-and-replacing-with-grep-and-sed/

# Below is an EXAMPLE:
# grep -rl somematchstring somedir/ | xargs sed -i 's/somematchstring/somereplacestring/g'

set orig_str = "run_ens_icbc.csh_haoxing"
set new_str = "run_ens_icbc.csh"
set wkd = "/share/home/lililei4/haoxing/chem_source_DA/scripts_2022summer"

echo `grep -rl $orig_str $wkd/*.csh`

grep -rl $orig_str $wkd/*.csh | xargs sed -i "s/$orig_str/$new_str/g"
