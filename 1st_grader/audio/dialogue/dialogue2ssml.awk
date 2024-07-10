function insert_breaks(line) {
    gsub(/\./, ".<break time=\"1s\"/>", line)
    return line
}

BEGIN {
    FS = "\n"
}

{
    print "<speak>"
    printf "    <p>\n"
    printf "        <s>\n"
    printf "            <prosody rate=\"slow\" volume=\"loud\">\n"
    
    if (NR % 2 == 0) {
        printf "                <lang xml:lang=\"en-US\">\n"
        printf "                    %s\n", insert_breaks($0)
        printf "                </lang>\n"
    } else {
        printf "            %s\n", insert_breaks($0)
    }
    
    printf "           </prosody>\n"
    printf "        </s>\n"
    printf "    </p>\n"
    print "</speak>"
}
