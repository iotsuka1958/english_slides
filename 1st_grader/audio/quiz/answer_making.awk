BEGIN {
    FS = ""
    RS = "\n"
}

{
    word = $0
    
    print "<speak>"
    print "<prosody volume=\"x-loud\" rate=\"slow\">"
    print "<p>The answer is \"" word "\". Please listen carefully.<break time=\"3s\"/></p>"
    
    print "<p>"
    for (i = 1; i <= 3; i++) {
        printf "%s.<break time=\"2s\"/>\n", word
    }
    print "</p>"

    print "<p><lang xml:lang=\"ja-JP\">こんどは私に続けてリピートしてください。</lang>Please repeat after me.</p>"
    
    print "<p>"
    for (i = 1; i <= 3; i++) {
        printf "%s.<break time=\"3s\"/>\n", word
    }
    print "</p>"
    
    print "<p>Good job, everyone!</p>"
    print "</prosody>"
    print "</speak>"
    print "%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
}

