#!/bin/bash
#**Some tools to help edit files containing text**#
#ALL FUNCTIONS USE "function text patter|line file" AS INPUT
#ADD ABOVE
advTextEdit(){
#Check if file is a file
if [ -f "$4" ] && [ -n "$4" ]
    then
        F1L3="$(readlink -e $4)"
        T3MP="$(mktemp)"
	chmod a+rw $T3MP #If uses sudo to advTextEdit, makes it only root rw
        C0MMAND="$(echo "$1" | perl -ne 'print lc')"
    #ADD ABOVE    
        if [ "$C0MMAND" = "appendabove_pattern" ]; then
                awk -v insert="$2" -v search="$3" '$0 ~ search {print insert}1' $F1L3  > $T3MP
        elif [ "$C0MMAND" = "appendabove_line" ]; then
                awk -v insert="$2" -v line="$3" '{if (NR==line) print insert}1' $F1L3 > $T3MP
    #ADD BELOW
        elif [ "$C0MMAND" = "appendbelow_pattern" ]; then
                awk -v insert="$2" -v search="$3" '$0 ~ search {print;print insert;next}1' $F1L3 > $T3MP
        elif [ "$C0MMAND" = "appendbelow_line" ]; then
                awk -v insert="$2" -v line="$3" '{if (NR==line) print $0"\n"insert}1' $F1L3 > $T3MP
    #ADD TO END
        elif [ "$C0MMAND" = "appendtail_pattern" ]; then
                awk -v insert="$2" -v search="$3" '{if ($0 ~ search) print $0insert; else print $0}' $F1L3 > $T3MP
        elif [ "$C0MMAND" = "appendtail_line" ]; then
                awk -v insert="$2" -v line="$3" '{if (NR==line) print $0insert; else print $0}' $F1L3 > $T3MP
    #ADD BEFORE
        elif [ "$C0MMAND" = "appendhead_pattern" ]; then
                awk -v insert="$2" -v search="$3" '{if ($0 ~ search) print insert$0; else print $0}' $F1L3 > $T3MP
        elif [ "$C0MMAND" = "appendhead_line" ]; then
                awk -v insert="$2" -v line="$3" '{if (NR==line) print insert$0; else print $0}' $F1L3 > $T3MP
    #REPLACE
        elif [ "$C0MMAND" = "replacelinecontaining" ]; then
                awk -v insert="$2" -v search="$3" '{if ($0 ~ search) print insert; else print $0}' $F1L3 > $T3MP
        elif [ "$C0MMAND" = "replace_pattern" ]; then
                awk -v insert="$2" -v search="$3" '{gsub(/search/, insert); print}' $FILE > $T3MP  ###NEEDS WORK
        elif [ "$C0MMAND" = "replace_line" ]; then
                awk -v insert="$2" -v line="$3" '{if (NR==line) print insert; else print $0}' $FILE > $T3MP
        fi
        mv $T3MP $F1L3
#IF HELP CALLED    
elif [ "$C0MMAND" = "-h" ] || [ "$C0MMAND" = "--help" ]
    then
        printf "Usage: advTextEdit \$function \$text \$line|\$pattern \$file"
        printf "\n\tFunctions (Non-Case-Sensitive:\n"
        printf "\t\tappendAbove_Pattern:"
        printf "\t\t\tInserts new line containing \$text above line containing \$pattern (does not delete any lines)"
        printf "\n\t\tappendAbove_Line :"
        printf "\t\t\tInserts new line containing \$text on line \$line (does not delete any lines)(line must exsist)"
        printf "\n\t\tappendBelow_Pattern :"
        printf "\t\t\tInserts new line containing \$text below line containing \$pattern (does not delete any lines)"
        printf "\n\t\tappendBelow_Line :"
        printf "\t\t\tInserts new line containing \$text below line \$line (does not delete any lines)(line must exsist)"
        printf "\n\t\tappendTail_Pattern :"
        printf "\t\t\tAdds text to end of line containing \$pattern"
        printf "\n\t\tappendTail_Line :"
        printf "\t\t\tAdds text to end of line \$line (line must exsist)"
        printf "\n\t\tappendHead_Pattern :"
        printf "\t\t\tAdds text to end of line containing \$pattern"
        printf "\n\t\tappendHead_Line :"
        printf "\t\t\tAdds text to end of line \$line (line must exsist)"
        printf "\n\t\treplaceLineContaining_Pattern :"
        printf "\t\t\tReplaceses all text on line that contains \$pattern with \$text"
        printf "\n\t\treplace_Pattern :"
        printf "\t\t\tReplaceses all occurances of \$pattern with \$text"
        printf "\n\t\treplace_Line :"
        printf "\t\t\tReplaces all text on line \$line with \$text"
        printf "\n"
else
    echo "Usage: advTextEdit FUNCTION TEXT LINE|PATTERN FILE"
    echo "Try 'advTextEdit --help' for more information"
fi
}
#THANKS TO http://www.theunixschool.com/2012/06/insert-line-before-or-after-pattern.html

