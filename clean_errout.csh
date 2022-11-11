#!/bin/csh -f
set f_list = ""

foreach fname (*.err *.out log.* output.*)
    set tmp = `ls $fname`
    set f_list = "$f_list $tmp"
end

echo $f_list
echo "Delete these file? (y/n)"
set cmd=$<
switch ($cmd)
    case 'y':
        echo "DELETE START"
        rm $f_list
        breaksw
    case 'n':
        echo "NOT DELETE"
        breaksw
    default:
        echo "NOT DELETE"
        breaksw
endsw

echo "FINISH"