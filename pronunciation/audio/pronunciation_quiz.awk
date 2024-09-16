BEGIN {
    print "<speak>"
    print "    <p>"
    print "        <s>"
    print "            <prosody volume=\"soft\">"
    print "                <lang xml:lang=\"ja-JP\">"
    print "                    これから単語を聞いてもらいます。"
    print "                    <break time=\"1s\" />"
    print "                    今回、学習した発音記号で示した音声が含まれていたらT、含まれていなければFと答えてください。"
    print "                    <break time=\"1s\" />"
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
    print "                    答え合わせをしましょう。"
    print "                <break time=\"1s\" />"
    print "                </lang>"
    print "            </prosody>"
    print "        </s>"
    print "    </p>"
    print "</speak>"
}

{
    lines[NR] = $0
}

