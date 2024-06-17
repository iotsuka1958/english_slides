BEGIN {
    FS = ""
    RS = "\n"
}

{
    letter_count = NF
    
    print "<speak>"
    print "<prosody volume=\"x-loud\" rate=\"slow\">"
    print "<p>Here is today's quiz. I will say " letter_count " letters in a row. Please listen carefully and write them down. These letters will form a word. Please choose what that word represents.<break time=\"3s\"/></p>"
    
    print "<p>"
    for (i = 1; i <= NF; i++) {
        printf "%s.<break time=\"2s\"/>\n", $i
    }
    print "</p>"

    print "<p><lang xml:lang=\"ja-JP\">もう一度いいます。</lang>Please listen carefully and write them down.</p>"
    
    print "<p>"
    for (i = 1; i <= NF; i++) {
        printf "%s.<break time=\"2s\"/>\n", $i
    }
    print "</p>"
    
    print "<p>Good job, everyone! Let's check the answer.</p>"
    print "</prosody>"
    print "</speak>"
    print "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
}

