BEGIN {
    print "<speak>"
    print "    <p>"
    print "        <s>"
    print "            <prosody volume=\"soft\">"
    print "                <lang xml:lang=\"ja-JP\">"
    print "                    さあ、発音記号であらわされる音に注意して、耳をかたむけてください。"
    print "                    <break time=\"1s\" />"
    #print "                    それぞれの英文を二回読みます。"
    #print "                    <break time=\"1s\" />"
    #print "                    はじめはうまく聞き取れなくても、心配する必要はありません。"
    #print "                    <break time=\"1s\" />"
    #print "                    だんだん慣れてきます。"
    #print "                    <break time=\"1s\" />"
    print "                    それでは、始めます。"
    print "                    <break time=\"1s\" />"
    print "                </lang>"
    print "            </prosody>"
    print "        </s>"
    print "    </p>"
    print "</speak>"
    print ""
    print "<speak>"
    print "    <p>"
    print "        <s>"
    print "            <prosody rate=\"slow\" volume=\"loud\">"
    print "                Please listen carefully."
    print "                <break time=\"1s\" />"
}

{
    printf "                Number %d.\n", NR
    printf "                <break time=\"1s\" />\n"
    printf "                %s\n", $0
    printf "                <break time=\"2s\" />\n"
    printf "                %s\n", $0
    printf "                <break time=\"3s\" />\n"
}

END {
    print "            </prosody>"
    print "        </s>"
    print "    </p>"
    print "</speak>"
    print ""
    print "<speak>"
    print "    <p>"
    print "        <s>"
    print "            <prosody volume=\"soft\">"
    print "                <lang xml:lang=\"ja-JP\">"
    print "                    さあ、いかがでしたか。"
    print "                    <break time=\"1s\" />"
    print "                    こんどは、あとに続けて、みなさんがリピートしてください"
    print "                    <break time=\"1s\" />"
    print "                </lang>"
    print "            </prosody>"
    print "        </s>"
    print "    </p>"
    print "</speak>"
    print ""
    print "<speak>"
    print "    <p>"
    print "        <s>"
    print "            <prosody rate=\"slow\" volume=\"loud\">"
    print "                Please repeat after me."
    print "                <break time=\"1s\" />"
    for (i = 1; i <= NR; i++) {
        printf "                Number %d.\n", i
        printf "                <break time=\"1s\" />\n"
        printf "                %s\n", lines[i]
        printf "                <break time=\"5s\" />\n"
        printf "                %s\n", lines[i]
        printf "                <break time=\"3s\" />\n"
    }
    print "                Good job, everyone!"
    print "                <break time=\"1s\" />"
        print "            </prosody>"
    print "        </s>"
    print "    </p>"
    print "</speak>"
}

{
    lines[NR] = $0
}

