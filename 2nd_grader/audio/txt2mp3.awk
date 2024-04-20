#!/usr/bin/awk -f

BEGIN {
    print "<speak>"
    print "<p>Hello everyone. Please listen carefully as I read the example sentences.</p>"
    print "<p><lang xml:lang=\"ja-JP\">さあ、実際の音声によく耳をかたむけてください。それでは、始めます。</lang>Please listen carefully.</p>"
}

{
    sentences[NR] = $0
}

END {
    for (i = 1; i <= NR; i++) {
        print "<p>Number " i ". " sentences[i] " <break time=\"2s\"/>" sentences[i] "<break time=\"3s\"/></p>"
    }
    
    print "<p><lang xml:lang=\"ja-JP\">さあ、いかがでしたか。こんどは、わたしのあとに続けて実際にリピートしてください。</lang>Please repeat after me.</p>"
    
    for (i = 1; i <= NR; i++) {
        print "<p>Number " i ".  " sentences[i] " <break time=\"5s\"/>" sentences[i] "<break time=\"3s\"/></p>"
    }
    print "<p>Good job, everyone! That's all for our pronunciation practice.</p>"
    print "</speak>"
}

